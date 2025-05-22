// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {AccountRulesProxyMock} from "../contracts/test/AccountRulesProxyMock.sol";
import {AccountRulesProxy} from "../contracts/AccountRulesProxy.sol";

contract AccountRulesProxyTest is Test {
    AccountRulesProxyMock public mockAccountRulesProxy;

    function setUp() public {
        console.log(">>>>> [FUZZY] AccountRulesProxy test");
        mockAccountRulesProxy = new AccountRulesProxyMock();
    }

    function testTransactionAllowed( 
        address sender,
        address target,
        uint256,
        uint256,
        uint256,
        bytes calldata payload) public {

        vm.assume(sender != address(0));
        vm.assume(target != address(0));

        console.log('%s %s', sender, target);
        
        if(sender == address(0)){
            vm.expectRevert(abi.encodeWithSelector(AccountRulesProxyMock.InvalidSenderAddress.selector, sender));
            mockAccountRulesProxy.isSenderAddressValid(sender);
        }else{
            bool result = mockAccountRulesProxy.isSenderAddressValid(sender);
            assertTrue(result, "Expected true for sender address");
        }

        if(target == address(0)){
            vm.expectRevert(abi.encodeWithSelector(AccountRulesProxyMock.InvalidTargetAddress.selector, target));
            mockAccountRulesProxy.isTargetAddressValid(target);
        }else{
            bool result = mockAccountRulesProxy.isTargetAddressValid(target);
            assertTrue(result, "Expected true for target address");
        }

    }


    function testAreValidsSenderAndTargetAddress(address sender, address target) public {

        console.log('%s %s', sender, target);
        
        if(sender == address(0)){
            vm.expectRevert(abi.encodeWithSelector(AccountRulesProxyMock.InvalidSenderAddress.selector, sender));
            mockAccountRulesProxy.isSenderAddressValid(sender);
        }else{
            bool result = mockAccountRulesProxy.isSenderAddressValid(sender);
            assertTrue(result, "Expected true for sender address");
        }

        if(target == address(0)){
            vm.expectRevert(abi.encodeWithSelector(AccountRulesProxyMock.InvalidTargetAddress.selector, target));
            mockAccountRulesProxy.isTargetAddressValid(target);
        }else{
            bool result = mockAccountRulesProxy.isTargetAddressValid(target);
            assertTrue(result, "Expected true for target address");
        }

    }
}
