pragma solidity 0.5.9;

import "./AdminList.sol";


// This class is used as a proxy to allow us to write unit tests.
// All methods in the original class are internal.
contract ExposedAdminList is AdminList {

    //@audit trocar nome do metodo para não ter o _ como prefixo
    function _size() public view returns (uint256) {
        return size();
    }

    //@audit trocar nome do metodo para não ter o _ como prefixo
    function _exists(address addr) public view returns (bool) { // @audit-ok mudança do nome para ficar sem _
        return exists(addr);
    }

    //@audit trocar nome do metodo para não ter o _ como prefixo
    function _add(address addr) public returns (bool) { // @audit-ok mudança do nome para ficar sem _
        return add(addr);
    }

    //@audit trocar nome do metodo para não ter o _ como prefixo
    function _remove(address addr) public returns (bool) { // @audit-ok mudança do nome para ficar sem _
        return remove(addr);
    }

    //@audit trocar nome do metodo para não ter o _ como prefixo
    function _addBatch(address[] calldata addrs) external returns (bool) { // @audit-ok mudança do nome para ficar sem _
        return addAll(addrs, msg.sender);
    }
}
