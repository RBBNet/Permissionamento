// SPDX-License-Identifier: GPL-3.0-only
pragma solidity ^0.8.26;

import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";
import "./AccountRulesV2.sol";
import "./ConfigurableDuringDeploy.sol";
import "./Governable.sol";
import "./Organization.sol";

contract AccountRulesV2Impl is AccountRulesV2, ConfigurableDuringDeploy, Governable, AccessControl {

    Organization private _organizations;
    mapping (address => AccountData) private _accounts;
    mapping (uint => uint) private _globalAdminsCount;
    mapping (bytes32 => bool) private _validRoles;

    modifier onlyActiveAdmin() {
        if(!hasRole(GLOBAL_ADMIN_ROLE, msg.sender) && !hasRole(LOCAL_ADMIN_ROLE, msg.sender)) {
            revert UnauthorizedAccess(msg.sender);
        }
        if(!isAccountActive(msg.sender)) {
            revert InactiveAccount(msg.sender);
        }
        _;
    }

    modifier validAccount(address account) {
        if(account == address(0)) {
            revert InvalidAccount(account);
        }
        _;
    }

    modifier inexistentAccount(address account) {
        if(_accounts[account].account != address(0)) {
            revert DuplicateAccount(account);
        }
        _;
    }

    modifier existentAccount(address account) {
        if(_accounts[account].account == address(0)) {
            revert AccountNotFound(account);
        }
        _;
    }

    modifier validRole(bytes32 roleId) {
        if(!_validRoles[roleId]) {
            revert InvalidRole(roleId);
        }
        _;
    }

    modifier notGlobalAdminRole(bytes32 roleId) {
        if(roleId == GLOBAL_ADMIN_ROLE) {
            revert InvalidRole(roleId);
        }
        _;
    }

    modifier notGlobalAdminAccount(address account) {
        if(_accounts[account].roleId == GLOBAL_ADMIN_ROLE) {
            revert InvalidRole(GLOBAL_ADMIN_ROLE);
        }
        _;
    }

    modifier validHash(bytes32 hash) {
        if(hash == 0) {
            revert InvalidHash(hash);
        }
        _;
    }

    modifier validOrganization(uint orgId) {
        if(!_organizations.isOrganizationActive(orgId)) {
            revert InvalidOrganization(orgId);
        }
        _;
    }

    modifier sameOrganization(address account) {
        if(_accounts[msg.sender].orgId != _accounts[account].orgId) {
            revert NotLocalAccount(account);
        }
        _;
    }

    constructor(address[] memory accs, AdminProxy admins) Governable(admins) {
        require(accs.length >= 2, "At least 2 accounts must exist");
        for(uint i = 0; i < accs.length; ++i) {
            // Inclui as contas informadas como administradores globais,
            // utilizando suas posições no array para identificar as organizações.
            address account = accs[i];
            uint orgId = i + 1;
            // TODO Deveria ser necessário informar hash?
            _addAccount(account, orgId, GLOBAL_ADMIN_ROLE, 0);
        }
        _validRoles[GLOBAL_ADMIN_ROLE] = true;
        _validRoles[LOCAL_ADMIN_ROLE] = true;
        _validRoles[DEPLOYER_ROLE] = true;
        _validRoles[USER_ROLE] = true;
    }

    function configure(Organization organizations) public onlyOwner onlyDuringDeploy {
        require(address(organizations) != address(0), "Invalid address for Organization management smart contract");
        _organizations = organizations;
        finishConfiguration();
    }

    function addLocalAccount(address account, bytes32 roleId, bytes32 dataHash) public
        onlyActiveAdmin validAccount(account) inexistentAccount(account) validRole(roleId) notGlobalAdminRole(roleId)
        validHash(dataHash) {
        AccountData memory adminAccount = _accounts[msg.sender];
        _addAccount(account, adminAccount.orgId, roleId, dataHash);
    }

    function deleteLocalAccount(address account) public
        onlyActiveAdmin existentAccount(account) sameOrganization(account) notGlobalAdminAccount(account) {
        _deleteAccount(account);
    }

    function updateLocalAccountRole(address account, bytes32 roleId) public onlyActiveAdmin {
        // TODO implementar
    }

    function updateLocalAccountHash(address account, bytes32 dataHash) public onlyActiveAdmin {
        // TODO implementar
    }

    function updateLocalAccountStatus(address account, bool active) public onlyActiveAdmin {
        // TODO implementar
    }

    function addAccount(address account, uint orgId, bytes32 roleId, bytes32 dataHash) public
        onlyGovernance validAccount(account) inexistentAccount(account) validOrganization(orgId)
        validRole(roleId) validHash(dataHash) {
        _addAccount(account, orgId, roleId, dataHash);
    }

    function _addAccount(address account, uint orgId, bytes32 roleId, bytes32 dataHash) private {
        AccountData memory newAccount = AccountData(orgId, account, roleId, dataHash, true);
        _accounts[account] = newAccount;
        _grantRole(roleId, account);
        _incrementGlobalAdminCount(orgId, roleId);
        emit AccountAdded(account, orgId, roleId, dataHash, msg.sender);
    }

    function deleteAccount(address account) public onlyGovernance existentAccount(account) {
        if(_getGlobalAdminCount(_accounts[account].orgId) < 2) {
            revert IllegalState("At least 1 global administrator must be active");
        }
        _deleteAccount(account);
    }

    function _deleteAccount(address account) private {
        AccountData memory acc = _accounts[account];
        _revokeRole(acc.roleId, account);
        delete _accounts[account];
        _decrementGlobalAdminCount(acc.orgId, acc.roleId);
        emit AccountDeleted(account, acc.orgId, msg.sender);
    }

    function _incrementGlobalAdminCount(uint orgId, bytes32 roleId) private {
        if(roleId == GLOBAL_ADMIN_ROLE) {
            _globalAdminsCount[orgId] = _globalAdminsCount[orgId] + 1;
        }
    }

    function _decrementGlobalAdminCount(uint orgId, bytes32 roleId) private {
        if(roleId == GLOBAL_ADMIN_ROLE) {
            _globalAdminsCount[orgId] = _globalAdminsCount[orgId] - 1;
        }
    }

    function _getGlobalAdminCount(uint orgId) private view returns (uint) {
        return _globalAdminsCount[orgId];
    }

    function updateSmartContractStatus(address smartContract, bool status) public onlyGovernance {
        // TODO Implementar
    }

    function getAccount(address account) public view existentAccount(account) returns (AccountData memory) {
        return _accounts[account];
    }

    function isAccountActive(address account) public view returns (bool) {
        AccountData memory acc = _accounts[account];
        return acc.account != address(0) && _organizations.isOrganizationActive(acc.orgId);
    }

    function transactionAllowed(
        address sender,
        address target,
        uint256,
        uint256,
        uint256,
        bytes calldata
    ) external view returns (bool) {
        require(isAccountActive(sender), "Sender account is not active");
        if(address(0) == target) {
            // Implantação de smart contract
            require(hasRole(DEPLOYER_ROLE, sender) || hasRole(LOCAL_ADMIN_ROLE, sender) || hasRole(GLOBAL_ADMIN_ROLE, sender), "Account must have authorized role");
        }
        return true;
    }

}