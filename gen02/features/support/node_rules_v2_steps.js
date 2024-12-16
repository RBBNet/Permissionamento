const assert = require('assert');
const { Given, When, Then } = require('@cucumber/cucumber');
const hre = require("hardhat");

//forma mais bonita do que vários ifs
function typeToNumber(type) {
    const typeMap = {
        "Validator": 2,
        "Boot": 1,
        "Writer": 3,
        "ObserverBoot": 5
    };

    return typeMap[type] !== undefined ? typeMap[type] : 9;  // Retorna null ou um valor padrão se o tipo não for encontrado
}

function checkErrorMessage(error, expectedMessage) {
    assert.ok(error.message.includes(expectedMessage));
}

Given('que o contrato de nós está implantado', async function() {
    this.nodeRules = await hre.ethers.deployContract("NodeRulesV2Impl", [this.accountRulesContract, this.organizationContractAddress, this.adminMockContractAddress]);
    const contractAddress = await this.nodeRules.getAddress();
    assert.ok(contractAddress != null);
});

When('a conta {string} informa o endereço {string} {string}, o nome {string} e o tipo {string} do nó para cadastrá-lo', async function (admin, enodeHigh, enodeLow, name, type) {
    const signer = await hre.ethers.getSigner(admin);
    type = typeToNumber(type);
    try {
        await this.nodeRules.connect(signer).addLocalNode(enodeHigh, enodeLow, type, name);
    } catch (e) {
        this.error = e;
    }
});

Then('o evento {string} é emitido para a conta {string}', async function (event, admin) {
    const block = await hre.ethers.provider.getBlockNumber();
    const events = await this.nodeRules.queryFilter(event, block, block);
    const eventAdmin = events[0].args[2];
    assert.ok(eventAdmin === admin);
});

Then('o nó de enodeHigh {string} e enodeLow {string} tem a mesma organização que o administrador {string}', async function (enodeHigh, enodeLow, admin) {
    const nodeInfo = await this.nodeRules.getNode(enodeHigh, enodeLow);
    const nodeOrg = parseInt(nodeInfo[4]);
    const adminInfo = await this.accountRulesContract.getAccount(admin);
    const adminOrg = parseInt(adminInfo[0]);
    assert.ok(nodeOrg === adminOrg);
});

Then('o nó de enodeHigh {string} e enodeLow {string} recebe o erro {string}', async function (enodeHigh, enodeLow, expectedErrorMessage) {
    try {
        await this.nodeRules.getNode(enodeHigh, enodeLow);
    } catch (error) {
        checkErrorMessage(error, expectedErrorMessage);
    }
});

Then('o erro recebido é {string}', function (error) {
    checkErrorMessage(this.error, error);
});

When('a conta {string} informa o endereço {string} {string} para exclusão', async function (admin, enodeHigh, enodeLow) {
    const signer = await hre.ethers.getSigner(admin);
    try {
        await this.nodeRules.connect(signer).deleteLocalNode(enodeHigh, enodeLow);
    } catch(error) {
        this.error = error;
    }
});

When('a conta de governança {string} informa o enodeHigh {string}, o enodeLow {string}, o nome {string}, a organização {string} e o tipo {string} do nó para cadastrá-lo', async function (admin, enodeHigh, enodeLow, name, org, type) {
    const signer = await hre.ethers.getSigner(admin);
    try{
        await this.nodeRules.connect(signer).addNodeByGovernance(enodeHigh, enodeLow,type,name,org);
        const added = await this.nodeRules.getNode(enodeHigh, enodeLow);
        assert.ok(added[0] === enodeHigh);
    } catch(error) {
        this.error = error;
    }
});

When('a conta {string} informa o endereço {string} {string}, o nome {string} e o tipo {string} para alterá-lo', async function (admin, enodeHigh, enodeLow, name, type) {

    try{
        this.oldInfo = await this.nodeRules.getNode(enodeHigh, enodeLow);
        const signer = await hre.ethers.getSigner(admin);
        type = typeToNumber(type);
        await this.nodeRules.connect(signer).updateLocalNode(enodeHigh, enodeLow, type, name);
        this.newInfo = await this.nodeRules.getNode(enodeHigh, enodeLow);
        assert.ok(this.newInfo[3] !== this.oldInfo[3]);
    } catch(error) {
        this.error = error;
    }
});

Then('o nome do nó {string} {string} continua o mesmo', async function (enodeHigh, enodeLow) {
    this.newInfo = await this.nodeRules.getNode(enodeHigh, enodeLow);
    assert.ok(this.newInfo[3] === this.oldInfo[3]);
});