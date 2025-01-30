pragma solidity 0.5.9;

import "./AdminProxy.sol";
import "./AdminList.sol";


contract Admin is AdminProxy, AdminList {
    modifier onlyAdmin() {
        require(isAuthorized(msg.sender), "Sender not authorized");
        _;
    }

    modifier notSelf(address addr) { // @audit-ok mudança do nome para ficar sem _
        require(msg.sender != addr, "Cannot invoke method with own account as parameter");
        _;
    }

    constructor() public {
        add(msg.sender);
    }

    function isAuthorized(address addr) public view returns (bool) { // @audit-ok mudança do nome para ficar sem _
        return exists(addr);
    }

    function addAdmin(address addr) public onlyAdmin returns (bool) {
        if (msg.sender == addr) {
            emit AdminAdded(false, addr, msg.sender, block.timestamp, "Adding own account as Admin is not permitted");
            return false;
        } else {
            bool result = add(addr);
            string memory message = result ? "Admin account added successfully" : "Account is already an Admin";
            emit AdminAdded(result, addr, msg.sender, block.timestamp, message);
            return result;
        }
    }

    function removeAdmin(address addr) public onlyAdmin notSelf(addr) returns (bool) { // @audit-ok mudança do nome para ficar sem _
        bool removed = remove(addr);
        emit AdminRemoved(removed, addr, msg.sender, block.timestamp);
        return removed;
    }

    function getAdmins() public view returns (address[] memory){
        return allowlist;
    }

    function addAdmins(address[] calldata accounts) external onlyAdmin returns (bool) { //@audit-ok mudando a visibilidade e para calldata
        return addAll(accounts, msg.sender);
    }
}
