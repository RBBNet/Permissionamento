// SPDX-License-Identifier: GPL-3.0-only
pragma solidity ^0.8.26;

import "@openzeppelin/contracts/access/IAccessControl.sol";
import "./AccountRulesProxy.sol";

bytes32 constant GLOBAL_ADMIN_ROLE = keccak256("GLOBAL_ADMIN_ROLE");
bytes32 constant LOCAL_ADMIN_ROLE = keccak256("LOCAL_ADMIN_ROLE");
bytes32 constant DEPLOYER_ROLE = keccak256("DEPLOYER_ROLE");
bytes32 constant USER_ROLE = keccak256("USER_ROLE");

interface AccountRulesV2 is AccountRulesProxy, IAccessControl {

    struct AccountData {
        uint orgId;
        address account;
        bytes32 roleId;
        bytes32 dataHash;
        bool active;
    }

    event AccountAdded(address account, uint orgId, bytes32 roleId, bytes32 dataHash, address admin);
    event AccountDeleted(address account, uint orgId, address admin);
    event AccountRoleUpdated(address account, uint orgId, bytes32 roleId, address admin);
    event AccountDataHashUpdated(address account, uint orgId, bytes32 dataHash, address admin);
    event AccountStatusUpdated(address account, uint orgId, bool active, address admin);
    event SmartContractStatusUpdated(address smartContract, bool status, address admin);

    error InactiveAccount(address account, string message);
    error InvalidAccount(address account, string message);
    error DuplicateAccount(address account);
    error AccountNotFound(address account);
    error NotLocalAccount(address account, string message);
    error InvalidOrganization(uint orgId, string message);
    error InvalidRole(bytes32 roleId, string message);
    error InvalidHash(bytes32 hash, string message);
    error IllegalState(string message);

    function addLocalAccount(address account, bytes32 roleId, bytes32 dataHash) external;
    function deleteLocalAccount(address account) external;
    function updateLocalAccountRole(address account, bytes32 roleId) external;
    function updateLocalAccountDataHash(address account, bytes32 dataHash) external;
    function updateLocalAccountStatus(address account, bool active) external;

    function addAccount(address account, uint orgId, bytes32 roleId, bytes32 dataHash) external;
    function deleteAccount(address account) external;

    function updateSmartContractStatus(address smartContract, bool status) external;

    function isAccountActive(address account) external view returns (bool);
    function getAccount(address account) external view returns (AccountData memory);

}