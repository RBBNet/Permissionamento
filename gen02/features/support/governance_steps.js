const assert = require('assert');
const { Given, When, Then } = require('@cucumber/cucumber');
const hre = require("hardhat");
const { getProposalStatus, getProposalResult, getVote, getProposalVote } = require('./setup.js');


Given('implanto o smart contract de governança do permissionamento', async function () {
    this.govenanceContractDeployError = null;
    try {
        this.govenanceContract = await hre.ethers.deployContract("Governance", [this.organizationContractAddress, this.accountRulesContractAddress]);
        assert.ok(this.govenanceContract != null);
    }
    catch(error) {
        this.govenanceContractDeployError = error;
    }
});

Then('a implantação do smart contract de governança do permissionamento ocorre com sucesso', function() {
    assert.ok(this.govenanceContractDeployError == null);
});

Given('implanto um smart contract mock para que sofra ações da governança', async function () {
    this.mockContractDeployError = null;
    try {
        this.mockContract = await hre.ethers.deployContract("ExecutionMock", []);
        assert.ok(this.mockContract != null);
        this.mockContractAddress = await this.mockContract.getAddress();
        assert.ok(this.mockContractAddress != null);
    }
    catch(error) {
        this.mockContractDeployError = error;
    }
});

Then('a implantação do smart contract mock ocorre com sucesso', function() {
    assert.ok(this.mockContractDeployError == null);
});


When('um observador consulta a proposta {int} ocorre erro {string}', async function(proposalId, errorMessage) {
    try {
        await this.govenanceContract.getProposal(proposalId);
        assert.fail('Deveria ter ocorrido erro na consulta de proposta');
    }
    catch(error) {
        assert.ok(error.message.includes(errorMessage));
    }
});

//https://emn178.github.io/online-tools/keccak_256.html
//https://abi.hashex.org/
//https://docs.ethers.org/v6/api/abi/abi-coder/
When('a conta {string} cria uma proposta com alvo o smart contract de teste com dados {string}, limite de {int} blocos e descrição {string}', async function(admin, calldatas, blocksDuration, description) {
    const calldatasArray = calldatas.split(',');
    const targetsArray = [];
    for(i = 0; i < calldatasArray.length; ++i) {
        targetsArray.push(this.mockContractAddress);
    }
    
    this.creationError = null;
    try {
        const signer = await hre.ethers.getSigner(admin);
        assert.ok(signer != null);
        await this.govenanceContract.connect(signer).createProposal(targetsArray, calldatasArray, blocksDuration, description);
    }
    catch(error) {
        this.creationError = error;
    }
    
    const encodedData = hre.ethers.AbiCoder.defaultAbiCoder().encode(
        ['address[]', 'bytes[]', 'uint', 'string'],
        [targetsArray, calldatasArray, blocksDuration, description]
    );
    const keccak256encodedData = hre.ethers.keccak256(encodedData);
    this.proposalId = hre.ethers.toBigInt(keccak256encodedData);
});

Then('a proposta é criada com sucesso', function() {
    assert.ok(this.creationError == null);
});

Then('ocorre erro {string} na criação da proposta', function(error) {
    assert.ok(this.creationError != null);
    assert.ok(this.creationError.message.includes(error));
});

Then('o evento {string} é emitido para a proposta pela conta {string}', async function(event, creator) {
    const block = await hre.ethers.provider.getBlockNumber();
    const events = await this.govenanceContract.queryFilter(event, block, block);
    let found = false;
    for (let i = 0; i < events.length && !found; i++) {
        found =
            events[i].fragment.name == event &&
            events[i].args[0] == this.proposalId &&
            events[i].args[1] == creator;
    }
    assert.ok(found);
});

