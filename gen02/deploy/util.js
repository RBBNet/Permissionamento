const fs = require('fs');
const hre = require('hardhat');

function getParameters() {
    const paramsPath = process.env['CONFIG_PARAMETERS'];
    if(paramsPath == undefined) {
        throw new Error('Variável de ambiente CONFIG_PARAMETERS não foi definida');
    }
    return JSON.parse(fs.readFileSync(paramsPath, 'utf8'));
}

function getParameter(parameters, name) {
    const value = parameters[name];
    if(value == undefined) {
        throw new Error(`Parâmetro ${name} indefinido`);
    }
    return value;
}

async function diagnostics() {
    console.log('--------------------------------------------------');

    console.log(`Parâmetros de configuração: ${process.env['CONFIG_PARAMETERS']}`);

    const accs = await hre.ethers.getSigners();
    console.log(`Conta em uso: ${accs[0].address}`);
    
    console.log();
}

module.exports = {
    getParameters: getParameters,
    getParameter: getParameter,
    diagnostics: diagnostics
}
