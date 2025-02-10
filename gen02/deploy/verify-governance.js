const hre = require('hardhat');
const assert = require('assert');
const { getParameters, getParameter, diagnostics } = require('./util.js');

const ADMIN_ABI = [
    'function getAdmins() public view returns (address[])'
];

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
}

const parameters = getParameters();
verifyGovernance(parameters);