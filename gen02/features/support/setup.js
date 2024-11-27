const { Before } = require('@cucumber/cucumber')

function createOrganization(name, canVote) {
    return {
        "id": 0,
        "name": name,
        "canVote": canVote
    }
}

function getBoolean(value) {
    switch(value.toLowerCase()) {
        case 'true': return true;
        case 'false': return false;
        default: throw new Error('Valor booleano inválido: ' + value);
    }    
}

function getRoleId(role) {
    switch(role) {
        case 'GLOBAL_ADMIN_ROLE': return '0xd6e7d8560c69c7c18c2b8f3b45430215d788f128f0c04bc4a3607fe05eb5399f';
        case 'LOCAL_ADMIN_ROLE': return '0xb7f8beecafe1ad662cec1153812612581a86b9460f21b876f3ee163141203dcb';
        case 'DEPLOYER_ROLE': return '0xfc425f2263d0df187444b70e47283d622c70181c5baebb1306a01edba1ce184c';
        case 'USER_ROLE' : return '0x14823911f2da1b49f045a0929a60b8c1f2a7fc8c06c7284ca3e8ab4e193a08c8';
        case 'UNKNOWN_ROLE' : return '0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff';
        default: throw new Error('Role inválida: ' + role);
    }
}

function getProposalStatus(status) {
    switch(status) {
        case 'Undefined': return 0;
        case 'Active': return 1;
        case 'Canceled': return 2;
        case 'Finished' : return 3;
        case 'Executed' : return 4;
        default: throw new Error('Status inválido: ' + status);
    }
}

function getProposalResult(result) {
    switch(result) {
        case 'Undefined': return 0;
        case 'Approved': return 1;
        case 'Rejected': return 2;
        default: throw new Error('Resultado inválido: ' + result);
    }
}

Before(function() {
    this.organizations = [];
    this.accounts = [];
});

module.exports = {
    createOrganization: createOrganization,
    getBoolean: getBoolean,
    getRoleId: getRoleId,
    getProposalStatus: getProposalStatus,
    getProposalResult: getProposalResult
}
