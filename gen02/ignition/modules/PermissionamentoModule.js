const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

module.exports = buildModule('PermissionamentoModule', (m) => {
    const adminAddress = m.getParameter('adminAddress');
    if(adminAddress.length == 0) {
        throw new Error('Endereço do contrato de admin indefinido');
    }
    const adminContract = m.contractAt('AdminMock', adminAddress);

    const organizations = m.getParameter('organizations');
    const globalAdmins = m.getParameter('globalAdmins');
    if(organizations.length != globalAdmins.length) {
        throw new Error('Listas de organizações e contas de administradores globais não têm o mesmo tamanho: ' + organizations.length + ' != ' + globalAdmins.length);
    }
    
    const organizationsContract = m.contract('OrganizationImpl', [organizations, adminContract]);
    const accountsContract = m.contract('AccountRulesV2Impl', [organizationsContract, globalAdmins, adminContract]);
    const nodesContract = m.contract('NodeRulesV2Impl', [organizationsContract, accountsContract, adminContract]);
    const governanceContract = m.contract('Governance', [organizationsContract, accountsContract]);
    
    m.call(adminContract, 'addAdmin', [governanceContract]);
    
    return [ organizationsContract, accountsContract, nodesContract, governanceContract ];
});
