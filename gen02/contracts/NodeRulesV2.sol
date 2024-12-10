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
    event NodeRemoved(bytes32 enodeHigh, bytes32 enodeLow, address admin);
    event NodeUpdated(bytes32 enodeHigh, bytes32 enodeLow, address admin);
    event NodeStatusUpdated(bytes32 enodeHigh, bytes32 enodeLow, address admin);

    error InvalidArgument(string message);
    error InactiveAccount(address account, string message);
    error InvalidOrganization(uint orgId);
    error NodeAlreadyExists(bytes32 enodeHigh, bytes32 enodeLow, string message);
    error NodeDoesntExist(bytes32 enodeHigh, bytes32 enodeLow, string message);
    error InvalidState(string message);
    error InactiveNode(bytes32 enodeHigh, bytes32 enodeLow);

    function addLocalNode(bytes32 enodeHigh, bytes32 enodeLow, NodeType nodeType, string memory name) external;
    function removeLocalNode(bytes32 enodeHigh, bytes32 enodeLow) external;
    function addNode(bytes32 enodeHigh, bytes32 enodeLow, NodeType nodeType, string memory name, uint organization) external;
    function removeNode(bytes32 enodeHigh, bytes32 enodeLow) external;
    function updateNode(bytes32 enodeHigh, bytes32 enodeLow, NodeType nodeType, string memory name) external;
    function updateNodeStatus(bytes32 enodeHigh, bytes32 enodeLow, bool status) external;

}
