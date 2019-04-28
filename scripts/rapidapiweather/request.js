const helper = require("../helper");

const RapidAPIWeatherConsumer = artifacts.require("RapidAPIWeatherConsumer");
const LinkToken = artifacts.require("LinkTokenInterface");

module.exports = async(callback) => {
    let funcName = process.argv[4];
    let location = process.argv[5];

    try {
        let network = await web3.eth.net.getNetworkType();
        let linkToken = await LinkToken.at(helper.getLinkToken(network));
        let rw = await RapidAPIWeatherConsumer.deployed();
        console.log("Sending 1 LINK to the consumer contract...");
        await linkToken.transfer(rw.address, web3.utils.toWei("10"));
        console.log("Requesting the weather from RapidAPI Open Weather...");
        switch (funcName) {
            case "imperialTemp":
                await rw.requestImperialTemp(location);
                break;
            case "metricTemp":
                await rw.requestMetricTemp(location);
                break;
            case "humidity":
                await rw.requestHumidity(location);
                break;
            case "windSpeed":
                await rw.requestWindSpeed(location);
                break;
        }
        console.log("Done");
    } catch (e) {
        console.error(e);
    }

    return callback();
};