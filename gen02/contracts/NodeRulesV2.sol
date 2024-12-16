// SPDX-License-Identifier: GPL-3.0-only
pragma solidity 0.8.26;

import "./NodeRulesProxy.sol";

interface NodeRulesV2 is NodeRulesProxy {

    enum NodeType{
        Boot,
        Validator,
        Writer,
        ObserverBoot
    }

    struct NodeData {
        bytes32 enodeHigh;
        bytes32 enodeLow;
        NodeType nodeType;
        string name;
        uint orgId;
        bool status;
    }

    event NodeAdded(bytes32 enodeHigh, bytes32 enodeLow, address admin);
    event NodeDeleted(bytes32 enodeHigh, bytes32 enodeLow, address admin);
    event NodeUpdated(bytes32 enodeHigh, bytes32 enodeLow, address admin);
    event NodeStatusUpdated(bytes32 enodeHigh, bytes32 enodeLow, address admin);

    error InvalidArgument(string message);
    error InactiveAccount(address account, string message);
    error InvalidOrganization(uint orgId);
    error NotLocalNode(bytes32 enodeHigh, bytes32 enodeLow);
    error DuplicateNode(bytes32 enodeHigh, bytes32 enodeLow);
    error NodeNotFound(bytes32 enodeHigh, bytes32 enodeLow);
    error InvalidState(string message);
    error InactiveNode(bytes32 enodeHigh, bytes32 enodeLow);
    error InvalidName(string message);

    function addLocalNode(bytes32 enodeHigh, bytes32 enodeLow, NodeType nodeType, string memory name) external;
    function deleteLocalNode(bytes32 enodeHigh, bytes32 enodeLow) external;
    function addNode(bytes32 enodeHigh, bytes32 enodeLow, NodeType nodeType, string memory name, uint organization) external;
    function deleteNode(bytes32 enodeHigh, bytes32 enodeLow) external;
    function updateLocalNode(bytes32 enodeHigh, bytes32 enodeLow, NodeType nodeType, string memory name) external;
    function updateLocalNodeStatus(bytes32 enodeHigh, bytes32 enodeLow, bool status) external;

}