const AlphaVantageConsumer = artifacts.require("AlphaVantageConsumer");
const LinkToken = artifacts.require("LinkTokenInterface");

module.exports = async(end) => {
    let from = process.argv[4];
    let to = process.argv[5];

    let avc = await AlphaVantageConsumer.deployed();
    let linkToken = await LinkToken.at("0x20fe562d797a42dcb3399062ae9546cd06f63280");
    console.log("Sending LINK to Consumer...");
    await linkToken.transfer(avc.address, web3.toWei(1, 'ether'));
    console.log("Requesting exchange rate...");
    await avc.requestExchangeRate(from, to);
    console.log("Done");

    return end();
}