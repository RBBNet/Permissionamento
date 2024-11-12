// SPDX-License-Identifier: GPL-3.0-only
pragma solidity ^0.8.26;

import "../Governable.sol";

contract GovernableTest is Governable {

    constructor(AdminProxy admins) Governable (admins) {}

    function governanceAllowedFunction() public onlyGovernance {}

    function publiclyAllowedFunction() public {}

}