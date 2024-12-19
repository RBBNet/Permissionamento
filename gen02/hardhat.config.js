require("@nomicfoundation/hardhat-toolbox");
const dotenv = require('dotenv');

dotenv.config();

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  networks: {
    local: {
      url: "http://127.0.0.1:8545"
    },
    local_besu: {
      url: "http://127.0.0.1:8545",
      chainId: 648629,
      accounts: ["0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80"],
      from: "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266"
    }
  },
  solidity: "0.8.26"
};
