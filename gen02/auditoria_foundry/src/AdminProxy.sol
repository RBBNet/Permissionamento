// SPDX-License-Identifier: GPL-3.0-only
pragma solidity 0.8.26;

interface AdminProxy {
    function isAuthorized(address source) external view returns (bool);

    error InvalidSourceAddress(address addr);
}
