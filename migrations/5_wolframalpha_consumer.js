const WolframAlphaConsumer = artifacts.require("WolframAlphaConsumer");

const config = require('../truffle.js');
const helper = require('./helper');

module.exports = function(deployer, network) {
  let job = config.networks[helper.getNetwork(network)].wolframAlphaJob;
  if (job.oracle) {
    deployer.deploy(WolframAlphaConsumer, job.oracle, web3.utils.utf8ToHex(job.id));
  }
};
