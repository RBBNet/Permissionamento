// SPDX-License-Identifier: GPL-3.0-only
pragma solidity ^0.8.26;

abstract contract ConfigurableDuringDeploy {

    address private _owner;
    bool private _configured;

    error NotOwnerAccount(address account);
    error AlreadyConfigured();
    error NotConfigured();

    modifier onlyOwner() {
        if(_owner != msg.sender) {
            revert NotOwnerAccount(msg.sender);
        }
        _;
    }

    modifier onlyDuringDeploy() {
        if(_configured) {
            revert AlreadyConfigured();
        }
        _;
    }

    modifier onlyIfConfigured() {
        if(!_configured) {
            revert NotConfigured();
        }
        _;
    }

    constructor() {
        _owner = msg.sender;
    }

    function finishConfiguration() public onlyOwner onlyDuringDeploy {
        _configured = true;
    }

}