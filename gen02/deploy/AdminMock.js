const hre = require('hardhat');
const assert = require('assert');

async function deployAdminMock() {
    console.log('--------------------------------------------------');
    console.log('Implantando AdminMock');
    const adminMockContract = await hre.ethers.deployContract('AdminMock');
    await adminMockContract.waitForDeployment();
    console.log(`AdminMock implantado no endereço ${adminMockContract.target}`);

    const defaultAdminAccount = '0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199';
    console.log(`Acrescentando conta ${defaultAdminAccount} como admin`);
    await adminMockContract.addAdmin(defaultAdminAccount);
    // Verificando
    let isAdmin = await adminMockContract.admins(defaultAdminAccount);
    assert.ok(isAdmin);
    console.log('Conta adicionanda como admin');
    
    console.log('AdminMock implantado\n');
}

deployAdminMock();