const AlphaVantageConsumer = artifacts.require("AlphaVantageConsumer");

module.exports = async(end) => {
    let base = process.argv[4];
    let quote = process.argv[5];

    try {
        let avc = await AlphaVantageConsumer.deployed();
        let price = await avc.prices.call(web3.utils.sha3(base + quote));
        console.log("Pair hash:", web3.utils.sha3(base + quote));
        console.log("Latest rate for", base, quote, "is", price.toNumber() / 100);
    } catch (e) {
        console.error(e);
    }

    return end()
}