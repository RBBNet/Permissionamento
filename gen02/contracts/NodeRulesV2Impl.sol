// SPDX-License-Identifier: GPL-3.0-only
pragma solidity 0.8.26;

import "./NodeRulesV2.sol";
import "./Governable.sol";
import "./AccountRulesV2.sol";
import "./Organization.sol";
import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";

contract NodeRulesV2Impl is NodeRulesV2, Governable {

    using EnumerableSet for EnumerableSet.UintSet;

    AccountRulesV2 public immutable accountsContract;
    Organization public immutable organizationsContract;
    mapping (uint => NodeData) public allowedNodes;
    EnumerableSet.UintSet private _nodesKeys;
    mapping (uint => EnumerableSet.UintSet) _nodesKeysByOrg;

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

    function addLocalNode(bytes32 enodeHigh, bytes32 enodeLow, NodeType nodeType, string calldata name) public onlyActiveAdmin {
        AccountRulesV2.AccountData memory acc = accountsContract.getAccount(msg.sender);
        _addNode(enodeHigh, enodeLow, nodeType, name, acc.orgId);
    }

    function addNode(bytes32 enodeHigh, bytes32 enodeLow, NodeType nodeType, string calldata name, uint orgId) public onlyGovernance {
        if(!organizationsContract.isOrganizationActive(orgId)) {
            revert InvalidOrganization(orgId);
        }
        _addNode(enodeHigh, enodeLow, nodeType, name, orgId);
    }

    function _addNode(bytes32 enodeHigh, bytes32 enodeLow, NodeType nodeType, string calldata name, uint orgId) private {
        uint256 key = _calculateKey(enodeHigh, enodeLow);
        _revertIfDuplicateNode(enodeHigh, enodeLow, key);
        _revertIfInvalidName(name);
        allowedNodes[key] = NodeData(enodeHigh, enodeLow, nodeType, name, orgId, true);
        _nodesKeys.add(key);
        _nodesKeysByOrg[orgId].add(key);
        emit NodeAdded(enodeHigh, enodeLow, orgId, msg.sender);
    }

    function deleteNode(bytes32 enodeHigh, bytes32 enodeLow) public onlyGovernance {
        uint256 key = _calculateKey(enodeHigh, enodeLow);
        _revertIfNodeNotFound(enodeHigh, enodeLow, key);
        _deleteNode(enodeHigh, enodeLow, key, allowedNodes[key].orgId);
    }

    function deleteLocalNode(bytes32 enodeHigh, bytes32 enodeLow) public onlyActiveAdmin {
        uint256 key = _calculateKey(enodeHigh, enodeLow);
        _revertIfNodeNotFound(enodeHigh, enodeLow, key);
        _revertIfNotSameOrganization(enodeHigh, enodeLow, key);
        _deleteNode(enodeHigh, enodeLow, key, allowedNodes[key].orgId);
    }
    
    function _deleteNode(bytes32 enodeHigh, bytes32 enodeLow, uint nodeKey, uint orgId) private {
        delete allowedNodes[nodeKey];
        _nodesKeys.remove(nodeKey);
        _nodesKeysByOrg[orgId].remove(nodeKey);
        emit NodeDeleted(enodeHigh, enodeLow, orgId, msg.sender);
    }

    function updateLocalNode(bytes32 enodeHigh, bytes32 enodeLow, NodeType nodeType, string calldata name) public onlyActiveAdmin {
        uint256 key = _calculateKey(enodeHigh, enodeLow);
        _revertIfNodeNotFound(enodeHigh, enodeLow, key);
        _revertIfNotSameOrganization(enodeHigh, enodeLow, key);
        _revertIfInvalidName(name);
        allowedNodes[key].nodeType = nodeType;
        allowedNodes[key].name = name;
        emit NodeUpdated(enodeHigh, enodeLow, allowedNodes[key].orgId, msg.sender);
    }

    function updateLocalNodeStatus(bytes32 enodeHigh, bytes32 enodeLow, bool active) public onlyActiveAdmin {
        uint256 key = _calculateKey(enodeHigh, enodeLow);
        _revertIfNodeNotFound(enodeHigh, enodeLow, key);
        _revertIfNotSameOrganization(enodeHigh, enodeLow, key);
        allowedNodes[key].active = active;
        emit NodeStatusUpdated(enodeHigh, enodeLow, allowedNodes[key].orgId, active, msg.sender);
    }

    function isNodeActive(bytes32 enodeHigh, bytes32 enodeLow) public view returns (bool){
        uint256 key = _calculateKey(enodeHigh, enodeLow);
        NodeData storage node = allowedNodes[key];
        if(organizationsContract.isOrganizationActive(node.orgId) && node.active) {
            return true;
        }
        return false;
    }

    function getNode(bytes32 enodeHigh, bytes32 enodeLow) public view returns (NodeData memory){
        uint256 key = _calculateKey(enodeHigh, enodeLow);
        _revertIfNodeNotFound(enodeHigh, enodeLow, key);
        return allowedNodes[key];
    }

    function getNumberOfNodes() public view returns (uint) {
        return _nodesKeys.length();
    }

    function getNumberOfNodesByOrg(uint orgId) public view returns (uint) {
        return _nodesKeysByOrg[orgId].length();
    }

    function getNodes(uint page, uint pageSize) public view returns (NodeData[] memory) {
        return _getNodes(_nodesKeys, page, pageSize);
    }

    function getNodesByOrg(uint orgId, uint page, uint pageSize) public view returns (NodeData[] memory) {
        return _getNodes(_nodesKeysByOrg[orgId], page, pageSize);
    }

    function _getNodes(EnumerableSet.UintSet storage nodeKeySet, uint page, uint pageSize) private view returns (NodeData[] memory) {
        if(page < 1) {
            revert InvalidArgument("Page must be greater or equal to 1 ");
        }
        if(pageSize < 1) {
            revert InvalidArgument("Page size must be greater or equal to 1 ");
        }
        uint start = (page - 1) * pageSize;
        if(start > nodeKeySet.length()) {
            start = nodeKeySet.length();
        }
        uint stop = start + pageSize;
        if(stop > nodeKeySet.length()) {
            stop = nodeKeySet.length();
        }
        NodeData[] memory nodes = new NodeData[](stop - start);
        for(uint i = start; i < stop; ++i) {
            nodes[i - start] = allowedNodes[nodeKeySet.at(i)];
        }
        return nodes;
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
