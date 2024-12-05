// SPDX-License-Identifier: GPL-3.0-only
pragma solidity 0.8.26;

import "NodeRulesProxy.sol";

interface NodeRulesV2 is NodeRulesProxy {

    enum NodeType{
        Boot,
        Validator,
        Writer,
        ObserverBoot
    }

     struct enode {
        bytes32 enodeHigh;
        bytes32 enodeLow;
        NodeType nodeType;
        string name;
        string organization;
        string status;
    }

    event NodeAdded(address nodeAddress, address admin);
    event NodeRemoved(address nodeAddress, address admin);
    event NodeEdited(address nodeAddress, address admin);
    event NodeStatusChanged(address nodeAddress, address admin);
    event NodeAddedByGovernance(address nodeAddress, address governance);
    event NodeRemovedByGovernance(address nodeAddress, address governance);

    error InvalidArgument(string message);
    error InactiveAccount(address account, string message);
    error InvalidOrganization(uint orgId, string message);
    error NodeAlreadyExists(address nodeAddress, string message);
    error NodeDoesntExist(string message);
    error InvalidState(string message);

    function addNode(bytes32 _enodeHigh, bytes32 _enodeLow, NodeType _nodeType, string memory _name, string memory _organization) external;
    function removeNode(bytes32 _enodeHigh, bytes32 _enodeLow) external;
    function editNode(bytes32 _enodeHigh, bytes32 _enodeLow, NodeType _nodeType, string memory _name) external;
    function changeNodeStatus(bytes32 _enodeHigh, bytes32 _enodeLow, string memory status) external;

    /* NOTAS:
    
    1 - addNode já põe status "ativo".
    2 - removeNode já põe status "inativo".
    
    */
}
