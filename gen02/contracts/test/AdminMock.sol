// SPDX-License-Identifier: GPL-3.0-only
pragma solidity 0.8.26;

import "../AdminProxy.sol";

contract AdminMock is AdminProxy {

    mapping (address => bool) public admins;

    function addAdmin(address source) public {
        admins[source] = true;
    }

    function isAuthorized(address source) public view returns (bool) {
        return admins[source];
    }

}
