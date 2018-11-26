var AssetPriceConsumer = artifacts.require("./AssetPriceConsumer.sol");

const config = require('../truffle.js');

module.exports = function(deployer, network) {
  deployer.deploy(
    AssetPriceConsumer, 
    config.networks[network].oracleAddress, 
    config.networks[network].jobId
  );
};
