module.exports = {
    getNetwork: function(network) {
        if (network === "ropsten-fork") {
            return "ropsten"
        } else {
            return network
        }
    }
};