const assert = require('assert');
const { defineParameterType, Given, When, Then } = require('@cucumber/cucumber');
const hre = require("hardhat");
const {boolean} = require("hardhat/internal/core/params/argumentTypes");
const { getNodeType, getConnectionResult } = require("./setup");

defineParameterType({
    name: "boolean",
    regexp: /true|false/,
    transformer: (s) => s === "true"
});

function checkErrorMessage(error, expectedMessage) {
    assert.ok(error.message.includes(expectedMessage));
}

Given('implanto o smart contract de gestão de nós', async function() {
    this.NodeRulesContractDeployError = null;
    try {
        this.nodeRules = await hre.ethers.deployContract("NodeRulesV2Impl", [this.organizationContractAddress, this.accountRulesContract, this.adminMockContractAddress]);
        assert.ok(this.nodeRules != null);
        const contractAddress = await this.nodeRules.getAddress();
        assert.ok(contractAddress != null);
    }
    catch(error) {
        this.NodeRulesContractDeployError = error;
    }
});

Then('a implantação do smart contract de gestão de nós ocorre com sucesso', function() {
    assert.ok(this.NodeRulesContractDeployError == null);
});

Then('a transação ocorre com sucesso', async function() {
   assert.ok(this.error === undefined);
});

Then('ocorre erro {string} na transação', async function(error){
    assert.ok(this.error);
    checkErrorMessage(this.error, error);
})

When('a conta {string} informa o endereço {string} {string}, o nome {string} e o tipo {string} do nó para cadastrá-lo', async function (admin, enodeHigh, enodeLow, name, type) {
    const signer = await hre.ethers.getSigner(admin);
    try {
        await this.nodeRules.connect(signer).addLocalNode(enodeHigh, enodeLow, getNodeType(type), name);
    }
    catch (e) {
        this.error = e;
    }
});

Then('o evento {string} é emitido para o nó {string} {string} pela conta {string} e organização {int}', async function (event, enodeHigh, enodeLow, admin, organization) {
    const block = await hre.ethers.provider.getBlockNumber();
    const events = await this.nodeRules.queryFilter(event, block, block);
    assert.equal(events[0].args[0], enodeHigh);
    assert.equal(events[0].args[1], enodeLow);
    assert.equal(parseInt(events[0].args[2]), organization);
    assert.equal(events[0].args[3], admin);
});

Then('o nó {string} {string} é da organização {int}, tem o nome {string} e tipo {string}', async function (enodeHigh, enodeLow, organization, name, type) {
    const nodeInfo = await this.nodeRules.getNode(enodeHigh, enodeLow);
    const nodeType = parseInt(nodeInfo[2]);
    const nodeName = nodeInfo[3];
    const nodeOrg = parseInt(nodeInfo[4]);
    assert.ok(nodeType === getNodeType(type));
    assert.ok(nodeName === name);
    assert.ok(nodeOrg === organization);
});

Then('se uma consulta é realizada ao nó {string} {string} recebe-se o erro {string}', async function (enodeHigh, enodeLow, expectedErrorMessage) {
    try {
        await this.nodeRules.getNode(enodeHigh, enodeLow);
        assert.fail('Deveria ter ocorrido erro na consulta de nó');
    }
    catch (error) {
        checkErrorMessage(error, expectedErrorMessage);
    }
});

When('a conta {string} informa o endereço {string} {string} para exclusão', async function (admin, enodeHigh, enodeLow) {
    const signer = await hre.ethers.getSigner(admin);
    try {
        await this.nodeRules.connect(signer).deleteLocalNode(enodeHigh, enodeLow);
    }
    catch(error) {
        this.error = error;
    }
});

When('a conta {string} informa o endereço {string} {string}, o nome {string} e o tipo {string} para alterá-lo', async function (admin, enodeHigh, enodeLow, name, type) {
    try{
        this.oldInfo = await this.nodeRules.getNode(enodeHigh, enodeLow);
        const signer = await hre.ethers.getSigner(admin);
        await this.nodeRules.connect(signer).updateLocalNode(enodeHigh, enodeLow, getNodeType(type), name);
    }
    catch(error) {
        this.error = error;
    }
});

Then('o nome do nó {string} {string} continua o mesmo', async function (enodeHigh, enodeLow) {
    this.newInfo = await this.nodeRules.getNode(enodeHigh, enodeLow);
    assert.ok(this.newInfo[3] === this.oldInfo[3]);
});

When('a conta {string} informa o endereço {string} {string} para mudar sua situação ativa para {boolean}', async function (admin, enodeHigh, enodeLow, status) {
    const signer = await hre.ethers.getSigner(admin);
    try {
        await this.nodeRules.connect(signer).updateLocalNodeStatus(enodeHigh, enodeLow, status);
    }
    catch(error){
        this.error = error;
    }
});

Then('o evento {string} é emitido para o nó {string} {string} com situação ativa {boolean} pela conta {string} e organização {int}', async function (event, enodeHigh, enodeLow, active, admin, organization) {
    const block = await hre.ethers.provider.getBlockNumber();
    const events = await this.nodeRules.queryFilter(event, block, block);
    assert.equal(events[0].args[0], enodeHigh);
    assert.equal(events[0].args[1], enodeLow);
    assert.equal(events[0].args[2], organization)
    assert.equal(events[0].args[3], active);
    assert.equal(events[0].args[4], admin)
});

Then('a situação ativa do nó {string} {string} é {boolean}', async function(enodeHigh, enodeLow, status){
   const nodeStatus = await this.nodeRules.isNodeActive(enodeHigh, enodeLow);
   assert.ok(nodeStatus === status);
});

When('a conta de governança {string} informa o endereço {string} {string}, o tipo {string}, o nome {string} e a organização {int} para cadastrá-lo', async function(admin, enodeHigh, enodeLow, type, name, organization) {
    const signer = await hre.ethers.getSigner(admin);
    try{
        await this.nodeRules.connect(signer).addNode(enodeHigh, enodeLow, getNodeType(type), name, organization);
    }
    catch(error){
        this.error = error;
    }
});

When('a conta de governança {string} informa o endereço {string} {string} do nó para removê-lo', async function(admin, enodeHigh, enodeLow) {
   const signer = await hre.ethers.getSigner(admin);
   try{
       await this.nodeRules.connect(signer).deleteNode(enodeHigh, enodeLow);
   }
   catch(error){
       this.error = error;
   }
});

When('o nó {string} {string} tenta se conectar ao nó {string} {string}', async function (sourceHigh, sourceLow, destHigh, destLow) {
   try{
       const bytes = '0x00000000000000000000000000000000'
       this.connResult = await this.nodeRules.connectionAllowed(sourceHigh, sourceLow, bytes, 0, destHigh, destLow, bytes, 0);
   }
   catch (error) {
       this.error = error;
   }
});

Then('o resultado da conexão é {string}', async function(result){
   assert.ok(this.error === undefined);
   assert.ok(this.connResult == getConnectionResult(result));
});