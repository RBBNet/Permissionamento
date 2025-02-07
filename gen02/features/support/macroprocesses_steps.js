const assert = require('assert');
const { Given, When, Then } = require('@cucumber/cucumber');
const hre = require("hardhat");
const { getRoleId } = require('./setup.js');

function getContract(context, contract) {
    switch(contract) {
        case 'OrganizationImpl': return context.organizationContract;
        case 'AccountRulesV2Impl': return context.accountRulesContract;
        default: throw new Error('Alvo desconhecido: ' + contract);
    }
}

Given('o smart contract de governança é adicionado como admin master', async function() {
    await this.adminMockContract.addAdmin(this.govenanceContractAddress);
});

Given('o alvo {string} para chamada da função {string} com parâmetros {string}', async function(targetName, functionSignature, parameterList) {
    const targetContract = getContract(this, targetName);
    const targetAddress = await targetContract.getAddress();
    const parameters = parameterList.length == 0 ? [] : parameterList.split(',');
    const calldata = targetContract.interface.encodeFunctionData(functionSignature, parameters);
    this.proposalCalls.push([targetAddress, calldata]);
});

function getTargets(proposalCalls) {
    let targets = [];
    for(const call of proposalCalls) {
        targets.push(call[0]);
    }
    return targets;
}

function getCalldatas(proposalCalls) {
    let calldatas = [];
    for(const call of proposalCalls) {
        calldatas.push(call[1]);
    }
    return calldatas;
}

When('a conta {string} cria proposta com descrição {string}', async function(admin, description) {
    const signer = await hre.ethers.getSigner(admin);
    assert.ok(signer != null);
    this.creationError = null;
    try {
        await this.govenanceContract.connect(signer).createProposal(getTargets(this.proposalCalls), getCalldatas(this.proposalCalls), 30000, description);
    }
    catch(error) {
        this.creationError = error;
    }
    
    this.proposalId = await this.govenanceContract.idSeed();
});

Then('o evento {string} foi emitido para a conta {string}, organização {int}, papel {string}, data hash {string} pela governança', async function (event, account, orgId, role, dataHash) {
    const block = await hre.ethers.provider.getBlockNumber();
    const events = await this.accountRulesContract.queryFilter(event, block, block);
    let found = false;
    for (let i = 0; i < events.length && !found; i++) {
        found =
            events[i].fragment.name == event &&
            events[i].args[0] == account &&
            events[i].args[1] == orgId &&
            events[i].args[2] == getRoleId(role) &&
            events[i].args[3] == dataHash &&
            events[i].args[4] == this.govenanceContractAddress;
    }
    assert.ok(found);
});
