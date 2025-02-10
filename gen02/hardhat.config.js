require("@nomicfoundation/hardhat-toolbox");
const dotenv = require('dotenv');

dotenv.config();

/* The adress used when sending transactions to the node */
var accountAddress = process.env.ACCOUNT_ADDRESS;
/* The private key associated with the address above */
var privateKey = process.env.PRIVATE_KEY;

if(accountAddress === undefined) {
    console.error();
    console.error('Variável ACCOUNT_ADDRESS não configurada');
    console.error();
}

if(privateKey === undefined) {
    console.error();
    console.error('Variável PRIVATE_KEY não configurada');
    console.error();
}

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  networks: {
    local: {
      url: "http://127.0.0.1:8545"
    },
    local_besu: {
      url: "http://127.0.0.1:8545",
      chainId: 648629,
      accounts: [privateKey],
      from: accountAddress
    }
  },
  solidity: "0.8.26"
};
