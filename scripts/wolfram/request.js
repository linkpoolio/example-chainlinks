const WolframAlphaConsumer = artifacts.require("WolframAlphaConsumer");
const LinkToken = artifacts.require("LinkTokenInterface");

module.exports = async(end) => {
    let from = process.argv[4];
    let to = process.argv[5];

    let wa = await WolframAlphaConsumer.deployed();
    let linkToken = await LinkToken.at("0x20fe562d797a42dcb3399062ae9546cd06f63280");
    console.log("Sending LINK to Consumer...");
    await linkToken.transfer(wa.address, web3.utils.toWei("10"));
    console.log("Requesting distance from WolframAlpha Short Answers...");
    await wa.requestDistance(from, to);
    console.log("Done");

    return end();
};