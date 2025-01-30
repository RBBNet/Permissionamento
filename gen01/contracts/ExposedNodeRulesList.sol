pragma solidity 0.5.9;

import "./NodeRulesList.sol";


contract ExposedNodeRulesList is NodeRulesList {

    //@audit trocar nome do metodo para não ter o _ como prefixo
    function _calculateKey(bytes32 enodeHigh, bytes32 enodeLow) public pure returns(uint256) { // @audit-ok mudança do nome para ficar sem _
        return calculateKey(enodeHigh, enodeLow);
    }

    //@audit trocar nome do metodo para não ter o _ como prefixo
    function _size() public view returns (uint256) {
        return size();
    }

    //@audit trocar nome do metodo para não ter o _ como prefixo
    function _exists(bytes32 enodeHigh, bytes32 enodeLow) public view returns (bool) { // @audit-ok mudança do nome para ficar sem _
        return exists(enodeHigh, enodeLow);
    }

    //@audit trocar nome do metodo para não ter o _ como prefixo
    function _add(bytes32 enodeHigh, bytes32 enodeLow, NodeType nodeType, bytes6 geoHash, string calldata name, string calldata organization) external returns (bool) { // @audit-ok mudança do nome para ficar sem _; mudandoo visibilidade
        return add(enodeHigh, enodeLow, nodeType, geoHash, name, organization);
    }

    //@audit trocar nome do metodo para não ter o _ como prefixo
    function _remove(bytes32 enodeHigh, bytes32 enodeLow) public returns (bool) { // @audit-ok mudança do nome para ficar sem _
        return remove(enodeHigh, enodeLow);
    }
}
