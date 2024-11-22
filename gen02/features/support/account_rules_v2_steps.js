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

Then('a conta {string} não consta na lista de contas do papel {string}', async function(account, role) {
    const hasRole = await this.accountRulesContract.hasRole(getRoleId(role), account);
    assert.equal(hasRole, false);
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
    const events = await this.accountRulesContract.queryFilter(event, block, block);
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

When('a conta {string} atualiza o papel da conta local {string} para {string}', async function(admin, account, role) {
    this.updateError = null;
    try {
        const signer = await hre.ethers.getSigner(admin);
        assert.ok(signer != null);
        await this.accountRulesContract.connect(signer).updateLocalAccountRole(account, getRoleId(role));
    }
    catch(error) {
        this.updateError = error;
    }
});

When('a conta {string} atualiza o hash cadastral da conta local {string} para {string}', async function(admin, account, dataHash) {
    this.updateError = null;
    try {
        const signer = await hre.ethers.getSigner(admin);
        assert.ok(signer != null);
        await this.accountRulesContract.connect(signer).updateLocalAccountDataHash(account, dataHash);
    }
    catch(error) {
        this.updateError = error;
    }
});

When('a conta {string} atualiza a situação ativa da conta local {string} para {string}', async function(admin, account, active) {
    this.updateError = null;
    try {
        const signer = await hre.ethers.getSigner(admin);
        assert.ok(signer != null);
        await this.accountRulesContract.connect(signer).updateLocalAccountStatus(account, getBoolean(active));
    }
    catch(error) {
        this.updateError = error;
    }
});

Then('ocorre erro {string} na tentativa de atualização de conta', function(error) {
    assert.ok(this.updateError != null);
    assert.ok(this.updateError.message.includes(error));
});

Then('o evento {string} foi emitido para a conta {string}, organização {int}, papel {string} e admin {string}', async function(event, account, orgId, role, admin) {
    const block = await hre.ethers.provider.getBlockNumber();
    const events = await this.accountRulesContract.queryFilter(event, block, block);
    let found = false;
    for (let i = 0; i < events.length && !found; i++) {
        found =
            events[i].fragment.name == event &&
            events[i].args[0] == account &&
            events[i].args[1] == orgId &&
            events[i].args[2] == getRoleId(role) &&
            events[i].args[3] == admin
    }
    assert.ok(found);
});

Then('o evento {string} foi emitido para a conta {string}, organização {int}, data hash {string} e admin {string}', async function(event, account, orgId, dataHash, admin) {
    const block = await hre.ethers.provider.getBlockNumber();
    const events = await this.accountRulesContract.queryFilter(event, block, block);
    let found = false;
    for (let i = 0; i < events.length && !found; i++) {
        found =
            events[i].fragment.name == event &&
            events[i].args[0] == account &&
            events[i].args[1] == orgId &&
            events[i].args[2] == dataHash &&
            events[i].args[3] == admin
    }
    assert.ok(found);
});

Then('o evento {string} foi emitido para a conta {string}, organização {int}, situação ativa {string} e admin {string}', async function(event, account, orgId, active, admin) {
    const block = await hre.ethers.provider.getBlockNumber();
    const events = await this.accountRulesContract.queryFilter(event, block, block);
    let found = false;
    for (let i = 0; i < events.length && !found; i++) {
        found =
            events[i].fragment.name == event &&
            events[i].args[0] == account &&
            events[i].args[1] == orgId &&
            events[i].args[2] == getBoolean(active) &&
            events[i].args[3] == admin
    }
    assert.ok(found);
});

Then('a conta {string} chamar o endereço {string} tem verificação de permissionamento {string}', async function(sender, target, allowed) {
    const wasAllowed = await this.accountRulesContract.transactionAllowed(sender, target, 0, 0, 0, '0x');
    assert.equal(wasAllowed, getBoolean(allowed));
});

When('a conta {string} configura restrição de acesso ao endereço {string} permitindo acesso somente pelas contas {string}', async function(admin, target, addresses) {
    this.accessConfigurationError = null;
    try {
        const signer = await hre.ethers.getSigner(admin);
        assert.ok(signer != null);
        await this.accountRulesContract.connect(signer).setSmartContractAccess(target, true, getSenders(addresses));
    }
    catch(error) {
        this.accessConfigurationError = error;
    }
});

function getSenders(addresses) {
    let senders = [];
    if(addresses.length > 0) {
        senders = addresses.split(",");
    }
    return senders;
}

When('a conta {string} remove restrição de acesso ao endereço {string}', async function(admin, target) {
    this.accessConfigurationError = null;
    try {
        const signer = await hre.ethers.getSigner(admin);
        assert.ok(signer != null);
        await this.accountRulesContract.connect(signer).setSmartContractAccess(target, false, []);
    }
    catch(error) {
        this.accessConfigurationError = error;
    }
});

Then('a configuração de acesso ocorre com sucesso', function() {
    assert.ok(this.accessConfigurationError == null);
});

Then('ocorre erro {string} na tentativa de configuração de acesso', function(error) {
    assert.ok(this.accessConfigurationError != null);
    assert.ok(this.accessConfigurationError.message.includes(error));
});

Then('o evento {string} foi emitido para o smart contract {string} com restrição {string} permitindo as contas {string} executado pelo admin {string}', async function(event, target, restricted, addresses, admin) {
    const block = await hre.ethers.provider.getBlockNumber();
    const events = await this.accountRulesContract.queryFilter(event, block, block);
    let found = false;
    for (let i = 0; i < events.length && !found; i++) {
        found =
            events[i].fragment.name == event &&
            events[i].args[0] == target &&
            events[i].args[1] == getBoolean(restricted) &&
            events[i].args[2].toString() == addresses &&
            events[i].args[3] == admin
    }
    assert.ok(found);
});
