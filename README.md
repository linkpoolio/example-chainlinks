# Example Chainlinks

Example Chainlinks that get data from various sources. Already deployed to Ropsten, you can run the included scripts to easily fetch data on-chain via Chainlink.

### Current examples:

- **AlphaVantage** ([Bridges URL](https://s3.linkpool.io/bridges/alphavantage.json))**:** Forex rates
- **[API Aggregator](https://github.com/linkpoolio/bridges/tree/master/examples/apiaggregator)**: Aggregate values from
  multiple APIs for ETH & BTC.
- **[Asset Price](https://github.com/linkpoolio/asset-price-cl-ea):** Specify any crypto pair and get a price aggregated by weighted volume from all supported exchanges
  that list a pair. Eg: BTC-USD, LINK-BTC, ETH-USDT, ADA-BTC.
- **[Wolfram Alpha](https://github.com/linkpoolio/bridges/tree/master/examples/wolframalpha):** Find the distance between
  two locations in miles using the Short Answers API and natural language.
- **Rapid API (Weather)** ([Bridges URL](https://s3.linkpool.io/bridges/rapidapi.json))**:** Get the temperature,
  humidity and windspeeds at any global location.

## Install

Install dependencies with yarn/npm.

## General Usage

To first use this on Ropsten, you can update `truffle.js` with your private key and RPC host for deployment.
This could be Infura or your own node for example.

**This repository includes the ropsten contract `build` files, so once you set up `truffle.js` you can use the scripts
on the Ropsten network.**

You can also deploy this locally using `ganache-cli`, but you need to deploy the `Oracle.sol` contract for
your Chainlink node and create a new job spec as per the example you want to use in `specs`.

### Setup

In `truffle.js` enter your mnemonic and Ethereum URL, eg Infura.

### Deployment

To deploy, run a standard Truffle migration (uses Truffle from local deps):

```
npm run migrate
```

### Requesting Data

#### Alpha Vantage

Request the current rate of the pound to the dollar:

```
npm run exec scripts/alphavantage/request.js -- GBP USD --network ropsten
npm run exec scripts/alphavantage/get.js -- GBP USD --network ropsten
```

#### API Aggregator

Request the current price of BTC aggregated from Coinbase & Bitstamp:

```
npm run exec scripts/apiaggregator/request.js -- --network ropsten
npm run exec scripts/apiaggregator/get.js -- --network ropsten
```

#### Asset Price

Request the price of BTC-USD aggregated from many exchanges:

```
npm run exec scripts/assetprice/request.js BTC USD -- --network ropsten
npm run exec scripts/assetprice/get.js BTC USD -- --network ropsten
```

LINK-BTC:

```
npm run exec scripts/assetprice/request.js LINK BTC -- --network ropsten
npm run exec scripts/assetprice/get.js LINK BTC -- --network ropsten
```

#### WolframAlpha (Short Answers API)

Request a numerical answer to any question (ex. distance between London and Tokyo):

```
npm run exec scripts/wolfram/request.js "What's the distance between London and Tokyo?" 1 -- --network ropsten
npm run exec scripts/wolfram/get.js "What's the distance between London and Tokyo?" -- --network ropsten
```

#### Rapid API Weather (OpenWeatherMap)

Request the temperature in Celsius:

```
npm run exec scripts/rapidapiweather/request.js metricTemp London,uk -- --network ropsten
npm run exec scripts/rapidapiweather/get.js metricTemp London,uk -- --network ropsten
```

Request the humidity percentage:

```
npm run exec scripts/rapidapiweather/request.js humidity London,uk -- --network ropsten
npm run exec scripts/rapidapiweather/get.js humidity London,uk -- --network ropsten
```

Request the windspeed in mph:

```
npm run exec scripts/rapidapiweather/request.js windSpeed London,uk -- --network ropsten
npm run exec scripts/rapidapiweather/get.js windSpeed London,uk -- --network ropsten
```

## Notes

The `truffle.js` ropsten network is configured to point to a [LinkPool](https://linkpool.io) node.
You don't need to change the configuration as our node will accept requests from your contract with no changes.

Although, you can edit the `jobId` and `oracleAddress` as specified in the Truffle configuration to point to
your own node.
