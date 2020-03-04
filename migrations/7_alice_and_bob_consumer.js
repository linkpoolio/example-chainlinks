const AliceAndBob = artifacts.require("AliceAndBob");

const config = require('../truffle.js');
const helper = require('../scripts/helper');

module.exports = async function(deployer, network, accounts) {
  let job = config.networks[helper.getNetwork(network)].httpGet;
  if (!job.oracle) return;
  return await deployer.deploy(
      AliceAndBob,
      helper.getLinkToken(network),
      job.oracle,
      web3.utils.fromAscii(job.id),
      accounts[0],
      accounts[1],
  );
};
