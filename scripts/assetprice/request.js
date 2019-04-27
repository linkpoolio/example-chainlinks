const AssetPriceConsumer = artifacts.require("AssetPriceConsumer");
const LinkToken = artifacts.require("LinkTokenInterface");

module.exports = async(end) => {
    let base = process.argv[4];
    let quote = process.argv[5];

    try {
        let asp = await AssetPriceConsumer.deployed();
        let linkToken = await LinkToken.at("0x20fe562d797a42dcb3399062ae9546cd06f63280");
        console.log("Sending LINK to Consumer...");
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

    return end();
};