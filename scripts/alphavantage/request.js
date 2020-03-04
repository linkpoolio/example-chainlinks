const helper = require("../helper")
const AlphaVantageConsumer = artifacts.require("AlphaVantageConsumer");
const LinkToken = artifacts.require("LinkTokenInterface");

module.exports = async(callback) => {
    let from = process.argv[4];
    let to = process.argv[5];

    try {
        let network = await web3.eth.net.getNetworkType();
        let linkToken = await LinkToken.at(helper.getLinkToken(network));
        let avc = await AlphaVantageConsumer.deployed();
        console.log("Sending 1 LINK to the consumer contract...");
        await linkToken.transfer(avc.address, web3.utils.toWei("1"));
        console.log("Requesting exchange rate...");
        await avc.requestExchangeRate(from, to);
        console.log("Done");
    } catch (e) {
        console.error(e);
    }

    return callback();
}