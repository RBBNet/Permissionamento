// SPDX-License-Identifier: GPL-3.0-only
pragma solidity 0.8.26;

interface Organization {

    struct OrganizationData {
        uint id;
        string name;
        bool canVote;
    }

    event OrganizationAdded(uint indexed orgId, string name, bool canVote);
    event OrganizationUpdated(uint indexed orgId, string name, bool canVote);
    event OrganizationDeleted(uint indexed orgId);

    error OrganizationNotFound(uint orgId);
    error IllegalState(string message);

    // Funções disponíveis apenas para a governança
    function addOrganization(string calldata name, bool canVote) external returns (uint);
    function updateOrganization(uint orgId, string calldata name, bool canVote) external;
    function deleteOrganization(uint orgId) external;

    // Funções disponíveis publicamente
    function isOrganizationActive(uint orgId) external view returns (bool);
    function getOrganization(uint orgId) external view returns (OrganizationData memory);
    function getOrganizations() external view returns (OrganizationData[] memory);

}