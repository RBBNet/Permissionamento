// SPDX-License-Identifier: GPL-3.0-only
pragma solidity 0.8.26;

import "./NodeRulesV2.sol";
import "./Governable.sol";
import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";

interface AccountRulesV2 {
    function isAccountActive(address account) external view returns (bool);
}

contract NodeRulesV2Impl is NodeRulesV2, AccessControl {
    enode[] public allowlist;
    mapping (uint256 => uint256) private indexOf; 


    AccountRulesV2 public contractRules;

    constructor(address rulesAddress) {
        contractRules = AccountRulesV2(rulesAddress); // Define o endereço do contrato A
    }
    
     modifier onlyActiveAdmin() {
        if(!hasRole(GLOBAL_ADMIN_ROLE, msg.sender) && !hasRole(LOCAL_ADMIN_ROLE, msg.sender)) {
            revert UnauthorizedAccess(msg.sender);
        }
        if(!checkAccountStatus(msg.sender)) {
            revert InactiveAccount(msg.sender, "The account or the respective organization is not active");
        }
        _;
    }

    function checkAccountStatus(address account) public view returns (bool) {
        return contractRules.isAccountActive(account); // Chama a função no contrato A
    }

    function addNode(bytes32 _enodeHigh,bytes32 _enodeLow,NodeType _nodeType, string memory _name,string memory _organization) public onlyActiveAdmin returns (bool) {
        uint256 key = calculateKey(_enodeHigh, _enodeLow);
        if (indexOf[key] != 0) {
            revert NodeAlreadyExists(_enodeHigh, _enodeLow, "This node already exists.");
        }

        allowlist.push(enode(_enodeHigh, _enodeLow, _nodeType, _name, _organization, "Active"));
        indexOf[key] = allowlist.length;
        emit NodeAdded(_enodeHigh, _enodeLow, msg.sender);
        return true;
    }

    function removeNode(bytes32 _enodeHigh, bytes32 _enodeLow) public returns (bool){
        uint256 key = calculateKey(_enodeHigh, _enodeLow);
        uint256 index = indexOf[key];

        if (index == 0) {
            revert NodeDoesntExist(_enodeHigh, _enodeLow, "Node does not exist");
        }

        require(index <= allowlist.length, "Index out of bounds");

        // Move the last node into the removed spot, unless it's the last one
        if (index != allowlist.length) {
            enode memory lastNode = allowlist[allowlist.length - 1];
            allowlist[index - 1] = lastNode;
            indexOf[calculateKey(lastNode.enodeHigh, lastNode.enodeLow)] = index;
        }

        // Remove the last element using `pop()`
        allowlist.pop();
        indexOf[key] = 0;

        emit NodeRemoved(_enodeHigh, _enodeLow, msg.sender);

        return true;
    }
    


    //TODO: verificar validade das novas informações?
    function updateNode(bytes32 _enodeHigh, bytes32 _enodeLow, NodeType _nodeType, string memory _name) public returns (bool){
        uint256 key = calculateKey(_enodeHigh, _enodeLow);
        uint256 index = indexOf[key];
        if (index == 0) {
            revert NodeDoesntExist(_enodeHigh, _enodeLow, "Node does not exist");
        }

        enode storage nodeToUpdate = allowlist[index - 1]; // 1-based indexing

        if (bytes(_name).length > 0) {
            nodeToUpdate.name = _name;
        }
        nodeToUpdate.nodeType = _nodeType;

         emit NodeUpdated(_enodeHigh, _enodeLow, msg.sender);

        return true;
    }

    function updateNodeStatus(bytes32 _enodeHigh, bytes32 _enodeLow, string memory _status) public returns (bool){
        uint256 key = calculateKey(_enodeHigh, _enodeLow);
        uint256 index = indexOf[key];

        if (index == 0) {
            revert NodeDoesntExist(_enodeHigh, _enodeLow, "Node does not exist");
        }

        if (bytes(_status).length > 0) {
            allowlist[index - 1].status = _status;
            emit NodeStatusUpdated(_enodeHigh, _enodeLow, msg.sender);
            return true;
        }
        return false;
    }

    function connectionAllowed(
        bytes32 sourceEnodeHigh,
        bytes32 sourceEnodeLow,
        bytes16,
        uint16,
        bytes32 destinationEnodeHigh,
        bytes32 destinationEnodeLow,
        bytes16,
        uint16
    ) public view returns (bytes32) {
        if (
            enodePermitted (
                sourceEnodeHigh,
                sourceEnodeLow
            ) && enodePermitted(
                destinationEnodeHigh,
                destinationEnodeLow
            )
        ) {
            return 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
        } else {
            return 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
        }
    }

    function enodePermitted(
        bytes32 enodeHigh,
        bytes32 enodeLow
    ) public view returns (bool) {
        return exists(enodeHigh, enodeLow);
    }

     function exists(bytes32 _enodeHigh, bytes32 _enodeLow) internal view returns (bool) {
        return indexOf[calculateKey(_enodeHigh, _enodeLow)] != 0;
    }

     function calculateKey(bytes32 _enodeHigh, bytes32 _enodeLow) internal pure returns(uint256) {
        return uint256(keccak256(abi.encodePacked(_enodeHigh, _enodeLow)));
    }

}
