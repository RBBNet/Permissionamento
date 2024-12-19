const fs = require('fs');

function getParameters() {
    const paramsPath = process.env['CONFIG_PARAMETERS'];
    if(paramsPath == undefined) {
        throw new Error('Variável de ambiente CONFIG_PARAMETERS não foi definida');
    }
    
    console.log(`Utilizando parâmetros de configuração do arquivo ${paramsPath}`);
    return JSON.parse(fs.readFileSync(paramsPath, 'utf8'));
}

function getParameter(parameters, name) {
    const value = parameters[name];
    if(value == undefined) {
        throw new Error(`Parâmetro ${name} indefinido`);
    }
    return value;
}

module.exports = {
    getParameters: getParameters,
    getParameter: getParameter
}
