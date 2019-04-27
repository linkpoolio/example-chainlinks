const AssetPriceConsumer = artifacts.require("AssetPriceConsumer");

module.exports = async(end) => {
    let base = process.argv[4];
    let quote = process.argv[5];

    try {
        let asp = await AssetPriceConsumer.deployed();
        let price = await asp.prices.call(web3.utils.sha3(base + quote));
        let formattedPrice;
        switch(quote) {
            case "USD":
            case "EUR":
                formattedPrice = price.toNumber() / 100;
                break;
            case "BTC":
                formattedPrice = price.toNumber() / 100000;
                break;
            case "ETH":
                formattedPrice = web3.fromWei(price);
        }
        console.log("Pair hash: " + web3.utils.sha3(base + quote));
        console.log("Latest price for " + base + "-" + quote + ": " + formattedPrice);
    } catch (e) {
        console.log(e);
    }

    return end()
};