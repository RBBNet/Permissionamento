// SPDX-License-Identifier: GPL-3.0-only
pragma solidity 0.8.26;

import "./NodeRulesProxy.sol";

bytes32 constant GLOBAL_ADMIN_ROLE = keccak256("GLOBAL_ADMIN_ROLE");
bytes32 constant LOCAL_ADMIN_ROLE = keccak256("LOCAL_ADMIN_ROLE");

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

    function addNode(bytes32 _enodeHigh, bytes32 _enodeLow, NodeType _nodeType, string memory _name, string memory _organization) external returns (bool);
    function removeNode(bytes32 _enodeHigh, bytes32 _enodeLow) external returns (bool);
    function updateNode(bytes32 _enodeHigh, bytes32 _enodeLow, NodeType _nodeType, string memory _name) external returns (bool);
    function updateNodeStatus(bytes32 _enodeHigh, bytes32 _enodeLow, string memory status) external returns (bool);

    /* NOTAS:
    
    1 - addNode já põe status "ativo".
    2 - removeNode já põe status "inativo".
    
    */
}
