// SPDX-License-Identifier: GPL-3.0-only
pragma solidity ^0.8.26;

import "./Organization.sol";
import "./Governable.sol";
import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";

contract OrganizationImpl is Organization, Governable {

    using EnumerableSet for EnumerableSet.UintSet;

    uint private _idSeed = 0;
    mapping (uint => OrganizationData) private _organizations;
    EnumerableSet.UintSet private _organizationIds;

    modifier existentOrganization(uint orgId) {
        if(_organizations[orgId].id == 0) {
            revert OrganizationNotFound(orgId);
        }
        _;
    }

    constructor(OrganizationData[] memory orgs, AdminProxy admins) Governable(admins) {
        require(orgs.length >= 2, "At least 2 organizations must exist");
        for(uint i = 0; i < orgs.length; ++i) {
            _addOrganization(orgs[i].name, orgs[i].canVote);
        }
    }

    function addOrganization(string memory name, bool canVote) public onlyGovernance returns (uint) {
        return _addOrganization(name, canVote);
    }

    function _addOrganization(string memory name, bool canVote) private returns (uint) {
        // TODO validar nome?
        uint newId = ++_idSeed;
        OrganizationData memory newOrg = OrganizationData(newId, name, canVote);
        _organizations[newId] = newOrg;
        _organizationIds.add(newId);
        emit OrganizationAdded(newId);
        return newId;
    }

    function updateOrganization(uint orgId, string memory name, bool canVote) public onlyGovernance existentOrganization(orgId) {
        // TODO validar nome?
        OrganizationData storage org = _organizations[orgId];
        org.name = name;
        org.canVote = canVote;
        emit OrganizationUpdated(orgId);
    }

    function deleteOrganization(uint orgId) public onlyGovernance existentOrganization(orgId) {
        if(_organizationIds.length() < 3) {
            revert IllegalState("At least 2 organizations must be active");
        }
        delete _organizations[orgId];
        _organizationIds.remove(orgId);
        emit OrganizationDeleted(orgId);
    }

    function isOrganizationActive(uint orgId) public view returns (bool) {
        return _organizations[orgId].id > 0;
    }

    function getOrganization(uint orgId) public view existentOrganization(orgId) returns (OrganizationData memory) {
        return _organizations[orgId];
    }

    function getOrganizations() public view returns (OrganizationData[] memory) {
        OrganizationData[] memory organizations = new OrganizationData[](_organizationIds.length());
        for(uint i = 0; i < _organizationIds.length(); ++i) {
            organizations[i] = _organizations[_organizationIds.at(i)];
        }
        return organizations;
    }

}