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
      accounts: ["0x701b615bbdfb9de65240bc28bd21bbc0d996645a3dd57e7b12bc2bdf6f192c82"],
      from: "0x71bE63f3384f5fb98995898A86B02Fb2426c5788"
    }
  },
  solidity: "0.8.26"
};
