const RapidAPIWeatherConsumer = artifacts.require("RapidAPIWeatherConsumer");

const config = require('../truffle.js');
const helper = require('../scripts/helper');

module.exports = function(deployer, network) {
  let job = config.networks[helper.getNetwork(network)].rapidApiWeather;
  if (!job.oracle) return;
  deployer.deploy(
      RapidAPIWeatherConsumer,
      helper.getLinkToken(network),
      job.oracle,
      web3.utils.utf8ToHex(job.id)
  );
};
