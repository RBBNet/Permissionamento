pragma solidity 0.6.0;

interface AdminProxy {
    function isAuthorized(address source) external view returns (bool);
}
