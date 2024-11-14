// SPDX-License-Identifier: GPL-3.0-only
pragma solidity ^0.8.26;

import "./AdminProxy.sol";

abstract contract Governable {

    AdminProxy private _admins;

    error UnauthorizedAccess(address account);

    modifier onlyGovernance() {
        if(!_admins.isAuthorized(msg.sender)) {
            revert UnauthorizedAccess(msg.sender);
        }
        _;
    }

    constructor(AdminProxy admins) {
        require(address(admins) != address(0), "Invalid address for Admin management smart contract");
        _admins = admins;
   }

}