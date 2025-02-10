const hre = require('hardhat');
const assert = require('assert');
const { getParameters, getParameter, diagnostics } = require('./util.js');

const STATUS_ACTIVE = 1;
const STATUS_EXECUTED = 4;
const RESULT_APPROVED = 1;

async function executeProposal(parameters) {
    await diagnostics();

    const proposal = getParameter(parameters, 'proposal');
    const governanceAddress = getParameter(parameters, 'governanceAddress');
    const governanceContract = await hre.ethers.getContractAt('Governance', governanceAddress);

    const proposalBefore = await governanceContract.getProposal(proposal.id);

    assert.equal(proposalBefore.status, STATUS_ACTIVE, `Proposta ${proposal.id} não está ativa! Status: ${proposalBefore.status}`);
    assert.equal(proposalBefore.result, RESULT_APPROVED, `Proposta ${proposal.id} não está Aprovada! Result: ${proposalBefore.result}`);

    console.log('--------------------------------------------------');
    console.log(`Executando proposta ${proposalBefore.id} - ${proposalBefore.description} (Status: ${proposalBefore.status})(Resultado: ${proposalBefore.result})`);

    // TODO Implementar prompt para confirmar execução
    
    const resp = await governanceContract.executeProposal(proposal.id);
    await resp.wait();
    const proposalAfter = await governanceContract.getProposal(proposal.id);
    console.log('Proposta executada.');
    console.log(`Nova situação da proposta: ${proposalAfter.status}`);
    // Verificações
    assert.equal(proposalAfter.status, STATUS_EXECUTED, 'Algo errado: status da proposta não indica que a execução foi realizada.');
}

const parameters = getParameters();
executeProposal(parameters);