const fs = require('fs');
const assert = require('assert');
const hre = require('hardhat');
const { STATUS_ACTIVE, STATUS_EXECUTED, RESULT_APPROVED } = require('./constants.js');

function getParameters() {
    const paramsPath = process.env['CONFIG_PARAMETERS'];
    if(paramsPath == undefined) {
        throw new Error('Variável de ambiente CONFIG_PARAMETERS não foi definida');
    }
    return JSON.parse(fs.readFileSync(paramsPath, 'utf8'));
}

function getParameter(parameters, name) {
    const value = parameters[name];
    if(value == undefined) {
        throw new Error(`Parâmetro ${name} indefinido`);
    }
    return value;
}

async function diagnostics() {
    console.log('--------------------------------------------------');

    console.log(`Parâmetros de configuração: ${process.env['CONFIG_PARAMETERS']}`);

    const accs = await hre.ethers.getSigners();
    console.log(`Conta em uso: ${accs[0].address}`);
    
    console.log();
}

async function executeProposal(governanceContract, idProposal) {
    console.log('--------------------------------------------------');
    console.log(`Executando proposta ${idProposal}`);
    const resp = await governanceContract.executeProposal(idProposal);
    await resp.wait();
    // Verificações
    const proposal = await governanceContract.getProposal(idProposal);
    assert.equal(proposal.status, STATUS_EXECUTED);
    assert.equal(proposal.result, RESULT_APPROVED);
    console.log(` Proposta ${idProposal} executada.`);
    console.log();
}

async function approveProposal(governanceContract, idProposal, globalAdmins) {
    console.log('--------------------------------------------------');
    console.log(`Aprovando proposta ${idProposal}`);
    
    for(const admin of globalAdmins) {
        try {
            const signer = await hre.ethers.getSigner(admin);
            assert.ok(signer != null);
            const resp = await governanceContract.connect(signer).castVote(idProposal, true);
            await resp.wait();
            console.log(` - Admin ${admin} enviou voto de aprovação`);
        }
        catch(error) {
            console.log(` - Erro ao enviar voto do admin ${admin}: ${error.message}`);
        }
    }
    
    // Verificações
    const proposal = await governanceContract.getProposal(idProposal);
    assert.equal(proposal.status, STATUS_ACTIVE);
    assert.equal(proposal.result, RESULT_APPROVED);
    console.log(` Proposta ${idProposal} aprovada.`);
    console.log();
}

module.exports = {
    getParameters: getParameters,
    getParameter: getParameter,
    diagnostics: diagnostics, 
    executeProposal: executeProposal,
    approveProposal: approveProposal
}
