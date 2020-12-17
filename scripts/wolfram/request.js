const helper = require("../helper.js");

const WolframAlphaConsumer = artifacts.require("WolframAlphaConsumer");
const LinkToken = artifacts.require("LinkTokenInterface");

module.exports = async (callback) => {
  let query = process.argv[4];
  let index = process.argv[5];

  try {
    let network = await web3.eth.net.getNetworkType();
    let linkToken = await LinkToken.at(helper.getLinkToken(network));
    let wa = await WolframAlphaConsumer.deployed();
    console.log("Sending 1 LINK to the consumer contract...");
    await linkToken.transfer(wa.address, web3.utils.toWei("1"));
    console.log("Requesting answer from WolframAlpha Short Answers...");
    await wa.requestAnswer(query, index);
    console.log("Done");
  } catch (e) {
    console.error(e);
  }

  return callback();
};