Then('a proposta tem situação {string}, resultado {string}, organizações {string} e votos {string}', async function(status, result, orgs, votes) {
    const expectedOrgs = orgs.split(',');
    const expectedVotes = votes.split(',');
    const proposal = await this.govenanceContract.getProposal(this.proposalId);
    const actualVotes = await this.govenanceContract.getVotes(this.proposalId);
    assert.equal(proposal.status, getProposalStatus(status));
    assert.equal(proposal.result, getProposalResult(result));
    assert.equal(proposal.organizations.length, expectedOrgs.length);
    for(i = 0; i < expectedOrgs.length; ++i) {
        assert.equal(proposal.organizations[i], expectedOrgs[i]);
    }
    assert.equal(actualVotes.length, expectedVotes.length);
    for(i = 0; i < expectedVotes.length; ++i) {
        assert.equal(actualVotes[i], getProposalVote(expectedVotes[i]));
    }
});

When('a conta {string} cancela a proposta', async function(admin) {
    this.cancelError = null;
    try {
        const signer = await hre.ethers.getSigner(admin);
        assert.ok(signer != null);
        await this.govenanceContract.connect(signer).cancelProposal(this.proposalId);
    }
    catch(error) {
        this.cancelError = error;
    }
});

When('a conta {string} cancela a proposta {int}', async function(admin, proposalId) {
    this.cancelError = null;
    try {
        const signer = await hre.ethers.getSigner(admin);
        assert.ok(signer != null);
        await this.govenanceContract.connect(signer).cancelProposal(proposalId);
    }
    catch(error) {
        this.cancelError = error;
    }
});

Then('a proposta é cancelada com sucesso', function() {
    assert.ok(this.cancelError == null);
});

Then('ocorre erro {string} no cancelamento da proposta', function(error) {
    assert.ok(this.cancelError != null);
    assert.ok(this.cancelError.message.includes(error));
});

When('a conta {string} envia um voto de {string}', async function(admin, vote) {
    this.voteError = null;
    try {
        const signer = await hre.ethers.getSigner(admin);
        assert.ok(signer != null);
        await this.govenanceContract.connect(signer).castVote(this.proposalId, getVote(vote));
    }
    catch(error) {
        this.voteError = error;
    }
});

When('a conta {string} envia um voto de {string} para a proposta {int}', async function(admin, vote, proposalId) {
    this.voteError = null;
    try {
        const signer = await hre.ethers.getSigner(admin);
        assert.ok(signer != null);
        await this.govenanceContract.connect(signer).castVote(proposalId, getVote(vote));
    }
    catch(error) {
        this.voteError = error;
    }
});

Then('o voto é registrado com sucesso', function() {
    assert.ok(this.voteError == null);
});

Then('ocorre erro {string} no envio do voto', function(error) {
    assert.ok(this.voteError != null);
    assert.ok(this.voteError.message.includes(error));
});

Then('o evento {string} é emitido para a proposta com voto de {string} pela conta {string}', async function(event, vote, creator) {
    const block = await hre.ethers.provider.getBlockNumber();
    const events = await this.govenanceContract.queryFilter(event, block, block);
    let found = false;
    for (let i = 0; i < events.length && !found; i++) {
        found =
            events[i].fragment.name == event &&
            events[i].args[0] == this.proposalId &&
            events[i].args[1] == creator &&
            events[i].args[2] == getVote(vote);
    }
    assert.ok(found);
});

Then('o evento {string} é emitido para a proposta', async function(event) {
    const block = await hre.ethers.provider.getBlockNumber();
    const events = await this.govenanceContract.queryFilter(event, block, block);
    let found = false;
    for (let i = 0; i < events.length && !found; i++) {
        found =
            events[i].fragment.name == event &&
            events[i].args[0] == this.proposalId;
    }
    assert.ok(found);
});

When('consulto o código do smart contract de teste o resultado é {int}', async function(expectedResult) {
    const actualResult = await this.mockContract.code();
    assert.equal(actualResult, expectedResult);
});

When('a conta {string} executa a proposta', async function(admin) {
    this.executionError = null;
    try {
        const signer = await hre.ethers.getSigner(admin);
        assert.ok(signer != null);
        await this.govenanceContract.connect(signer).executeProposal(this.proposalId);
    }
    catch(error) {
        this.executionError = error;
    }
});

Then('a proposta é executada com sucesso', function() {
    assert.ok(this.executionError == null);
});

Then('ocorre erro {string} na execução da proposta', function(error) {
    assert.ok(this.executionError != null);
    assert.ok(this.executionError.message.includes(error));
});
