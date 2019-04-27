const Oracle = artifacts.require("Oracle");

module.exports = async(end) => {
    try {
        console.log("Deploying Oracle.sol");
        let oc = await Oracle.new(process.argv[4]);
        await oc.setFulfillmentPermission(process.argv[5], true);
        console.log("Oracle Address:", oc.address);
    } catch (e) {
        console.error(e);
    }

    return end();
}