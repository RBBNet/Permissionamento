const AllowlistUtils = require('../utils/allowlist_utils');

async function validate() {

    console.log("   > Initial validations ...");
    if (AllowlistUtils.isInitialAdminAccountsAvailable()) {
        try {
            console.log("   > Validating Initial Admin Account Addresses ...");
            AllowlistUtils.getInitialAdminAccounts();
        } catch (e) {
            console.log("   > Invalid Initial Admin Account Address: " + e);
            throw e;
        }
    }

    if (AllowlistUtils.isInitialAllowlistedAccountsAvailable()) {
        try {
            console.log("   > Validating Initial Allowlisted Account Addresses ...");
            AllowlistUtils.getInitialAllowlistedAccounts();
        } catch (e) {
            console.log("   > Invalid Initial Allowlisted Account Address: " + e);
            throw e;
        }
    }

    if (AllowlistUtils.isInitialAllowlistedNodesAvailable()) {
        try {
            console.log("   > Validating Initial Allowlisted eNode Addresses ...");
            AllowlistUtils.getInitialAllowlistedNodes();
        } catch (e) {
            console.log("   > Invalid Initial Allowlisted eNode Address: " + e);
            throw e;
        }
    }

    console.log("Validation step finished");
};

module.exports = {
    validate
}