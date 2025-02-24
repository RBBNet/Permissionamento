const hre = require('hardhat');
const assert = require('assert');
const { getParameters, getParameter, diagnostics, askConfirmation, getDefaultSigner, getRoleId } = require('./util.js');
const { ZEROED_BYTES, NON_ZEROED_ADDRESS } = require('./constants.js');

async function testAccounts(parameters) {
    await diagnostics();

    console.log('--------------------------------------------------');
    console.log('Testando acesso de contas - transactionAllowed()');

    const accountRulesV2Address = getParameter(parameters, 'accountRulesV2Address');
    const accountsContract = await hre.ethers.getContractAt('AccountRulesV2Impl', accountRulesV2Address);
    const accounts = getParameter(parameters, 'accounts');
    for(acc of accounts) {
        try {
            const allowed = await accountsContract.transactionAllowed(acc.account, NON_ZEROED_ADDRESS, 0, 0, 0, ZEROED_BYTES);
            const result = allowed ? 'OK' : 'ERRO';
            console.log(` - ${result} - ${acc.account}`);
        }
        catch(error) {
            console.log(` - Erro na verificação de acesso da conta ${acc.account}: ${error.message}`);
        }
    }
}

const parameters = getParameters();
testAccounts(parameters);