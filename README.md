# example-chainlinks
Some example chainlinks that can be deployed for a variety of types of external data.

## Install

Yarn:
```
yarn install
```

NPM:
```
npm install
```

## General Usage

To first use this on Ropsten, you can update `truffle.js` with your private key and RPC host for deployment. 
This could be Infura or your own node for example.

In `truffle.js` from line 8:
```js
let wallet = new HDWalletProvider(
    [""], // Private Key (Use a seperate deployment wallet)
    "" // RPC Host (Infura, your own etc)
);
```

You can also deploy this locally using `ganache-cli`, but you need to deploy the `Oracle.sol` contract for 
your Chainlink node and create a new job spec as per the example you want to use in `specs`.

### Deployment

To deploy, run a standard Truffle migration (uses Truffle from local deps):
```
npm run migrate
```

### Requesting Data

To then use the deployed contracts, you can run the scripts found in `scripts`.

For the `AssetPriceConsumer.sol` example:

**Requesting Data**
```
npm run exec scripts/request_asset_price.js -- BTC USD --network ropsten
```
Expected Outcome:
```
Using network 'ropsten'.

Sending LINK to Consumer...
Requesting price...
Done
```

**Fetching Data**
```
npm run exec scripts/get_asset_price.js -- BTC USD --network ropsten
```
Expected Outcome (bar price volatility):
```
Using network 'ropsten'.

Pair hash: 0x7404e3d104ea7841c3d9e6fd20adfe99b4ad586bc08d8f3bd3afef894cf184de
Latest price for BTC-USD: 3967.56
```

## Notes
The `truffle.js` ropsten network is specifically configured to point to a [LinkPool](https://linkpool.io) node. 
You don't need to change the configuration as our node will accept requests from your contract with no changes. 

Although, you can edit the `jobId` and `oracleAddress` as specified in the Truffle configuration to point to 
your own node.
