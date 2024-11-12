// SPDX-License-Identifier: GPL-3.0-only
pragma solidity ^0.8.26;

import "../ConfigurableDuringDeploy.sol";

contract ConfigurableDuringDeployTest is ConfigurableDuringDeploy {

    function configureDuringDeploy() public onlyOwner onlyDuringDeploy {}

    function doSomethingAfterConfiguration() public view onlyIfConfigured {}

}
