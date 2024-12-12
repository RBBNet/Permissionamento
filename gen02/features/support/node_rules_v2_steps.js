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

//forma mais bonita do que vários ifs
function typeToNumber(type) {
    const typeMap = {
        "Validator": 2,
        "Boot": 1,
        "Writer": 3,
        "ObserverBoot": 5
    };

    return typeMap[type] !== undefined ? typeMap[type] : null;  // Retorna null ou um valor padrão se o tipo não for encontrado
}

async function removeNode(signer, enodeHigh, enodeLow) {
    await this.nodeRules.connect(signer).removeNode(enodeHigh, enodeLow);
    try {
        await this.nodeRules.getNode(enodeHigh, enodeLow);
    } catch(error){
        assert.ok(error.message.includes(`NodeDoesntExist("${enodeHigh}", "${enodeLow}", "Node does not exist.")`));
    }

}

function checkErrorMessage(error, expectedMessage) {
    assert.ok(error.message.includes(expectedMessage));
}

Given("que o contrato de nós está implantado", async function() {
    this.nodeRules = await hre.ethers.deployContract("NodeRulesV2Impl", [this.accountRulesContract, this.organizationContractAddress, this.adminMockContractAddress]);
    const contractAddress = await this.nodeRules.getAddress();
    assert.ok(contractAddress != null);
});

When(/^a conta "([^"]*)" informa o endereço "([^"]*)" "([^"]*)", o nome "([^"]*)" e o tipo "([^"]*)" do nó para cadastrá-lo$/, async function (admin, enodeHigh, enodeLow, name, type) {
    const signer = await hre.ethers.getSigner(admin);
    type = typeToNumber(type);
    try {
        await addNode.call(this, signer, enodeHigh, enodeLow, name, type);
    } catch (e) {
        this.error = e;
    }
});

Then(/^o evento "([^"]*)" é emitido para a conta "([^"]*)"$/, async function (event, admin) {
    const block = await hre.ethers.provider.getBlockNumber();
    const events = await this.nodeRules.queryFilter(event, 0, block);
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

// When(/^o administrador inativo "([^"]*)" informa o endereço "([^"]*)" mais "([^"]*)", o nome "([^"]*)" e o tipo "([^"]*)" do nó para cadastrá-lo$/, async function (admin, enodeHigh, enodeLow, name, type) {
//     const signer = await hre.ethers.getSigner(admin);
//     type = typeToNumber(type);
//     try {
//         await this.nodeRules.connect(signer).addNode(enodeHigh, enodeLow, type, name);
//     } catch (error) {
//         checkErrorMessage(error, `InactiveAccount("${admin}", "The account or the respective organization is not active")`);
//     }
// });

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

When(/^a conta "([^"]*)" informa o endereço "([^"]*)" "([^"]*)" para exclusão$/, async function (admin, enodeHigh, enodeLow) {
    const signer = await hre.ethers.getSigner(admin);
    try {
        await removeNode.call(this, signer, enodeHigh, enodeLow);
    } catch(error) {
        this.error = error;
    }
});
When(/^a conta de governança "([^"]*)" informa o enodeHigh "([^"]*)", o enodeLow "([^"]*)", o nome "([^"]*)", a organização "([^"]*)" e o tipo "([^"]*)" do nó para cadastrá-lo$/, async function (admin, enodeHigh, enodeLow, name, org, type) {
    const signer = await hre.ethers.getSigner(admin);
    try{
        await this.nodeRules.connect(signer).addNodeByGovernance(enodeHigh, enodeLow,type,name,org);
        const added = await this.nodeRules.getNode(enodeHigh, enodeLow);
        assert.ok(added[0] === enodeHigh);
    } catch(error) {
        this.error = error;
    }
});