// SPDX-License-Identifier: GPL-3.0-only
pragma solidity 0.8.26;

import "./Organization.sol";
import "./AccountRulesV2.sol";
import "./Pagination.sol";
import {Address} from "@openzeppelin/contracts/utils/Address.sol";

contract Governance {

    using EnumerableSet for EnumerableSet.UintSet;

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
        string cancelationReason;
    }

    event ProposalCreated(uint indexed proposalId, address creator);
    event OrganizationVoted(uint indexed proposalId, address admin, bool approve);
    event ProposalCanceled(uint indexed proposalId);
    event ProposalFinished(uint indexed proposalId);
    event ProposalApproved(uint indexed proposalId);
    event ProposalRejected(uint indexed proposalId);
    event ProposalExecuted(uint indexed proposalId, address executor);

    error UnauthorizedAccess(address account, string message);
    error IllegalState(string message);
    error InvalidArgument(string message);
    error ProposalNotFound(uint proposalId);

    uint public idSeed = 0;
    Organization immutable public organizations;
    AccountRulesV2 immutable public accounts;
    mapping (uint => ProposalData) public proposals;
    mapping (uint => mapping(uint => ProposalVote)) public votes;
    EnumerableSet.UintSet private _proposalIds;

    modifier onlyActiveGlobalAdmin() {
        if(!accounts.hasRole(GLOBAL_ADMIN_ROLE, msg.sender)) {
            revert UnauthorizedAccess(msg.sender, "Sender is not a global admin");
        }
        if(!accounts.isAccountActive(msg.sender)) {
            revert UnauthorizedAccess(msg.sender, "Sender account is not active");
        }
        _;
    }

    modifier onlyParticipantOrganization(uint proposalId) {
        uint orgId = accounts.getAccount(msg.sender).orgId;
        ProposalData storage proposal = proposals[proposalId];
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
        if(proposals[proposalId].id == 0) {
            revert ProposalNotFound(proposalId);
        }
        _;
    }

    modifier onlyActiveProposal(uint proposalId) {
        if(proposals[proposalId].status != ProposalStatus.Active) {
            revert IllegalState("Proposal is not Active");
        }
        _;
    }

    modifier onlyActiveOrFinishedProposal(uint proposalId) {
        if(proposals[proposalId].status != ProposalStatus.Active && proposals[proposalId].status != ProposalStatus.Finished) {
            revert IllegalState("Proposal is not Active nor Finished");
        }
        _;
    }

    modifier onlyDefinedProposal(uint proposalId) {
        if(proposals[proposalId].result == ProposalResult.Undefined) {
            revert IllegalState("Proposal result is not defined");
        }
        _;
    }

    modifier onlyProponentOrganization(uint proposalId) {
        if(accounts.getAccount(proposals[proposalId].creator).orgId != accounts.getAccount(msg.sender).orgId) {
            revert UnauthorizedAccess(msg.sender, "Sender is not from proponent organization");
        }
        _;
    }

    constructor(Organization orgs, AccountRulesV2 accs) {
        if(address(orgs) == address(0)) {
            revert InvalidArgument("Invalid address for Organization management smart contract");
        }
        if(address(accs) == address(0)) {
            revert InvalidArgument("Invalid address for Account management smart contract");
        }
        organizations = orgs;
        accounts = accs;
    }

    function createProposal(address[] calldata targets, bytes[] memory calldatas, uint blocksDuration, string calldata description) public
        onlyActiveGlobalAdmin returns (uint) {
        if(targets.length != calldatas.length) {
            revert InvalidArgument("Targets and calldatas arrays must have the same length");
        }
        if(blocksDuration == 0) {
            revert InvalidArgument("Duration must be greater than zero blocks");
        }

        uint proposalId = ++idSeed;
        ProposalData storage proposal = proposals[proposalId];
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
        Organization.OrganizationData[] memory allOrgs = organizations.getOrganizations();
        for(uint i = 0; i < allOrgs.length; ++i) {
            if(allOrgs[i].canVote) {
                proposalOrgs.push(allOrgs[i].id);
            }
        }
        _proposalIds.add(proposalId);

        emit ProposalCreated(proposal.id, proposal.creator);

        return proposalId;
    }

    function cancelProposal(uint proposalId, string calldata reason) public onlyActiveGlobalAdmin existentProposal(proposalId)
        onlyProponentOrganization(proposalId) onlyActiveProposal(proposalId) {
        proposals[proposalId].status = ProposalStatus.Canceled;
        proposals[proposalId].cancelationReason = reason;
        emit ProposalCanceled(proposalId);
    }

    function castVote(uint proposalId, bool approve) public
        onlyActiveGlobalAdmin existentProposal(proposalId) onlyActiveProposal(proposalId) onlyParticipantOrganization(proposalId)
        returns (bool) {
        AccountRulesV2.AccountData memory acc = accounts.getAccount(msg.sender);
        if(votes[proposalId][acc.orgId] != ProposalVote.NotVoted) {
            revert IllegalState("Organization has already voted");
        }

        if(_isFinished(proposalId)) {
            return false;
        }

        if(approve) {
            votes[proposalId][acc.orgId] = ProposalVote.Approval;
        }
        else {
            votes[proposalId][acc.orgId] = ProposalVote.Rejection;
        }

        emit OrganizationVoted(proposalId, msg.sender, approve);

        if(proposals[proposalId].result == ProposalResult.Undefined) {
            _majorityAchieved(proposals[proposalId]);
        }

        return true;
    }

    function _isFinished(uint proposalId) private returns (bool) {
        ProposalData storage proposal = proposals[proposalId];
        if(block.number - proposal.creationBlock > proposal.blocksDuration) {
            // Duration of the proposal is exceeded
            _finishProposal(proposal);
            return true;
        }
        return false;
    }

    function _finishProposal(ProposalData storage proposal) private {
        proposal.status = ProposalStatus.Finished;
        emit ProposalFinished(proposal.id);
    }

    function _majorityAchieved(ProposalData storage proposal) private returns (bool) {
        uint majority = (proposal.organizations.length / 2) + 1;
        uint approvalVotes = 0;
        uint rejectionVotes = 0;

        for(uint i = 0; i < proposal.organizations.length; ++i) {
            ProposalVote vote = votes[proposal.id][proposal.organizations[i]];
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

    function executeProposal(uint proposalId) public onlyActiveGlobalAdmin existentProposal(proposalId) 
        onlyActiveOrFinishedProposal(proposalId) onlyParticipantOrganization(proposalId) onlyDefinedProposal(proposalId)
        returns (bytes[] memory) {
        ProposalData storage proposal = proposals[proposalId];
        if(proposal.status != ProposalStatus.Finished) {
            _finishProposal(proposal);
        }

        proposal.status = ProposalStatus.Executed;
        emit ProposalExecuted(proposalId, msg.sender);

        bytes[] memory returnedValues = new bytes[](proposal.targets.length);
        for (uint i = 0; i < proposal.targets.length; ++i) {
            returnedValues[i] = Address.functionCall(proposal.targets[i], proposal.calldatas[i]);
        }

        return returnedValues;
    }

    function getProposal(uint proposalId) public view existentProposal(proposalId) returns (ProposalData memory) {
        return proposals[proposalId];
    }

    function getVotes(uint proposalId) public view returns (ProposalVote[] memory) {
        uint[] storage orgs = proposals[proposalId].organizations;
        ProposalVote[] memory orgVotes = new ProposalVote[](orgs.length);
        for(uint i = 0; i < orgs.length; ++i) {
            orgVotes[i] = votes[proposalId][orgs[i]];
        }
        return orgVotes;
    }

    function getNumberOfProposals() public view returns (uint) {
        return _proposalIds.length();
    }

    function getProposals(uint pageNumber, uint pageSize) public view returns (ProposalData[] memory) {
        uint[] memory page = Pagination.getUintPage(_proposalIds, pageNumber, pageSize);
        ProposalData[] memory props = new ProposalData[](page.length);
        for(uint i = 0; i < props.length; ++i) {
            props[i] = proposals[page[i]];
        }
        return props;
    }

}