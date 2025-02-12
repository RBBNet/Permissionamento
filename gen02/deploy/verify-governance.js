const hre = require('hardhat');
const assert = require('assert');
const { getParameters, getParameter, diagnostics } = require('./util.js');

const ADMIN_ABI = [
    'function getAdmins() public view returns (address[])'
];

const INGRESS_ABI = [
    'function getContractAddress(bytes32) public view returns(address)',
    'function setContractAddress(bytes32, address) public returns (bool)'
];

const RULES_CONTRACT = '0x72756c6573000000000000000000000000000000000000000000000000000000';
const NODE_INGRESS_ADDRESS = '0x0000000000000000000000000000000000009999';
const ACCOUNT_INGRESS_ADDRESS = '0x0000000000000000000000000000000000008888';

async function migrate(ingressAddress) {
    const ingressContract = await hre.ethers.getContractAt(INGRESS_ABI, ingressAddress);
    const resp = await ingressContract.setContractAddress(RULES_CONTRACT, '0x0000000000000000000000000000000000000001');
    await resp.wait();
}

async function verifyGovernance(parameters) {
    await diagnostics();

    console.log('--------------------------------------------------');
    console.log('Verificando se apenas o smart contract de governança é administrador master.');

    const governanceAddress = getParameter(parameters, 'governanceAddress');
    const adminAddress = getParameter(parameters, 'adminAddress');
    const adminContract = await hre.ethers.getContractAt(ADMIN_ABI, adminAddress);
    const allAdmins = await adminContract.getAdmins();

    assert.equal(allAdmins.length, 1, `Há mais de um administrador master! ${allAdmins}`);
    assert.equal(allAdmins[0], governanceAddress, `Administrador master configurado não é o smart contract de governança: ${allAdmins[0]}`);

    console.log(`Smart contract de governança ${governanceAddress} corretamente configurado como único administrador master.`);
    console.log();
    
    console.log('--------------------------------------------------');
    console.log('Tentando realizar reponteiramentos');
    try {
        await migrate(NODE_INGRESS_ADDRESS);
        console.error(' - Opa! Conseguir reponteirar o NodeIngress!');
    }
    catch(error) {
        console.log(` - NodeIngress não pôde ser reponteirado, corretamente: ${error.message}`);
        console.log('   Tudo certo!');
    }
    try {
        await migrate(ACCOUNT_INGRESS_ADDRESS);
        console.error(' - Opa! Conseguir reponteirar o AccountIngress!');
    }
    catch(error) {
        console.log(` - AccountIngress não pôde ser reponteirado, corretamente: ${error.message}`);
        console.log('   Tudo certo!');
    }
}

const parameters = getParameters();
verifyGovernance(parameters);