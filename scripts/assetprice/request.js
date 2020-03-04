const helper = require("../helper");

const AssetPriceConsumer = artifacts.require("AssetPriceConsumer");
const LinkToken = artifacts.require("LinkTokenInterface");

module.exports = async(callback) => {
    let base = process.argv[4];
    let quote = process.argv[5];

    try {
        let network = await web3.eth.net.getNetworkType();
        let linkToken = await LinkToken.at(helper.getLinkToken(network));
        let asp = await AssetPriceConsumer.deployed();
        console.log("Sending 1 LINK to the consumer contract...");
        await linkToken.transfer(asp.address, web3.utils.toWei("1"));
        console.log("Requesting price...");
        switch(quote) {
            case "USD":
                await asp.requestUSDPrice(base);
                break;
            case "EUR":
                await asp.requestEURPrice(base);
                break;
            case "BTC":
                await asp.requestSatsPrice(base);
                break;
            case "ETH":
                await asp.requestSatsPrice(base);
                break;
        }
        console.log("Done");
    } catch (e) {
        console.error(e);
    }

    return callback();
};