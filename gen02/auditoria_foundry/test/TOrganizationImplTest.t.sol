// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

// import {Test, console} from "forge-std/Test.sol";
// import {MockOrganization} from "../src/mock/MockOrganization.sol";
// import {MockAdminProxy} from "../src/mock/MockAdminProxy.sol";
// import {MockGovernable} from "../src/mock/MockGovernable.sol";
// import {OrganizationImpl} from "../src/OrganizationImpl.sol";
// import {Organization} from "../src/Organization.sol";

// contract OrganizationImplTest is Test {
//     MockOrganization public mockOrganization;
//     MockAdminProxy public mockAdminProxy;
//     MockGovernable public mockGovernable;
//     OrganizationImpl public organizationImpl;


//     address addrAuthorized = address(0x123);
//     address addrNotAuthorized = address(0x234);
//     address addr2Authorized = address(0x345);


//     function setUp() public {
//         console.log(">>>>> [FUZZY] OrganizationImpl test");

//         mockAdminProxy = new MockAdminProxy();

//         mockAdminProxy.setAuthorized(addrAuthorized, true);
//         mockAdminProxy.setAuthorized(addrNotAuthorized, false);
//         mockAdminProxy.setAuthorized(addr2Authorized, true);

//         mockOrganization = new MockOrganization();
//         mockOrganization.addOrganization("BNDES", true);
//         mockOrganization.addOrganization("SERPRO", true);
//         mockOrganization.addOrganization("BACEN", false);

//         Organization.OrganizationData[] memory organizations = mockOrganization.getOrganizations();

//         organizationImpl = new OrganizationImpl(organizations, mockAdminProxy); // OrganizationData[] memory orgs, AdminProxy adminsProxy

//     }

//     function testOrganizationActive(uint orgId) public {
        
//         Organization.OrganizationData[] memory  allOrganizations = organizationImpl.getOrganizations();
//         // console.log(allOrganizations.length);
//         // for (uint i = 0; i < allOrganizations.length; i++) {
//         //    console.log("id: ",allOrganizations[i].id, "; name:" , allOrganizations[i].name);
//         //    //console.log(allOrganizations[i].id, " is active? ", organizationImpl.isOrganizationActive(allOrganizations[i].id));
//         // }

//         bool finded = false;
//         for (uint256 i = 0; i < allOrganizations.length; i++) {
//             console.log(" compara id ", allOrganizations[i].id, " == ", orgId);
//             if (allOrganizations[i].id == orgId) {
//                 bool isActive = organizationImpl.isOrganizationActive(orgId);
//                 assertTrue(isActive);
//                 finded = true;
//             }

//         }

//         if(!finded){
//             //vm.expectRevert(abi.encodeWithSelector(Organization.OrganizationNotFound.selector, orgId));
//             //console.log("revertd ");
//             organizationImpl.isOrganizationActive(orgId);
//         }
    
//     }


//     function testOrganizationNotExists(uint orgId) public {
        

//         vm.assume(orgId != 1 && orgId!= 2 && orgId != 3);
//         // Organization.OrganizationData[] memory  allOrganizations = organizationImpl.getOrganizations();
        
        
//         // console.log("AAAAA: ", orgId);
//         // bool finded = false;
//         // for (uint256 i = 0; i < allOrganizations.length; i++) {
//         //     Organization.OrganizationData memory organization = organizationImpl.getOrganization(orgId);
//         //     if (allOrganizations[i].id == organization.id) {
//         //         finded = true;
//         //         assertTrue(finded);
//         //     }
//         // }

//         //if(!finded){
//            // console.log("ERROR AQUI");
//             vm.expectRevert(abi.encodeWithSelector(Organization.OrganizationNotFound.selector, orgId));
//             Organization.OrganizationData memory organization = organizationImpl.getOrganization(orgId);
//         //}
    
//     }

//      function testOrganizationExists(uint orgId) public {
        

//         vm.assume(orgId == 1 || orgId== 2 || orgId == 3);
        
//         Organization.OrganizationData memory organization = organizationImpl.getOrganization(orgId);
//         assertTrue(organization.id != 0);
        
//      }


//     //  function testAddNewOrganization(string calldata name, bool canVote) public {
//     //     console.log(">>>>>>>> [TEST] testAddNewOrganization");

//     //     address[] memory authorizedAddresses = mockAdminProxy.getAllAuthorizedAddresses();
//     //     for (uint256 i = 0; i < authorizedAddresses.length; i++) {
//     //        console.log(authorizedAddresses[i], ": ", mockAdminProxy.isAuthorized(authorizedAddresses[i]));
//     //     }

//     //     organizationImpl.isOrganizationActive();
//     //     organizationImpl.addOrganization(name, canVote);

//     //     assertTrue(false);
//     // }


// }
