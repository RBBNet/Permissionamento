const hre = require('hardhat');
const assert = require('assert');
const { getParameters, getParameter } = require('./util.js');

async function deployGen02(parameters) {
    console.log('--------------------------------------------------');
    console.log('Implantando gen02');
    
    const adminAddress = getParameter(parameters, 'adminAddress');
    const organizations = getParameter(parameters, 'organizations');
    const globalAdmins = getParameter(parameters, 'globalAdmins');

    if(organizations.length != globalAdmins.length) {
        throw new Error(`Listas de organizações e contas de administradores globais não têm o mesmo tamanho: ${organizations.length} != ${globalAdmins.length}`);
    }

    const adminContract = await hre.ethers.getContractAt('AdminMock', adminAddress);

    console.log('Implantando smart contract de gestão de organizações');
    const organizationsContract = await hre.ethers.deployContract('OrganizationImpl', [organizations, adminContract]);
    // TODO verificações
    await organizationsContract.waitForDeployment();
    console.log(`OrganizationImpl implantado no endereço ${organizationsContract.target}`);

    console.log('Implantando smart contract de gestão de contas');
    const accountsContract = await hre.ethers.deployContract('AccountRulesV2Impl', [organizationsContract, globalAdmins, adminContract]);
    // TODO verificações
    await accountsContract.waitForDeployment();
    console.log(`AccountRulesV2Impl implantado no endereço ${accountsContract.target}`);

    console.log('Implantando smart contract de gestão de nós');
    const nodesContract = await hre.ethers.deployContract('NodeRulesV2Impl', [organizationsContract, accountsContract, adminContract]);
    // TODO verificações
    await nodesContract.waitForDeployment();
    console.log(`NodeRulesV2Impl implantado no endereço ${nodesContract.target}`);

    console.log('Implantando smart contract de governança');
    const governanceContract = await hre.ethers.deployContract('Governance', [organizationsContract, accountsContract]);
    // TODO verificações
    await governanceContract.waitForDeployment();
    console.log(`Governance implantado no endereço ${governanceContract.target}`);
    
    console.log('Adicionando smart contract de governança como admin');
    await adminContract.addAdmin(governanceContract);
    // TODO verificações
    console.log('Governance adicionado como admin\n');
}

const parameters = getParameters();
deployGen02(parameters);
