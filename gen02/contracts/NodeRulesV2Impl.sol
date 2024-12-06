// SPDX-License-Identifier: GPL-3.0-only
pragma solidity 0.8.26;

import "./NodeRulesV2.sol";
import "./Governable.sol";
import "./AccountRulesV2.sol";

contract NodeRulesV2Impl is NodeRulesV2, Governable {

    AccountRulesV2 public immutable contractRules;
    mapping (uint => NodeData) public allowedNodes;

    constructor(address rulesAddress, AdminProxy adminProxy) Governable(adminProxy) {
        contractRules = AccountRulesV2(rulesAddress); // Define o endereço do contrato A
    }
    
    modifier onlyActiveAdmin() {
        if(!contractRules.hasRole(GLOBAL_ADMIN_ROLE, msg.sender) && !contractRules.hasRole(LOCAL_ADMIN_ROLE, msg.sender)) {
            revert UnauthorizedAccess(msg.sender);
        }
        if(!contractRules.isAccountActive(msg.sender)) {
            revert InactiveAccount(msg.sender, "The account or the respective organization is not active");
        }
        _;
    }

    function addNode(bytes32 enodeHigh,bytes32 enodeLow,NodeType nodeType, string calldata name, uint organization) public onlyGovernance {
        uint256 key = _calculateKey(enodeHigh, enodeLow);
        if (_nodeExists(key)) {
            revert NodeAlreadyExists(enodeHigh, enodeLow, "This node already exists.");
        }

        allowedNodes[key] = NodeData(enodeHigh, enodeLow, nodeType, name, organization, true);
        emit NodeAdded(enodeHigh, enodeLow, msg.sender);
    }

    function removeNode(bytes32 enodeHigh, bytes32 enodeLow) public onlyGovernance {
        uint256 key = _calculateKey(enodeHigh, enodeLow);
        if (!_nodeExists(key)) {
            revert NodeDoesntExist(enodeHigh, enodeLow, "Node does not exist");
        }

        delete allowedNodes[key];
        emit NodeRemoved(enodeHigh, enodeLow, msg.sender);
    }
    
    //TODO: verificar validade das novas informações?
    function updateNode(bytes32 enodeHigh, bytes32 enodeLow, NodeType nodeType, string calldata name) public onlyActiveAdmin {
        uint256 key = _calculateKey(enodeHigh, enodeLow);
        if (!_nodeExists(key)) {
            revert NodeDoesntExist(enodeHigh, enodeLow, "Node does not exist");
        }

        if (bytes(name).length > 0) {
            allowedNodes[key].name = name;
        }
        allowedNodes[key].nodeType = nodeType;

        emit NodeUpdated(enodeHigh, enodeLow, msg.sender);
    }

    function updateNodeStatus(bytes32 enodeHigh, bytes32 enodeLow, bool status) public onlyActiveAdmin {
        uint256 key = _calculateKey(enodeHigh, enodeLow);
        if (!_nodeExists(key)) {
            revert NodeDoesntExist(enodeHigh, enodeLow, "Node does not exist");
        }

        allowedNodes[key].status = status;
        emit NodeStatusUpdated(enodeHigh, enodeLow, msg.sender);
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
        // TODO verificar se o nó está ativo
        uint key = _calculateKey(enodeHigh, enodeLow);
        return _nodeExists(key);
    }

    function _nodeExists(uint nodeKey) private view returns(bool) {
        return allowedNodes[nodeKey].orgId != 0;
    }

    function _calculateKey(bytes32 enodeHigh, bytes32 enodeLow) private pure returns(uint) {
        return uint(keccak256(abi.encodePacked(enodeHigh, enodeLow)));
    }

}
