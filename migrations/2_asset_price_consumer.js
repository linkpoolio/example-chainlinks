const AssetPriceConsumer = artifacts.require("AssetPriceConsumer");

const config = require('../truffle.js');
const helper = require('./helper');

module.exports = function(deployer, network) {
  let job = config.networks[helper.getNetwork(network)].assetPriceJob;
  if (job.oracle) {
    deployer.deploy(AssetPriceConsumer, job.oracle, web3.utils.utf8ToHex(job.id));
  }
};
