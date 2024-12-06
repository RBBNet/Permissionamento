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
        uint organization;
        bool status;
    }

    event NodeAdded(bytes32 enodeHigh, bytes32 enodeLow, address admin);
    event NodeRemoved(bytes32 enodeHigh, bytes32 enodeLow,address admin);
    event NodeUpdated(bytes32 enodeHigh, bytes32 enodeLow, address admin);
    event NodeStatusUpdated(bytes32 enodeHigh, bytes32 enodeLow, address admin);
    event NodeAddedByGovernance(bytes32 enodeHigh, bytes32 enodeLow, address governance);
    event NodeRemovedByGovernance(bytes32 enodeHigh, bytes32 enodeLow, address governance);

    error InvalidArgument(string message);
    error InactiveAccount(address account, string message);
    error InvalidOrganization(uint orgId);
    error NodeAlreadyExists(bytes32 enodeHigh, bytes32 enodeLow, string message);
    error NodeDoesntExist(bytes32 enodeHigh, bytes32 enodeLow, string message);
    error InvalidState(string message);
    error UnauthorizedAccess(address account);

    function addNode(bytes32 enodeHigh, bytes32 enodeLow, NodeType nodeType, string memory name, uint organization) external returns (bool);
    function removeNode(bytes32 enodeHigh, bytes32 enodeLow) external returns (bool);
    function updateNode(bytes32 enodeHigh, bytes32 enodeLow, NodeType nodeType, string memory name) external returns (bool);
    function updateNodeStatus(bytes32 enodeHigh, bytes32 enodeLow, bool status) external;

    /* NOTAS:
    
    1 - addNode já põe status "ativo".
    2 - removeNode já põe status "inativo".
    
    */
}
