const AssetPriceConsumer = artifacts.require("AssetPriceConsumer");

const config = require('../truffle.js');
const helper = require('../scripts/helper');

module.exports = function(deployer, network) {
  let job = config.networks[helper.getNetwork(network)].assetPriceJob;
  if (!job.oracle) return;
  deployer.deploy(
      AssetPriceConsumer,
      helper.getLinkToken(network),
      job.oracle,
      web3.utils.utf8ToHex(job.id)
  );
};
