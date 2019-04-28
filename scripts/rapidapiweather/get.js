const RapidAPIWeatherConsumer = artifacts.require("RapidAPIWeatherConsumer");

module.exports = async(callback) => {
    let funcName = process.argv[4];
    let location = process.argv[5];

    try {
        let rw = await RapidAPIWeatherConsumer.deployed();
        switch (funcName) {
            case "imperialTemp":
                let it = await rw.temps.call(web3.utils.soliditySha3(location, "imperial"));
                console.log("Temperature in", location, "is", it.toNumber() / 100, "F");
                return callback();
            case "metricTemp":
                let mt = await rw.temps.call(web3.utils.soliditySha3(location, "metric"));
                console.log("Temperature in", location, "is", mt.toNumber() / 100, "C");
                return callback();
            case "humidity":
                let h = await rw.humidities.call(web3.utils.soliditySha3(location));
                console.log("Humidity in", location, "is", h.toNumber(), "%");
                return callback();
            case "windSpeed":
                let ws = await rw.windSpeeds.call(web3.utils.soliditySha3(location, "imperial"));
                console.log("Windspeed in", location, "is", ws.toNumber() / 10, "mph");
                return callback();
        }
    } catch (e) {
        console.error(e);
    }
};