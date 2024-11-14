const assert = require('assert');
const { Given, When, Then } = require('@cucumber/cucumber');
const hre = require("hardhat");
const { createOrganization, getBoolean, getRoleId } = require('./setup.js');

Given('a conta {string}', function(acc) {
    this.accounts.push(acc);
});

When('implanto o smart contract de gestão de contas', async function () {
    this.accountRulesContractDeployError = null;
    try {
        this.accountRulesContract = await hre.ethers.deployContract("AccountRulesV2Impl", [this.accounts, this.adminMockContractAddress]);
        assert.ok(this.accountRulesContract != null);
        this.accountRulesContractAddress = await this.accountRulesContract.getAddress();
        assert.ok(this.accountRulesContractAddress != null);
        await this.accountRulesContract.configure(this.organizationContractAddress);
    }
    catch(error) {
        this.accountRulesContractDeployError = error;
    }
});

Then('a implantação do smart contract de gestão de contas ocorre com sucesso', function() {
    assert.ok(this.accountRulesContractDeployError == null);
});

Then('ocorre erro na implantação do smart contract de gestão de contas', function () {
    assert.ok(this.accountRulesContractDeployError != null);
});

When('a conta {string} adiciona a conta local {string} com papel {string} e data hash {string}', async function (admin, account, role, dataHash) {
    this.addError = null;
    try {
        const signer = await hre.ethers.getSigner(admin);
        assert.ok(signer != null);
        await this.accountRulesContract.connect(signer).addLocalAccount(account, getRoleId(role), dataHash);
    }
    catch(error) {
        this.addError = error;
    }
});

When('a conta {string} adiciona a conta {string} na organização {int} com papel {string} e data hash {string}', async function (admin, account, orgId, role, dataHash) {
    this.addError = null;
    try {
        const signer = await hre.ethers.getSigner(admin);
        assert.ok(signer != null);
        await this.accountRulesContract.connect(signer).addAccount(account, orgId, getRoleId(role), dataHash);
    }
    catch(error) {
        this.addError = error;
    }
});

Then('a conta {string} é da organização {int} com papel {string}, data hash {string} e situação ativa {string}', async function (account, orgId, role, dataHash, active) {
    const acc = await this.accountRulesContract.getAccount(account);
    const hasRole = await this.accountRulesContract.hasRole(getRoleId(role), account);
    assert.equal(acc.orgId, orgId);
    assert.equal(acc.roleId, getRoleId(role));
    assert.equal(acc.dataHash, dataHash);
    assert.equal(hasRole, true);
    assert.equal(acc.active, getBoolean(active));
});

Then('o evento {string} foi emitido para a conta {string}, organização {int}, papel {string}, data hash {string} e admin {string}', async function (event, account, orgId, role, dataHash, admin) {
    const block = await hre.ethers.provider.getBlockNumber();
    const events = await this.accountRulesContract.queryFilter(event, 0, block);
    let found = false;
    for (let i = 0; i < events.length && !found; i++) {
        found =
            events[i].fragment.name == event &&
            events[i].args[0] == account &&
            events[i].args[1] == orgId &&
            events[i].args[2] == getRoleId(role) &&
            events[i].args[3] == dataHash &&
            events[i].args[4] == admin
    }
    assert.ok(found);
});

Then('ocorre erro {string} na tentativa de adição de conta', function(error) {
    assert.ok(this.addError != null);
    assert.ok(this.addError.message.includes(error));
});

Then('verifico se a conta {string} está ativa o resultado é {string}', async function(account, active) {
    const accountActive = await this.accountRulesContract.isAccountActive(account);
    assert.equal(accountActive, getBoolean(active));
});

When('a conta {string} exclui a conta local {string}', async function(admin, account) {
    this.deleteError = null;
    try {
        const signer = await hre.ethers.getSigner(admin);
        assert.ok(signer != null);
        await this.accountRulesContract.connect(signer).deleteLocalAccount(account);
    }
    catch(error) {
        this.deleteError = error;
    }
});

When('a conta {string} exclui a conta {string}', async function(admin, account) {
    this.deleteError = null;
    try {
        const signer = await hre.ethers.getSigner(admin);
        assert.ok(signer != null);
        await this.accountRulesContract.connect(signer).deleteAccount(account);
    }
    catch(error) {
        this.deleteError = error;
    }
});

Then('a exclusão é realizada com sucesso', function() {
    assert.ok(this.deleteError == null);
});

Then('ocorre erro {string} na tentativa de exclusão de conta', function(error) {
    assert.ok(this.deleteError != null);
    assert.ok(this.deleteError.message.includes(error));
});

Then('o evento {string} foi emitido para a conta {string}, organização {int} e admin {string}', async function (event, account, orgId, admin) {
    const block = await hre.ethers.provider.getBlockNumber();
    const events = await this.accountRulesContract.queryFilter(event, 0, block);
    let found = false;
    for (let i = 0; i < events.length && !found; i++) {
        found =
            events[i].fragment.name == event &&
            events[i].args[0] == account &&
            events[i].args[1] == orgId &&
            events[i].args[2] == admin
    }
    assert.ok(found);
});

Then('se tento obter os dados da conta {string} ocorre erro {string}', async function(account, error) {
    try {
        let acc = await this.accountRulesContract.getAccount(account);
        console.log(acc);
        assert.fail('Conta não deveria ter sido encontrada');
    }
    catch(getError) {
        assert.ok(getError.message.includes(error));
    }
});
