const assert = require('assert');
const { Given, When, Then } = require('@cucumber/cucumber');
const hre = require("hardhat");

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
