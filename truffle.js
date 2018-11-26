const HDWalletProvider = require("truffle-hdwallet-provider-privkey");
const NonceTrackerSubprovider = require("web3-provider-engine/subproviders/nonce-tracker");

module.exports = {
  networks: {
    ropsten: {
      provider: () => {
        let wallet = new HDWalletProvider(
          [""], // Private Key (Use a seperate deployment wallet)
          "" // RPC Host (Infura, your own etc)
        );
        let nonceTracker = new NonceTrackerSubprovider();
        wallet.engine._providers.unshift(nonceTracker);
        nonceTracker.setEngine(wallet.engine);
        return wallet;
      },
      network_id: 3,
      gas: 4712388,
      gasPrice: 100000000000,
      network_id: "ropsten",

      // Chainlink Configuration: LinkPool Ropsten Node
      oracleAddress: "0xbe4cda56b65af5ab59276ca02e103584aba84603",
      jobId: "2618ad23e2874c36881282e96e819ac4"
    },
    development: {
      host: "localhost",
      port: 8545,
      network_id: "*",
      gas: 6712390,

      // Chainlink Configuration: Enter your local job id and oracle address
      oracleAddress: "",
      jobId: ""
    }
  },
  solc: {
    optimizer: {
      enabled: true,
      runs: 200
    }
  }
};
