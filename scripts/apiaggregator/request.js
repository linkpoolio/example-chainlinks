const APIAggregatorConsumer = artifacts.require("APIAggregatorConsumer");
const LinkToken = artifacts.require("LinkTokenInterface");

module.exports = async(end) => {
    try {
        let aac = await APIAggregatorConsumer.deployed();
        let linkToken = await LinkToken.at("0x20fe562d797a42dcb3399062ae9546cd06f63280");
        console.log("Sending LINK to Consumer...");
        await linkToken.transfer(aac.address, web3.utils.toWei("1"));
        console.log("Requesting BTCUSD Price using API Aggregator...");
        await aac.requestBTCUSDPrice();
        console.log("Done");
    } catch (e) {
        console.error(e);
    }

    return end();
};