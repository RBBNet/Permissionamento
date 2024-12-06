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

    function addNode(bytes32 _enodeHigh,bytes32 _enodeLow,NodeType _nodeType, string memory _name, uint _organization) public onlyGovernance {
        uint256 key = _calculateKey(_enodeHigh, _enodeLow);
        if (_nodeExists(key)) {
            revert NodeAlreadyExists(_enodeHigh, _enodeLow, "This node already exists.");
        }

        allowedNodes[key] = NodeData(_enodeHigh, _enodeLow, _nodeType, _name, _organization, true);
        emit NodeAdded(_enodeHigh, _enodeLow, msg.sender);
    }

    function removeNode(bytes32 _enodeHigh, bytes32 _enodeLow) public onlyGovernance {
        uint256 key = _calculateKey(_enodeHigh, _enodeLow);
        if (!_nodeExists(key)) {
            revert NodeDoesntExist(_enodeHigh, _enodeLow, "Node does not exist");
        }

        delete allowedNodes[key];
        emit NodeRemoved(_enodeHigh, _enodeLow, msg.sender);
    }
    
    //TODO: verificar validade das novas informações?
    function updateNode(bytes32 _enodeHigh, bytes32 _enodeLow, NodeType _nodeType, string memory _name) public onlyActiveAdmin {
        uint256 key = _calculateKey(_enodeHigh, _enodeLow);
        if (!_nodeExists(key)) {
            revert NodeDoesntExist(_enodeHigh, _enodeLow, "Node does not exist");
        }

        if (bytes(_name).length > 0) {
            allowedNodes[key].name = _name;
        }
        allowedNodes[key].nodeType = _nodeType;

        emit NodeUpdated(_enodeHigh, _enodeLow, msg.sender);
    }

    function updateNodeStatus(bytes32 _enodeHigh, bytes32 _enodeLow, bool _status) public onlyActiveAdmin {
        uint256 key = _calculateKey(_enodeHigh, _enodeLow);
        if (!_nodeExists(key)) {
            revert NodeDoesntExist(_enodeHigh, _enodeLow, "Node does not exist");
        }

        allowedNodes[key].status = _status;
        emit NodeStatusUpdated(_enodeHigh, _enodeLow, msg.sender);
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
