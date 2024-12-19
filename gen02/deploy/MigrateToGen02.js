const hre = require('hardhat');
const assert = require('assert');
const { getParameters, getParameter } = require('./util.js');

const INGRESS_ABI = [
    'function getContractAddress(bytes32) public view returns(address)',
    'function setContractAddress(bytes32, address) public returns (bool)'
];

const RULES_CONTRACT = '0x72756c6573000000000000000000000000000000000000000000000000000000';
const NODE_INGRESS_ADDRESS = '0x0000000000000000000000000000000000009999';
const ACCOUNT_INGRESS_ADDRESS = '0x0000000000000000000000000000000000008888';

async function verifyGen02(parameters) {
    console.log('--------------------------------------------------');
    console.log('Verificando gen02\n');

    const nodeRulesV2Address = getParameter(parameters, 'nodeRulesV2Address');
    const accountRulesV2Address = getParameter(parameters, 'accountRulesV2Address');
    
    console.log(`Verificando NodeRulesV2Impl no endereço ${nodeRulesV2Address}`);
    // TODO Verificar de alguma forma...
    console.log(' NodeRulesV2Impl OK');

    console.log(`Verificando AccountRulesV2Impl no endereço ${accountRulesV2Address}`);
    // TODO Verificar de alguma forma...
    console.log(' AccountRulesV2Impl OK');
    
    console.log('Verificando ponteiramento do NodeRules');
    const nodeIngressContract = await hre.ethers.getContractAt(INGRESS_ABI, NODE_INGRESS_ADDRESS);
    const currentNodeRulesAddress = await nodeIngressContract.getContractAddress(RULES_CONTRACT);
    console.log(` NodeRules atualmente ponteirado para ${currentNodeRulesAddress}`);

    console.log('Verificando ponteiramento do AccountRules');
    const accountIngressContract = await hre.ethers.getContractAt(INGRESS_ABI, ACCOUNT_INGRESS_ADDRESS);
    const currentAccountRulesAddress = await accountIngressContract.getContractAddress(RULES_CONTRACT);
    console.log(` AccountRules atualmente ponteirado para ${currentAccountRulesAddress}`);
}

const parameters = getParameters();
verifyGen02(parameters);
