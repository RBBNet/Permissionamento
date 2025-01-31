// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

import {Test, console} from "forge-std/Test.sol";
import {MockAdminProxy} from "../src/mock/MockAdminProxy.sol";
import {OrganizationImpl} from "../src/OrganizationImpl.sol";
import {Organization} from "../src/Organization.sol";
import {Governable} from "../src/Governable.sol";

contract OrganizationImplTest is Test {
    MockAdminProxy internal adminProxy;
    OrganizationImpl internal orgImpl;

    address internal addr1;
    address internal addr2;

    function setUp() public {
    
        addr1 = address(0x1);
        addr2 = address(0x2);

        adminProxy = new MockAdminProxy(); //deploy adminmock
        adminProxy.setAuthorized(addr1, true); //addr 1 autorizado

        Organization.OrganizationData[] memory orgs = new Organization.OrganizationData[](2);
        orgs[0] = Organization.OrganizationData({id: 1, name: "OrgA", canVote: true});
        orgs[1] = Organization.OrganizationData({id: 2, name: "OrgB", canVote: false});

        orgImpl = new OrganizationImpl(orgs, adminProxy);

        assertTrue(orgImpl.isOrganizationActive(orgs[0].id));
    }


    /*
        Testar a condição “At least 2 organizations must be active”
        - com um endereço autorizado
        - deve reverter lançando erro: Organization.IllegalState
    */
    function testDeleteWithTwoOrganizations() public {
      
        vm.prank(addr1); 
        vm.expectRevert(abi.encodeWithSelector(Organization.IllegalState.selector, "At least 2 organizations must be active"));
        orgImpl.deleteOrganization(1); //deletando org 1

        
        vm.prank(addr1);
        vm.expectRevert(abi.encodeWithSelector(Organization.IllegalState.selector, "At least 2 organizations must be active"));
        orgImpl.deleteOrganization(2); //deletando org 2
    }


    /*
        Testar a condição “At least 2 organizations must be active”
        - com um endereço não autorizado
        - deve reverter lançando erro: Governable.UnauthorizedAccess
    */
    function testTryingToDeleteOrganizationWithUnauthorizedAddr() public {
        vm.prank(addr2); 
        vm.expectRevert(abi.encodeWithSelector(Governable.UnauthorizedAccess.selector, addr2));
        orgImpl.deleteOrganization(1);     
    }


    /*
        Testar construtor
        - Passar um array com menos de 2 organizações (deve reverter).
        - Passar nomes vazios, repetidos, etc.
    */
    function testFuzz_Constructor(Organization.OrganizationData[] memory orgs) public {
        if (orgs.length < 2) {
            vm.expectRevert("At least 2 organizations must exist");
            new OrganizationImpl(orgs, adminProxy);
        } else {
            OrganizationImpl tempOrgImpl = new OrganizationImpl(orgs, adminProxy);
            
            Organization.OrganizationData[] memory stored = tempOrgImpl.getOrganizations();
            assertEq(stored.length, orgs.length); // check num de organizacoes corresponse
        }
    }

    /*
        Testar consulta de organização
        - a organização precisa existir (senão reverte Organization.OrganizationNotFound)
    */
    function testFuzz_GetOrganization(uint orgId) public {
        if (orgId == 1 || orgId == 2) { //já existem
            Organization.OrganizationData memory data = orgImpl.getOrganization(orgId);
            assertEq(data.id, orgId);
        } else { // organização que não existe
            vm.expectRevert(abi.encodeWithSelector(Organization.OrganizationNotFound.selector, orgId));
            orgImpl.getOrganization(orgId);
        }
    }


    /*
        Testar a adição de uma de organização
        - apenas quem é da governança (senão reverte Governable.UnauthorizedAccess)
    */
    function testFuzz_AddOrganization(
        address caller, 
        string memory orgName, 
        bool canVote
    ) public {
     
        vm.assume(caller != address(0));
      
        bool isAuthorized = (uint256(keccak256(abi.encode(caller))) % 2 == 0);   // ajustar autorização do caller de forma randômica
        adminProxy.setAuthorized(caller, isAuthorized);


        vm.prank(caller);
        if (isAuthorized) { //se foi autorizado
    
            uint newId = orgImpl.addOrganization(orgName, canVote);

            Organization.OrganizationData memory newOrg = orgImpl.getOrganization(newId);
            assertEq(newOrg.name, orgName);
            assertEq(newOrg.canVote, canVote);
            assertEq(newOrg.id, newId);
        } else {
            
            vm.expectRevert(abi.encodeWithSelector(Governable.UnauthorizedAccess.selector, caller));
            orgImpl.addOrganization(orgName, canVote);
        }
    }


    /*
        Testar a atualização de uma de organização
        - apenas quem é da governança (senão reverte Governable.UnauthorizedAccess)
        - apenas se a organização existe (senão reverte  Organization.OrganizationNotFound)
    */
    function testFuzz_UpdateOrganization(
    address caller, 
    uint orgId, 
    string memory newName, 
    bool newCanVote
    ) public {
        vm.assume(caller != address(0));
        
        bool isGovernance = (uint256(keccak256(abi.encode(caller))) % 2 == 0);
        adminProxy.setAuthorized(caller, isGovernance);

        bool orgExists = (orgId == 1 || orgId == 2);
        vm.prank(caller);

        if (!isGovernance) { 
            vm.expectRevert(abi.encodeWithSelector(Governable.UnauthorizedAccess.selector, caller));
            orgImpl.updateOrganization(orgId, newName, newCanVote);
        } else {
            if (!orgExists) { 
                vm.expectRevert(abi.encodeWithSelector(Organization.OrganizationNotFound.selector, orgId));
                orgImpl.updateOrganization(orgId, newName, newCanVote);
            } else {
                orgImpl.updateOrganization(orgId, newName, newCanVote);
                Organization.OrganizationData memory updated = orgImpl.getOrganization(orgId);
                assertEq(updated.name, newName);
                assertEq(updated.canVote, newCanVote);
            }
        }
    }

     /*
        Testar a atualização de uma de organização
        - Apenas quem é da governança
        - Apenas se a organização já existe
        - Precisa de ao menos 2 organizações ativas
    */
    //@audit error
    // function testFuzz_DeleteOrganization(uint orgId, address caller) public {
    //     vm.assume(caller != address(0));

    //     // criação de mais 2 organizações
    //     vm.startPrank(addr1);
    //     for (uint i = 0; i < 2; i++) {
    //         orgImpl.addOrganization(string(abi.encodePacked("Organization", i)), true);
    //     }
    //     vm.stopPrank();

    //     // 4 orgs ativas: 1, 2, 3, 4
    //     bool isGovernance = (uint256(keccak256(abi.encode(caller))) % 2 == 0);
    //     adminProxy.setAuthorized(caller, isGovernance);
        
    //     vm.prank(caller);

    //     if (!isGovernance) { // não é governança
           
    //         vm.expectRevert(abi.encodeWithSelector(Governable.UnauthorizedAccess.selector, caller));
    //         orgImpl.deleteOrganization(orgId);

    //     } else { // eh governança

    //         if (orgId == 0 || orgId > 4) { // organização não existe

    //             vm.expectRevert(abi.encodeWithSelector(Organization.OrganizationNotFound.selector, orgId));
    //             orgImpl.deleteOrganization(orgId);

    //         } else { // org existe

    //             assertTrue(adminProxy.isAuthorized(caller));

    //             orgImpl.deleteOrganization(orgId);

    //             bool active = orgImpl.isOrganizationActive(orgId);
    //             assertFalse(active); // foi realmente deletada?

    //             // tentando deletar novamente então deve reverter
    //             vm.expectRevert(abi.encodeWithSelector(Organization.OrganizationNotFound.selector, orgId));
    //             orgImpl.deleteOrganization(orgId);
    //         }
    //     }
    // }
}
