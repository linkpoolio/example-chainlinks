const helper = require("../helper");
const AliceAndBob = artifacts.require("AliceAndBob");
const LinkToken = artifacts.require("LinkTokenInterface");

module.exports = async(callback) => {
    try {
        let accounts = await web3.eth.getAccounts();
        let network = await web3.eth.net.getNetworkType();
        let linkToken = await LinkToken.at(helper.getLinkToken(network));
        let aab = await AliceAndBob.deployed();

        console.log("Sending 2 LINK to the consumer contract...");
        await linkToken.transfer(aab.address, web3.utils.toWei("2"));

        console.log("Depositing 1 ETH into the SEO contract...");
        await web3.eth.sendTransaction({from: accounts[0], to: aab.address, value: web3.utils.toWei('1')});

        console.log("Requesting the site listing for the SEO agreement...");
        await aab.checkSiteListing({from: accounts[0]});

        console.log("Done")
    } catch (e) {
        console.error(e);
    }

    return callback();
}