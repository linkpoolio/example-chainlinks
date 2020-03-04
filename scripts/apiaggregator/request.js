const helper = require("../helper");

const APIAggregatorConsumer = artifacts.require("APIAggregatorConsumer");
const LinkToken = artifacts.require("LinkTokenInterface");

module.exports = async(callback) => {
    try {
        let network = await web3.eth.net.getNetworkType();
        let linkToken = await LinkToken.at(helper.getLinkToken(network));
        let aac = await APIAggregatorConsumer.deployed();
        console.log("Sending 1 LINK to the consumer contract...");
        await linkToken.transfer(aac.address, web3.utils.toWei("1"));
        console.log("Requesting BTCUSD Price using API Aggregator...");
        await aac.requestBTCUSDPrice();
        console.log("Done");
    } catch (e) {
        console.error(e);
    }

    return callback();
};