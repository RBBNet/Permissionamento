// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {NodeRulesProxyMock} from "../contracts/test/NodeRulesProxyMock.sol";
import {NodeRulesProxy} from "../contracts/NodeRulesProxy.sol";

contract NodeRulesProxyTest is Test {
    NodeRulesProxyMock public mockNodeRulesProxy;

    function setUp() public {
        console.log(">>>>> [FUZZY] NodeRulesProxy test");
        mockNodeRulesProxy = new NodeRulesProxyMock();
    }

    function testConnectionAllowed( 
        bytes32 sourceEnodeHigh,
        bytes32 sourceEnodeLow,
        bytes16 sourceEnodeIp,
        uint16 sourceEnodePort,
        bytes32 destinationEnodeHigh,
        bytes32 destinationEnodeLow,
        bytes16 destinationEnodeIp,
        uint16 destinationEnodePort,
        bytes32 expectedResult) public {

    
        mockNodeRulesProxy.setConnectionResult(sourceEnodeHigh, sourceEnodeLow, sourceEnodeIp, sourceEnodePort, destinationEnodeHigh, destinationEnodeLow, destinationEnodeIp, destinationEnodePort, expectedResult);

        bytes32 result = mockNodeRulesProxy.connectionAllowed(sourceEnodeHigh, sourceEnodeLow, sourceEnodeIp, sourceEnodePort, destinationEnodeHigh,destinationEnodeLow, destinationEnodeIp, destinationEnodePort);

        assertEq(result, expectedResult, "ConnectionAllowed returned unexpected result");
       
    }


}
