
require('dotenv').config();
require('babel-register');
require('babel-polyfill');

const Web3 = require("web3");
const web3 = new Web3();
const WalletProvider = require("truffle-wallet-provider");
const Wallet = require('ethereumjs-wallet');
var HDWalletProvider = require("truffle-hdwallet-provider");
var mnemonic = "orange apple banana";

// -- AIC Owner --
//1. Mainnet
var mainNetPrivateKey = Buffer.from("b65d2db4a220ef20a78b90bebb8490c04eeb9ee941b54ff61147ce8de7f35478", "hex")
var mainNetWallet = Wallet.fromPrivateKey(mainNetPrivateKey);
var mainNetProvider = new WalletProvider(mainNetWallet, "https://mainnet.infura.io/dnJCwOyWDu20Vlp4rV5N");

module.exports = {
  networks: {
    development: {
      host: "localhost",
      port: 8545,
      network_id: "*" // Match any network id
    },
    ropsten: {
      provider: ropstenProvider,
      gas: 4700000,
      gasPrice: web3.toWei("40", "gwei"),
      network_id: "3",
    },
    mainnet: {
      provider: mainNetProvider,
      gas: 4700000,
      gasPrice: web3.toWei("40", "gwei"),
      network_id: "1",
    }
  },
  mocha: {
    reporter: 'eth-gas-reporter',
    reporterOptions : {
      currency: 'ETH',
      gasPrice: 1
    }
  }
};
