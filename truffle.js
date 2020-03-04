const HDWalletProvider = require("truffle-hdwallet-provider");

module.exports = {
  compilers: {
    solc: {
      version: "0.4.24"
    }
  },
  networks: {
    ropsten: {
      provider: function() {
        return new HDWalletProvider(
            "", // Mnemonic
            ""  // Ethereum client, Infura etc.
        );
      },
      network_id: 3,
      gas: 4712388,
      gasPrice: 10000000000,
      skipDryRun: true,

      // Chainlink Configuration: LinkPool Ropsten Node
      linkToken: "0x20fe562d797a42dcb3399062ae9546cd06f63280",
      assetPriceJob: {
        id: "740b88dd7d5347bfae116aa65a550ca9",
        oracle: "0x83F00b902cbf06E316C95F51cbEeD9D2572a349a",
      },
      alphaVantageJob: {
        id: "4f5bd067b34a45b0adae559105f3e6fc",
        oracle: "0x83F00b902cbf06E316C95F51cbEeD9D2572a349a",
      },
      apiAggregatorJob: {
        id: "becb68242def4f248faa84374d975d4a",
        oracle: "0x83F00b902cbf06E316C95F51cbEeD9D2572a349a",
      },
      wolframAlphaJob: {
        id: "bdb5a7393629426f8a944f0ccbe6442e",
        oracle: "0x83F00b902cbf06E316C95F51cbEeD9D2572a349a",
      },
      rapidApiWeather: {
        id: "73f03227e40e493f99abbc83e9b9da41",
        oracle: "0x83F00b902cbf06E316C95F51cbEeD9D2572a349a",
      }
    },
    development: {
      host: "localhost",
      port: 8545,
      network_id: "*",
      gas: 6712390,

      // Chainlink Configuration: Enter your local job ids and oracle addresses
      linkToken: "",
      assetPriceJob: {
        id: "",
        oracle: ""
      },
      alphaVantageJob: {
        id: "",
        oracle: ""
      },
      apiAggregatorJob: {
        id: "",
        oracle: ""
      },
      wolframAlphaJob: {
        id: "",
        oracle: "",
      },
      rapidApiWeather: {
        id: "",
        oracle: "",
      }
    }
  },
  solc: {
    optimizer: {
      enabled: true,
      runs: 200
    }
  }
};
