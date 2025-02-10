const hre = require('hardhat');
const assert = require('assert');
const { getParameters, getParameter, diagnostics } = require('./util.js');

const BLOCKS_DURATION = 30000;
const PROPOSAL_DESCRIPTION = '';
const REMOVE_ACCOUNT_FUNC = 'removeAdmin(address)';
const STATUS_ACTIVE = 1;
const RESULT_UNDEFINED = 0;

const ADMIN_ABI = [
    'function getAdmins() public view returns (address[])',
    'function removeAdmin(address) public returns (bool)'
];

async function createProposal(parameters) {
    await diagnostics();

    console.log('--------------------------------------------------');
    console.log('Criando proposta de governança para remover administradores master:');

    const governanceAddress = getParameter(parameters, 'governanceAddress');
    const adminAddress = getParameter(parameters, 'adminAddress');
    const adminContract = await hre.ethers.getContractAt(ADMIN_ABI, adminAddress);
    
    const allAdmins = await adminContract.getAdmins();
    const adminsToRemove = allAdmins.filter(a => a != governanceAddress);
    for(const admin of adminsToRemove) {
        console.log(` - ${admin}`);
    }
    console.log();
    
    const governanceContract = await hre.ethers.getContractAt('Governance', governanceAddress);
    
    console.log('Chamadas configuradas para a proposta');
    let targets = [];
    let calldatas = []
    for(const admin of adminsToRemove) {
        const calldata = adminContract.interface.encodeFunctionData(REMOVE_ACCOUNT_FUNC, [admin]);
        targets.push(adminAddress);
        calldatas.push(calldata);
        console.log(` - ${adminAddress}: ${calldata}`);
    }
    console.log();

    // TODO Implementar prompt para confirmar criação de proposta
    
    const resp = await governanceContract.createProposal(targets, calldatas, BLOCKS_DURATION, PROPOSAL_DESCRIPTION);
    await resp.wait();
    const idProposal = await governanceContract.idSeed();
    // Verificações
    const proposal = await governanceContract.getProposal(idProposal);
    assert.equal(proposal.description, PROPOSAL_DESCRIPTION);
    assert.equal(proposal.status, STATUS_ACTIVE);
    assert.equal(proposal.result, RESULT_UNDEFINED);
    console.log(`Proposta ${idProposal} criada.`);
}

const parameters = getParameters();
createProposal(parameters);