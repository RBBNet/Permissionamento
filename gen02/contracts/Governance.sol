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

    event ProposalCreated(uint indexed proposalId);
    event OrganizationVoted(uint indexed proposalId, uint orgId, bool approve);
    event ProposalCanceled(uint indexed proposalId);
    event ProposalFinished(uint indexed proposalId);
    event ProposalApproved(uint indexed proposalId);
    event ProposalRejected(uint indexed proposalId);
    event ProposalExecuted(uint indexed proposalId);

    error UnauthorizedAccess(address account, string message);
    error IllegalState(string message);
    error InvalidArgument(string message);
    error ProposalNotFound(uint proposalId);

    uint public idSeed = 0;
    Organization immutable public organizations;
    AccountRulesV2 immutable public accounts;
    ProposalData[] public proposals;
    mapping (uint => mapping(uint => ProposalVote)) public votes;

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
        ProposalData storage proposal = _getProposal(proposalId);
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
        if(proposalId == 0 || proposalId > proposals.length) {
            revert ProposalNotFound(proposalId);
        }
        _;
    }

    modifier onlyActiveProposal(uint proposalId) {
        if(_getProposal(proposalId).status != ProposalStatus.Active) {
            revert IllegalState("Proposal is not Active");
        }
        _;
    }

    modifier onlyActiveOrFinishedProposal(uint proposalId) {
        ProposalData storage proposal = _getProposal(proposalId);
        if(proposal.status != ProposalStatus.Active && proposal.status != ProposalStatus.Finished) {
            revert IllegalState("Proposal is not Active nor Finished");
        }
        _;
    }

    modifier onlyDefinedProposal(uint proposalId) {
        if(_getProposal(proposalId).result == ProposalResult.Undefined) {
            revert IllegalState("Proposal result is not defined");
        }
        _;
    }

    modifier onlyProponentOrganization(uint proposalId) {
        if(accounts.getAccount(_getProposal(proposalId).creator).orgId != accounts.getAccount(msg.sender).orgId) {
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

        proposals.push(ProposalData(
            ++idSeed,
            msg.sender,
            targets,
            calldatas,
            blocksDuration,
            description,
            block.number,
            ProposalStatus.Active,
            ProposalResult.Undefined,
            new uint[](0),
            ""
        ));
        ProposalData storage proposal = proposals[idSeed - 1];
        uint[] storage proposalOrgs = proposal.organizations;
        Organization.OrganizationData[] memory allOrgs = organizations.getOrganizations();
        for(uint i = 0; i < allOrgs.length; ++i) {
            if(allOrgs[i].canVote) {
                proposalOrgs.push(allOrgs[i].id);
            }
        }

        emit ProposalCreated(proposal.id);

        return proposal.id;
    }

    function cancelProposal(uint proposalId, string calldata reason) public onlyActiveGlobalAdmin existentProposal(proposalId)
        onlyProponentOrganization(proposalId) onlyActiveProposal(proposalId) {
        ProposalData storage proposal = _getProposal(proposalId);
        proposal.status = ProposalStatus.Canceled;
        proposal.cancelationReason = reason;
        emit ProposalCanceled(proposalId);
    }

    function castVote(uint proposalId, bool approve) public
        onlyActiveGlobalAdmin existentProposal(proposalId) onlyActiveProposal(proposalId) onlyParticipantOrganization(proposalId)
        returns (bool) {
        AccountRulesV2.AccountData memory acc = accounts.getAccount(msg.sender);
        if(votes[proposalId][acc.orgId] != ProposalVote.NotVoted) {
            revert IllegalState("Organization has already voted");
        }

        ProposalData storage proposal = _getProposal(proposalId);
        if(_isFinished(proposal)) {
            return false;
        }

        if(approve) {
            votes[proposalId][acc.orgId] = ProposalVote.Approval;
        }
        else {
            votes[proposalId][acc.orgId] = ProposalVote.Rejection;
        }

        emit OrganizationVoted(proposalId, acc.orgId, approve);

        if(proposal.result == ProposalResult.Undefined) {
            _majorityAchieved(proposal);
        }

        return true;
    }

    function _isFinished(ProposalData storage proposal) private returns (bool) {
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
        ProposalData storage proposal = _getProposal(proposalId);
        if(proposal.status != ProposalStatus.Finished) {
            _finishProposal(proposal);
        }

        proposal.status = ProposalStatus.Executed;
        emit ProposalExecuted(proposalId);

        bytes[] memory returnedValues = new bytes[](proposal.targets.length);
        for (uint i = 0; i < proposal.targets.length; ++i) {
            returnedValues[i] = Address.functionCall(proposal.targets[i], proposal.calldatas[i]);
        }

        return returnedValues;
    }

    function _getProposal(uint proposalId) private view returns (ProposalData storage) {
        ProposalData storage proposal = proposals[proposalId - 1];
        assert(proposal.id == proposalId);
        return proposal;
    }

    function getProposal(uint proposalId) public view existentProposal(proposalId) returns (ProposalData memory) {
        return _getProposal(proposalId);
    }

    function getVotes(uint proposalId) public view returns (ProposalVote[] memory) {
        uint[] storage orgs = _getProposal(proposalId).organizations;
        ProposalVote[] memory orgVotes = new ProposalVote[](orgs.length);
        for(uint i = 0; i < orgs.length; ++i) {
            orgVotes[i] = votes[proposalId][orgs[i]];
        }
        return orgVotes;
    }

    function getNumberOfProposals() public view returns (uint) {
        return proposals.length;
    }

    function getProposals(uint pageNumber, uint pageSize) public view returns (ProposalData[] memory) {
        (uint start, uint stop) = Pagination.getPageBounds(proposals.length, pageNumber, pageSize);
        ProposalData[] memory props = new ProposalData[](stop - start);
        for(uint i = start; i < stop; ++i) {
            props[i - start] = proposals[i];
        }
        return props;
    }

}