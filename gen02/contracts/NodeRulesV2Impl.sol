// SPDX-License-Identifier: GPL-3.0-only
pragma solidity 0.8.26;

import "./NodeRulesV2.sol";
import "./Governable.sol";
import "./AccountRulesV2.sol";
import "./Organization.sol";

contract NodeRulesV2Impl is NodeRulesV2, Governable {

    AccountRulesV2 public immutable contractRules;
    Organization public immutable contractOrganization;
    mapping (uint => NodeData) public allowedNodes;

    constructor(address rulesAddress, address organizationAddress, AdminProxy adminProxy) Governable(adminProxy) {
        contractRules = AccountRulesV2(rulesAddress); // Define o endereço do contrato 
        contractOrganization = Organization(organizationAddress);
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

    //USNOD01 - OK
    function addNode(bytes32 enodeHigh,bytes32 enodeLow,NodeType nodeType, string calldata name) public onlyActiveAdmin{
        uint256 key = _calculateKey(enodeHigh, enodeLow);
        if (_nodeExists(key)) {
            revert NodeAlreadyExists(enodeHigh, enodeLow, "This node already exists.");
        }

        AccountRulesV2.AccountData memory acc = contractRules.getAccount(msg.sender);
        uint organization = acc.orgId;

        allowedNodes[key] = NodeData(enodeHigh, enodeLow, nodeType, name, organization, true);
        emit NodeAdded(enodeHigh, enodeLow, msg.sender);
    }

    //USNOD05 - não sei se vai pegar o erro OrganizationNotFound do Organization, e se essa verificação é suficiente
    function addNodeByGovernance(bytes32 enodeHigh,bytes32 enodeLow,NodeType nodeType, string calldata name, uint organization) public onlyGovernance {
        uint256 key = _calculateKey(enodeHigh, enodeLow);
        if (_nodeExists(key)) {
            revert NodeAlreadyExists(enodeHigh, enodeLow, "This node already exists.");
        }

        bool isOrgActive = contractOrganization.isOrganizationActive(organization);

        if (isOrgActive){
            allowedNodes[key] = NodeData(enodeHigh, enodeLow, nodeType, name, organization, true);
            emit NodeAdded(enodeHigh, enodeLow, msg.sender);
        } else {
            revert InvalidOrganization(organization);
        }
        
    }

    //USNOD06 - OK
    function removeNodeByGovernance(bytes32 enodeHigh, bytes32 enodeLow) public onlyGovernance {
        uint256 key = _calculateKey(enodeHigh, enodeLow);
        if (!_nodeExists(key)) {
            revert NodeDoesntExist(enodeHigh, enodeLow, "Node does not exist");
        }

        delete allowedNodes[key];
        emit NodeRemoved(enodeHigh, enodeLow, msg.sender);
    }
    
    //USNOD02 - OK
    function removeNode(bytes32 enodeHigh, bytes32 enodeLow) public onlyActiveAdmin {
        uint256 key = _calculateKey(enodeHigh, enodeLow);
        if (!_nodeExists(key)) {
            revert NodeDoesntExist(enodeHigh, enodeLow, "Node does not exist");
        }

        NodeData memory nodeA = allowedNodes[key];
        uint nodeOrg = nodeA.orgId;

        AccountRulesV2.AccountData memory acc = contractRules.getAccount(msg.sender);
        uint accOrg = acc.orgId;

        if (accOrg != nodeOrg){
            revert InvalidOrganization(accOrg);
        } else {
            delete allowedNodes[key];
            emit NodeRemoved(enodeHigh, enodeLow, msg.sender);
        }
        
    }
    
    //USNOD03 - ok? É suficiente?
    function updateNode(bytes32 enodeHigh, bytes32 enodeLow, NodeType nodeType, string calldata name) public onlyActiveAdmin {
        uint256 key = _calculateKey(enodeHigh, enodeLow);
        if (!_nodeExists(key)) {
            revert NodeDoesntExist(enodeHigh, enodeLow, "Node does not exist");
        }

        NodeData memory nodeA = allowedNodes[key];
        uint nodeOrg = nodeA.orgId;

        AccountRulesV2.AccountData memory acc = contractRules.getAccount(msg.sender);
        uint accOrg = acc.orgId;

        if (accOrg != nodeOrg){
            revert InvalidOrganization(accOrg);
        } 

        if (bytes(name).length > 0) {
            allowedNodes[key].name = name;
        }

        if (isValidNodeType(nodeType)){
            allowedNodes[key].nodeType = nodeType;
            emit NodeUpdated(enodeHigh, enodeLow, msg.sender);
        } else {
            revert InvalidArgument("Invalid node type.");
        }
        
    }

    //USNOD04 - dúvida
    function updateNodeStatus(bytes32 enodeHigh, bytes32 enodeLow, bool status) public onlyActiveAdmin {
        uint256 key = _calculateKey(enodeHigh, enodeLow);
        if (!_nodeExists(key)) {
            revert NodeDoesntExist(enodeHigh, enodeLow, "Node does not exist.");
        }

        allowedNodes[key].status = status;
        emit NodeStatusUpdated(enodeHigh, enodeLow, msg.sender);
    }

    //USNOD07 - OK
    function isNodeActive(bytes32 enodeHigh, bytes32 enodeLow) public view returns (bool){
        uint256 key = _calculateKey(enodeHigh, enodeLow);
        if (!_nodeExists(key)){
            revert NodeDoesntExist(enodeHigh, enodeLow, "Node does not exist.");
        }

        NodeData memory node = allowedNodes[key];
        uint nodeOrg = node.orgId;
        bool isOrgActive = contractOrganization.isOrganizationActive(nodeOrg);
        bool nodeStatus = node.status;

        if (isOrgActive && nodeStatus) {
            return true;
        } else {
            return false;
        }
    }


    //USNOD08
    function getNode(bytes32 enodeHigh, bytes32 enodeLow) public view returns (NodeData memory){
        uint256 key = _calculateKey(enodeHigh, enodeLow);

        if (!_nodeExists(key)){
            revert NodeDoesntExist(enodeHigh, enodeLow, "Node does not exist.");
        }
        
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
        uint key = _calculateKey(enodeHigh, enodeLow);
        NodeData memory node = allowedNodes[key];
        if (node.status){
           return _nodeExists(key); 
        } else {
            revert InactiveNode(enodeHigh, enodeLow);
        }
        
    }

    function _nodeExists(uint nodeKey) private view returns(bool) {
        return allowedNodes[nodeKey].orgId != 0;
    }

    function _calculateKey(bytes32 enodeHigh, bytes32 enodeLow) private pure returns(uint) {
        return uint(keccak256(abi.encodePacked(enodeHigh, enodeLow)));
    }

    function isValidNodeType(NodeType _type) public pure returns (bool) {
        return _type == NodeType.Boot || _type == NodeType.Validator || _type == NodeType.Writer || _type == NodeType.ObserverBoot;
    }

}
