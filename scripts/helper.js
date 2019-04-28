const config = require('../truffle.js');

module.exports = {
    getNetwork: function(network) {
        if (network === "ropsten-fork") {
            return "ropsten"
        } else {
            return network
        }
    },
    getLinkToken: function(network) {
        return config.networks[this.getNetwork(network)].linkToken;
    }
};