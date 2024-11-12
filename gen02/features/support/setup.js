const { Before } = require('@cucumber/cucumber')

function createOrganization(name) {
    return {
        "id": 0,
        "name": name,
        "canVote": true
    }
}

function getBoolean(value) {
    switch(value.toLowerCase()) {
        case 'true': return true;
        case 'false': return false;
        default: throw new Error('Valor booleano inválido: ' + value);
    }    
}

Before(function() {
    this.organizations = [];
});

module.exports = {
    createOrganization: createOrganization,
    getBoolean: getBoolean
}
