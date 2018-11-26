const AlphaVantageConsumer = artifacts.require("AlphaVantageConsumer");
const Web3 = require('Web3');

module.exports = async(end) => {
    let base = process.argv[4];
    let quote = process.argv[5];

    let web3 = new(Web3);
    let avc = await AlphaVantageConsumer.deployed();
    let price = await avc.prices.call(web3.sha3(base + quote));
    console.log("Pair hash: " + web3.sha3(base + quote));
    console.log("Latest price for " + base + "-" + quote + ": " + price.toNumber() / 100);

    return end()
}