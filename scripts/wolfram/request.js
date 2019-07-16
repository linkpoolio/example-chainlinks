const helper = require("../helper.js");

const WolframAlphaConsumer = artifacts.require("WolframAlphaConsumer");
const LinkToken = artifacts.require("LinkTokenInterface");

module.exports = async(callback) => {
    let from = process.argv[4];
    let to = process.argv[5];

    try {
        let network = await web3.eth.net.getNetworkType();
        let linkToken = await LinkToken.at(helper.getLinkToken(network));
        let wa = await WolframAlphaConsumer.deployed();
        console.log("Sending 1 LINK to the consumer contract...");
        await linkToken.transfer(wa.address, web3.utils.toWei("1"));
        console.log("Requesting distance from WolframAlpha Short Answers...");
        await wa.requestDistance(from, to);
        console.log("Done");
    } catch (e) {
        console.error(e);
    }

    return callback();
};
