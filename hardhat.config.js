// alchemyApiKey 
// Go to https://www.alchemyapi.io, sign up, create
// a new App in its dashboard, and replace "KEY" with its key
// mnemonic 
// To export your private key from Metamask, open Metamask and
// go to Account Details > Export Private Key
// Be aware of NEVER putting real Ether into testing accounts
const { alchemyApiKey, mnemonic } = require('./secrets.json');
require("@nomiclabs/hardhat-waffle");

module.exports = {
  solidity: "0.8.13",
  networks: {
    arbitrum_rinkeby: {
      url: `https://rinkeby.arbitrum.io/rpc/${alchemyApiKey}`,
      accounts: [`${mnemonic}`]
    }
  }
};