const assert = require('assert');
const { Given, When, Then } = require('@cucumber/cucumber');
const hre = require("hardhat");
const { createOrganization, getBoolean } = require('./setup.js');
const web3 = require('web3');
async function addNode(signer, enodeHigh, enodeLow, name, type) {
    await this.nodeRules.connect(signer).addNode(enodeHigh, enodeLow, type, name);
    const added = await this.nodeRules.getNode(enodeHigh, enodeLow);
    assert.ok(added[0] === enodeHigh);
}

function checkErrorMessage(error, expectedMessage) {
    assert.ok(error.message.includes(expectedMessage));
}

Given("que o contrato de nós está implantado", async function() {
    this.nodeRules = await hre.ethers.deployContract("NodeRulesV2Impl", [this.accountRulesContract, this.organizationContractAddress, this.adminMockContractAddress]);
    const contractAddress = await this.nodeRules.getAddress();
    assert.ok(contractAddress != null);
});

When(/^o administrador "([^"]*)" informa o enodeHigh "([^"]*)", o enodeLow "([^"]*)", o nome "([^"]*)" e o tipo "([^"]*)" do nó para cadastrá-lo$/, async function (admin, enodeHigh, enodeLow, name, type) {
    const signer = await hre.ethers.getSigner(admin);
    try {
        await addNode.call(this, signer, enodeHigh, enodeLow, name, type);
    } catch (e) {
        this.error = e;
    }
});

Then(/^o evento NodeAdded é emitido para a conta "([^"]*)"$/, async function (admin) {
    const block = await hre.ethers.provider.getBlockNumber();
    const events = await this.nodeRules.queryFilter("NodeAdded", 0, block);
    const eventAdmin = events[0].args[2];
    assert.ok(eventAdmin === admin);
});

Then(/^o nó de enodeHigh "([^"]*)" e enodeLow "([^"]*)" tem a mesma organização que o administrador "([^"]*)"$/, async function (enodeHigh, enodeLow, admin) {
    const nodeInfo = await this.nodeRules.getNode(enodeHigh, enodeLow);
    const nodeOrg = parseInt(nodeInfo[4]);
    const adminInfo = await this.accountRulesContract.getAccount(admin);
    const adminOrg = parseInt(adminInfo[0]);
    assert.ok(nodeOrg === adminOrg);
});

When(/^o administrador inativo "([^"]*)" informa o enodeHigh "([^"]*)", o enodeLow "([^"]*)", o nome "([^"]*)" e o tipo "([^"]*)" do nó para cadastrá-lo$/, async function (admin, enodeHigh, enodeLow, name, type) {
    const signer = await hre.ethers.getSigner(admin);
    try {
        await this.nodeRules.connect(signer).addNode(enodeHigh, enodeLow, type, name);
    } catch (error) {
        checkErrorMessage(error, `InactiveAccount("${admin}", "The account or the respective organization is not active")`);
    }
});

Then(/^o nó de enodeHigh "([^"]*)" e enodeLow "([^"]*)" recebe o erro "([^"]*)"$/, async function (enodeHigh, enodeLow, expectedErrorMessage) {
    try {
        await this.nodeRules.getNode(enodeHigh, enodeLow);
    } catch (error) {
        checkErrorMessage(error, expectedErrorMessage);
    }
});

Then (/^o erro recebido é "([^"]*)"$/, async function (error){
    checkErrorMessage(this.error, error);
});
