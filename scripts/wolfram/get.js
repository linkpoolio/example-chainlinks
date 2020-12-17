const WolframAlphaConsumer = artifacts.require("WolframAlphaConsumer");

module.exports = async (callback) => {
  try {
    let qh = web3.utils.soliditySha3(process.argv[4]);
    let wa = await WolframAlphaConsumer.deployed();
    let answer = await wa.answers(qh);
    console.log("Query hash:", qh);
    console.log(process.argv[4], " => ", answer.toNumber());
  } catch (e) {
    console.error(e);
  }

  return callback();
};
