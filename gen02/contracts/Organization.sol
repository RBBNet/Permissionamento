// SPDX-License-Identifier: GPL-3.0-only
pragma solidity 0.8.26;

interface Organization {

    struct OrganizationData {
        uint id;
        string name;
        bool canVote;
    }

    event OrganizationAdded(uint orgId);
    event OrganizationUpdated(uint orgId);
    event OrganizationDeleted(uint orgId);

    error OrganizationNotFound(uint orgId);
    error IllegalState(string message);

    function addOrganization(string memory name, bool canVote) external returns (uint);
    function updateOrganization(uint orgId, string memory name, bool canVote) external;
    function deleteOrganization(uint orgId) external;

    function isOrganizationActive(uint orgId) external view returns (bool);
    function getOrganization(uint orgId) external view returns (OrganizationData memory);
    function getOrganizations() external view returns (OrganizationData[] memory);

}