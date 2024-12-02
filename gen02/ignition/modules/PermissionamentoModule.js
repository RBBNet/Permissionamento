const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

module.exports = buildModule('PermissionamentoModule', (m) => {
    if(m.getParameter('organizations').length != m.getParameter('globalAdmins').length) {
        throw new Error('Listas de organizações e contas de administradores globais não têm o mesmo tamanho: ' + organizations.length + ' != ' + globalAdmins.length);
    }
    
    const organizationsContract = m.contract('OrganizationImpl', [m.getParameter('organizations'), m.getParameter('adminAddress')]);
    const accountsContract = m.contract('AccountRulesV2Impl', [organizationsContract, m.getParameter('globalAdmins') , m.getParameter('adminAddress')]);
    
    return [ organizationsContract, accountsContract ];
});
