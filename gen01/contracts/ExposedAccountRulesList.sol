pragma solidity 0.5.9;

import "./AccountRulesList.sol";


contract ExposedAccountRulesList is AccountRulesList {

    //@audit trocar nome do metodo para não ter o _ como prefixo
    function _size() public view returns (uint256) {
        return size();
    }

    //@audit trocar nome do metodo para não ter o _ como prefixo
    function _exists(address account) public view returns (bool) { // @audit-ok mudança do nome para ficar sem _
        return exists(account);
    }

    //@audit trocar nome do metodo para não ter o _ como prefixo
    function _add(address account) public returns (bool) { // @audit-ok mudança do nome para ficar sem _
        return add(account);
    }

    //@audit trocar nome do metodo para não ter o _ como prefixo
    function _addAll(address[] calldata accounts) external returns (bool) { //@audit-ok mudando a visibilidade e para calldata
        return addAll(accounts, msg.sender);
    }

    //@audit trocar nome do metodo para não ter o _ como prefixoz
    function _remove(address account) public returns (bool) { // @audit-ok mudança do nome para ficar sem _
        return remove(account);
    }
}
