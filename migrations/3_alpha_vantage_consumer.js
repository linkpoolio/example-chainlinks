var AlphaVantageConsumer = artifacts.require("./AlphaVantageConsumer.sol");

const config = require('../truffle.js');

module.exports = function(deployer, network) {
  if(config.networks[network].alphaVantageJobId) {
    deployer.deploy(
      AlphaVantageConsumer, 
      config.networks[network].oracleAddress, 
      config.networks[network].alphaVantageJobId
    );
  }
};
