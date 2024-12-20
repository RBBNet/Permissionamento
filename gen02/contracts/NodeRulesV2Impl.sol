// SPDX-License-Identifier: GPL-3.0-only
pragma solidity 0.8.26;

import "./NodeRulesV2.sol";
import "./Governable.sol";
import "./AccountRulesV2.sol";
import "./Organization.sol";

contract NodeRulesV2Impl is NodeRulesV2, Governable {

    AccountRulesV2 public immutable accountsContract;
    Organization public immutable organizationsContract;
    mapping (uint => NodeData) public allowedNodes;

    constructor(Organization orgs, AccountRulesV2 accs, AdminProxy adminProxy) Governable(adminProxy) {
        if(address(orgs) == address(0)) {
            revert InvalidArgument("Invalid address for Organization management smart contract");
        }
        if(address(accs) == address(0)) {
            revert InvalidArgument("Invalid address for Account management smart contract");
        }
        organizationsContract = orgs;
        accountsContract = accs;
    }
    
    modifier onlyActiveAdmin() {
        if(!accountsContract.hasRole(GLOBAL_ADMIN_ROLE, msg.sender) && !accountsContract.hasRole(LOCAL_ADMIN_ROLE, msg.sender)) {
            revert UnauthorizedAccess(msg.sender);
        }
        if(!accountsContract.isAccountActive(msg.sender)) {
            revert InactiveAccount(msg.sender, "The account or the respective organization is not active");
        }
        _;
    }

    //USNOD01 - OK
    function addLocalNode(bytes32 enodeHigh, bytes32 enodeLow, NodeType nodeType, string calldata name) public onlyActiveAdmin {
        AccountRulesV2.AccountData memory acc = accountsContract.getAccount(msg.sender);
        _addNode(enodeHigh, enodeLow, nodeType, name, acc.orgId);
    }

    //USNOD05 - OK
    function addNode(bytes32 enodeHigh, bytes32 enodeLow, NodeType nodeType, string calldata name, uint organization) public onlyGovernance {
        if(!organizationsContract.isOrganizationActive(organization)) {
            revert InvalidOrganization(organization);
        }
        _addNode(enodeHigh, enodeLow, nodeType, name, organization);
    }

    function _addNode(bytes32 enodeHigh, bytes32 enodeLow, NodeType nodeType, string calldata name, uint organization) private {
        uint256 key = _calculateKey(enodeHigh, enodeLow);
        _revertIfDuplicateNode(enodeHigh, enodeLow, key);
        _revertIfInvalidName(name);
        allowedNodes[key] = NodeData(enodeHigh, enodeLow, nodeType, name, organization, true);
        emit NodeAdded(enodeHigh, enodeLow, msg.sender);
    }

    //USNOD06 - OK
    function deleteNode(bytes32 enodeHigh, bytes32 enodeLow) public onlyGovernance {
        uint256 key = _calculateKey(enodeHigh, enodeLow);
        _revertIfNodeNotFound(enodeHigh, enodeLow, key);
        _deleteNode(enodeHigh, enodeLow, key);
    }
    
    //USNOD02 - OK
    function deleteLocalNode(bytes32 enodeHigh, bytes32 enodeLow) public onlyActiveAdmin {
        uint256 key = _calculateKey(enodeHigh, enodeLow);
        _revertIfNodeNotFound(enodeHigh, enodeLow, key);
        _revertIfNotSameOrganization(enodeHigh, enodeLow, key);
        _deleteNode(enodeHigh, enodeLow, key);
    }
    
    function _deleteNode(bytes32 enodeHigh, bytes32 enodeLow, uint nodeKey) private {
        delete allowedNodes[nodeKey];
        emit NodeDeleted(enodeHigh, enodeLow, msg.sender);
    }
    
    //USNOD03 - pode mudar apenas o nome ou apenas o tipo?
    function updateLocalNode(bytes32 enodeHigh, bytes32 enodeLow, NodeType nodeType, string calldata name) public onlyActiveAdmin {
        uint256 key = _calculateKey(enodeHigh, enodeLow);
        _revertIfNodeNotFound(enodeHigh, enodeLow, key);
        _revertIfNotSameOrganization(enodeHigh, enodeLow, key);
        _revertIfInvalidName(name);
        allowedNodes[key].nodeType = nodeType;
        allowedNodes[key].name = name;
        emit NodeUpdated(enodeHigh, enodeLow, msg.sender);
    }

    //USNOD04 - OK
    function updateLocalNodeStatus(bytes32 enodeHigh, bytes32 enodeLow, bool status) public onlyActiveAdmin {
        uint256 key = _calculateKey(enodeHigh, enodeLow);
        _revertIfNodeNotFound(enodeHigh, enodeLow, key);
        _revertIfNotSameOrganization(enodeHigh, enodeLow, key);
        allowedNodes[key].status = status;
        emit NodeStatusUpdated(enodeHigh, enodeLow, msg.sender);
    }

    //USNOD07 - OK
    function isNodeActive(bytes32 enodeHigh, bytes32 enodeLow) public view returns (bool){
        uint256 key = _calculateKey(enodeHigh, enodeLow);
        NodeData storage node = allowedNodes[key];
        if(organizationsContract.isOrganizationActive(node.orgId) && node.status) {
            return true;
        }
        return false;
    }

    //USNOD08
    function getNode(bytes32 enodeHigh, bytes32 enodeLow) public view returns (NodeData memory){
        uint256 key = _calculateKey(enodeHigh, enodeLow);
        _revertIfNodeNotFound(enodeHigh, enodeLow, key);
        return allowedNodes[key];
    }

    //USNOD09
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
        if(isNodeActive(sourceEnodeHigh, sourceEnodeLow) && isNodeActive(destinationEnodeHigh, destinationEnodeLow)) {
            return CONNECTION_ALLOWED;
        }
        
        return CONNECTION_DENIED;
    }

    function _revertIfDuplicateNode(bytes32 enodeHigh, bytes32 enodeLow, uint nodeKey) private view {
        if(_nodeExists(nodeKey)) {
            revert DuplicateNode(enodeHigh, enodeLow);
        }
    }

    function _revertIfNodeNotFound(bytes32 enodeHigh, bytes32 enodeLow, uint nodeKey) private view {
        if(!_nodeExists(nodeKey)) {
            revert NodeNotFound(enodeHigh, enodeLow);
        }
    }

    function _revertIfNotSameOrganization(bytes32 enodeHigh, bytes32 enodeLow, uint nodeKey) private view {
        AccountRulesV2.AccountData memory acc = accountsContract.getAccount(msg.sender);
        if(acc.orgId != allowedNodes[nodeKey].orgId) {
            revert NotLocalNode(enodeHigh, enodeLow);
        }
    }

    function _nodeExists(uint nodeKey) private view returns(bool) {
        return allowedNodes[nodeKey].orgId != 0;
    }

    function _calculateKey(bytes32 enodeHigh, bytes32 enodeLow) private pure returns(uint) {
        return uint(keccak256(abi.encodePacked(enodeHigh, enodeLow)));
    }

    function _revertIfInvalidName(string calldata name) private pure {
        if(bytes(name).length == 0) {
            revert InvalidArgument("Node name cannot be empty.");
        }
    }

}
