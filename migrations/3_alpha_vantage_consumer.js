const AlphaVantageConsumer = artifacts.require("AlphaVantageConsumer");

const config = require('../truffle.js');
const helper = require('./helper');

module.exports = function(deployer, network) {
  let job = config.networks[helper.getNetwork(network)].alphaVantageJob;
  if (job.oracle) {
    deployer.deploy(AlphaVantageConsumer, job.oracle, web3.utils.utf8ToHex(job.id));
  }
};
