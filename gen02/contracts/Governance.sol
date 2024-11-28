// SPDX-License-Identifier: GPL-3.0-only
pragma solidity ^0.8.26;

import "./Organization.sol";
import "./AccountRulesV2.sol";

contract Governance {

    enum ProposalStatus { Undefined, Active, Canceled, Finished, Executed }
    enum ProposalResult { Undefined, Approved, Rejected }
    enum ProposalVote { NotVoted, Approval, Rejection }

    struct ProposalData {
        uint id;
        address creator;
        address[] targets;
        bytes[] calldatas;
        uint blocksDuration;
        string description;
        uint creationBlock;
        ProposalStatus status;
        ProposalResult result;
        uint[] organizations;
    }

    event ProposalCreated(uint proposalId, address creator);
    event OrganizationVoted(uint proposalId, address admin, bool approve);
    event ProposalApproved(uint proposalId);
    event ProposalRejected(uint proposalId);

    error UnauthorizedAccess(address account, string message);
    error IllegalState(string message);
    error InvalidArgument(string message);
    error ProposalNotFound(uint proposalId);

    Organization private _organizations;
    AccountRulesV2 private _accounts;
    mapping (uint => ProposalData) private _proposals;
    mapping (uint => mapping(uint => ProposalVote)) private _votes;

    modifier onlyActiveGlobalAdmin() {
        if(!_accounts.hasRole(GLOBAL_ADMIN_ROLE, msg.sender)) {
            revert UnauthorizedAccess(msg.sender, "Sender is not a global admin");
        }
        if(!_accounts.isAccountActive(msg.sender)) {
            revert UnauthorizedAccess(msg.sender, "Sender account is not active");
        }
        _;
    }

    modifier onlyParticipantOrganization(uint proposalId) {
        uint orgId = _accounts.getAccount(msg.sender).orgId;
        ProposalData storage proposal = _proposals[proposalId];
        bool participates = false;
        for(uint i = 0; i < proposal.organizations.length && !participates; ++i) {
            if(orgId == proposal.organizations[i]) {
                participates = true;
            }
        }
        if(!participates) {
            revert UnauthorizedAccess(msg.sender, "Sender's organization does not participate on the proposal");
        }
        _;
    }

    modifier existentProposal(uint proposalId) {
        if(_proposals[proposalId].id == 0) {
            revert ProposalNotFound(proposalId);
        }
        _;
    }
    modifier onlyActiveProposal(uint proposalId) {
        if(_proposals[proposalId].status != ProposalStatus.Active) {
            revert IllegalState("Proposal is not Active");
        }
        _;
    }

    modifier onlyCreator(uint proposalId) {
        if(_proposals[proposalId].creator != msg.sender) {
            revert UnauthorizedAccess(msg.sender, "Sender is not the poll creator");
        }
        _;
    }

    modifier durationNotExceeded(uint proposalId) {
        ProposalData storage proposal = _proposals[proposalId];
        if(block.number - proposal.creationBlock > proposal.blocksDuration) {
            revert IllegalState("Proposal duration has been exceeded");
        }
        _;
    }

    constructor(Organization organizations, AccountRulesV2 accounts) {
        if(address(organizations) == address(0)) {
            revert InvalidArgument("Invalid address for Organization management smart contract");
        }
        if(address(accounts) == address(0)) {
            revert InvalidArgument("Invalid address for Account management smart contract");
        }
        _organizations = organizations;
        _accounts = accounts;
    }

    function createProposal(address[] memory targets, bytes[] memory calldatas, uint blocksDuration, string memory description) public
        onlyActiveGlobalAdmin returns (uint) {
        if(targets.length != calldatas.length) {
            revert InvalidArgument("Targets and calldatas arrays must have the same length");
        }
        if(blocksDuration == 0) {
            revert InvalidArgument("Duration must be greater than zero blocks");
        }

        uint proposalId = uint(keccak256(abi.encode(targets, calldatas, blocksDuration, description)));
        ProposalData storage proposal = _proposals[proposalId];
        proposal.id = proposalId;
        proposal.creator = msg.sender;
        proposal.targets = targets;
        proposal.calldatas = calldatas;
        proposal.blocksDuration = blocksDuration;
        proposal.description = description;
        proposal.creationBlock = block.number;
        proposal.status = ProposalStatus.Active;
        proposal.result = ProposalResult.Undefined;
        uint[] storage proposalOrgs = proposal.organizations;
        Organization.OrganizationData[] memory allOrgs = _organizations.getOrganizations();
        for(uint i = 0; i < allOrgs.length; ++i) {
            if(allOrgs[i].canVote) {
                proposalOrgs.push(allOrgs[i].id);
            }
        }

        emit ProposalCreated(proposal.id, proposal.creator);

        return proposalId;
    }

    function cancelProposal(uint proposalId) public onlyActiveGlobalAdmin onlyCreator(proposalId) {
    }

    function castVote(uint proposalId, bool approve) public
        onlyActiveGlobalAdmin existentProposal(proposalId) onlyActiveProposal(proposalId) durationNotExceeded(proposalId)
        onlyParticipantOrganization(proposalId) {
        AccountRulesV2.AccountData memory acc = _accounts.getAccount(msg.sender);
        if(_votes[proposalId][acc.orgId] != ProposalVote.NotVoted) {
            revert IllegalState("Organization has already voted");
        }

        if(approve) {
            _votes[proposalId][acc.orgId] = ProposalVote.Approval;
        }
        else {
            _votes[proposalId][acc.orgId] = ProposalVote.Rejection;
        }

        emit OrganizationVoted(proposalId, msg.sender, approve);

        if(_proposals[proposalId].result == ProposalResult.Undefined) {
            _majorityAchieved(_proposals[proposalId]);
        }
    }

    function _majorityAchieved(ProposalData storage proposal) private returns (bool) {
        uint majority = (proposal.organizations.length / 2) + 1;
        uint approvalVotes = 0;
        uint rejectionVotes = 0;

        for(uint i = 0; i < proposal.organizations.length; ++i) {
            ProposalVote vote = _votes[proposal.id][proposal.organizations[i]];
            if(vote == ProposalVote.Approval) {
                ++approvalVotes;
            }
            else if(vote == ProposalVote.Rejection) {
                ++rejectionVotes;
            }
        }

        if(approvalVotes >= majority) {
            proposal.result = ProposalResult.Approved;
            emit ProposalApproved(proposal.id);
            return true;
        }

        if(rejectionVotes >= majority) {
            proposal.result = ProposalResult.Rejected;
            emit ProposalRejected(proposal.id);
            return true;
        }

        if(approvalVotes + rejectionVotes == proposal.organizations.length) {
            // Empate
            proposal.result = ProposalResult.Rejected;
            emit ProposalRejected(proposal.id);
        }

        return false;
    }

    function executeProposal(uint proposalId) public onlyActiveGlobalAdmin onlyParticipantOrganization(proposalId) {
    }

    function getProposal(uint proposalId) public view existentProposal(proposalId) returns (ProposalData memory) {
        return _proposals[proposalId];
    }

    function getVotes(uint proposalId) public view returns (ProposalVote[] memory) {
        uint[] storage orgs = _proposals[proposalId].organizations;
        ProposalVote[] memory orgVotes = new ProposalVote[](orgs.length);
        for(uint i = 0; i < orgs.length; ++i) {
            orgVotes[i] = _votes[proposalId][orgs[i]];
        }
        return orgVotes;
    }

}