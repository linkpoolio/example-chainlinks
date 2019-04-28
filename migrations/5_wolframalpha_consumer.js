const WolframAlphaConsumer = artifacts.require("WolframAlphaConsumer");

const config = require('../truffle.js');
const helper = require('../scripts/helper');

module.exports = function(deployer, network) {
  let job = config.networks[helper.getNetwork(network)].wolframAlphaJob;
  if (!job.oracle) return;
  deployer.deploy(
      WolframAlphaConsumer,
      helper.getLinkToken(network),
      job.oracle,
      web3.utils.utf8ToHex(job.id)
  );
};
