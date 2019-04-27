const WolframAlphaConsumer = artifacts.require("WolframAlphaConsumer");

module.exports = async(end) => {
    try {
        let ph = web3.utils.soliditySha3(process.argv[4], process.argv[5]);
        let wa = await WolframAlphaConsumer.deployed();
        let distance = await wa.distances.call(ph);
        console.log("Pair hash:", ph);
        console.log("Distance between", process.argv[4], "and", process.argv[5], "is", distance.toNumber(), "miles");
    } catch (e) {
        console.error(e)
    }

    return end()
};