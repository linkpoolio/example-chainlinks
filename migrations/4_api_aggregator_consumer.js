const APIAggregatorConsumer = artifacts.require("APIAggregatorConsumer");

const config = require('../truffle.js');
const helper = require('./helper');

module.exports = function(deployer, network) {
  let job = config.networks[helper.getNetwork(network)].apiAggregatorJob;
  if (job.oracle) {
    deployer.deploy(APIAggregatorConsumer, job.oracle, web3.utils.utf8ToHex(job.id));
  }
};
