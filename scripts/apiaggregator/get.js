const APIAggregatorConsumer = artifacts.require("APIAggregatorConsumer");

module.exports = async(callback) => {
    try {
        let aac = await APIAggregatorConsumer.deployed();
        let price = await aac.prices.call(web3.utils.sha3("BTCUSD"));
        console.log("Pair hash: " + web3.utils.sha3("BTCUSD"));
        console.log("Latest price for BTC-USD: " + price.toNumber() / 100);
    } catch (e) {
        console.error(e);
    }

    return callback()
};