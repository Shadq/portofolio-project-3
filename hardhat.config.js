require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();
require("@nomiclabs/hardhat-etherscan");
require("hardhat-gas-reporter");
require("solidity-coverage");

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: {
    compilers: [{ version: "0.8.17" }, { version: "0.5.0" }],
  },

  networks: {
    sepolia: {
      url: process.env.SEPOLIA_RPC_URL || "https://eth-goerli",
      accounts: [process.env.SEPOLIA_PRIVATE_KEY],
      chainId: 11155111,
      blockConfirmations: 6,
    },
  },

  etherscan: { apiKey: process.env.ETHERSCAN_API_KEY || "key" },

  namedAccounts: {
    deployer: {
      default: 0,
    },
  },
};
