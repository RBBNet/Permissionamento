// SPDX-License-Identifier: GPL-3.0-only
pragma solidity 0.8.26;

import "./Organization.sol";
import "./Governable.sol";
import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";

contract OrganizationImpl is Organization, Governable {

    using EnumerableSet for EnumerableSet.UintSet;

    uint public idSeed = 0;
    mapping (uint => OrganizationData) public organizations;
    EnumerableSet.UintSet private organizationIds;

    modifier existentOrganization(uint orgId) {
        if(organizations[orgId].id == 0) {
            revert OrganizationNotFound(orgId);
        }
        _;
    }

    constructor(OrganizationData[] memory orgs, AdminProxy adminsProxy) Governable(adminsProxy) {
        require(orgs.length >= 2, "At least 2 organizations must exist");
        for(uint i = 0; i < orgs.length; ++i) {
            _addOrganization(orgs[i].name, orgs[i].canVote);
        }
    }

    function addOrganization(string calldata name, bool canVote) public onlyGovernance returns (uint) {
        return _addOrganization(name, canVote);
    }

    function _addOrganization(string memory name, bool canVote) private returns (uint) {
        uint newId = ++idSeed; //@audit operação custosa
        OrganizationData memory newOrg = OrganizationData(newId, name, canVote);
        organizations[newId] = newOrg;
        bool success = organizationIds.add(newId); //@audit-ok retorno estava sendo ignorado (poderia levar a um falso entendimento) 
        require(success, "Failed to add organization ID"); 
        emit OrganizationAdded(newId);
        return newId;
    }

    function updateOrganization(uint orgId, string calldata name, bool canVote) public onlyGovernance existentOrganization(orgId) {
        OrganizationData storage org = organizations[orgId];
        org.name = name;
        org.canVote = canVote;
        emit OrganizationUpdated(orgId);
    }

    function deleteOrganization(uint orgId) public onlyGovernance existentOrganization(orgId) {
        if(organizationIds.length() < 3) {
            revert IllegalState("At least 2 organizations must be active");
        }
        delete organizations[orgId];
        bool success = organizationIds.remove(orgId); //@audit-ok retorno estava sendo ignorado (poderia levar a um falso entendimento) 
        require(success, "Failed to remove organization ID");
        emit OrganizationDeleted(orgId);
    }

    function isOrganizationActive(uint orgId) public view returns (bool) {
        return organizations[orgId].id > 0;
    }

    function getOrganization(uint orgId) public view existentOrganization(orgId) returns (OrganizationData memory) {
        return organizations[orgId];
    }

    function getOrganizations() public view returns (OrganizationData[] memory) {
        OrganizationData[] memory orgs = new OrganizationData[](organizationIds.length());
        for(uint i = 0; i < organizationIds.length(); ++i) {
            orgs[i] = organizations[organizationIds.at(i)];
        }
        return orgs;
    }

    function organizationIdsValues() public view returns (uint[] memory) {
        return organizationIds.values();
    }

}