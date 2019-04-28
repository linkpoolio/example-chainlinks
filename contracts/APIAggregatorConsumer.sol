pragma solidity ^0.4.24;

import "openzeppelin-solidity/contracts/ownership/Ownable.sol";
import "chainlink/contracts/Chainlinked.sol";

contract APIAggregatorConsumer is Chainlinked, Ownable {
    // solium-disable-next-line zeppelin/no-arithmetic-operations
    uint256 constant private ORACLE_PAYMENT = 1 * LINK;

    bytes32 public jobId;

    event RequestFulfilled(
        bytes32 indexed requestId,
        uint256 price
    );

    mapping(bytes32 => bytes32) requests;
    mapping(bytes32 => uint256) public prices;

    constructor(address _token, address _oracle, bytes32 _jobId) public {
        setLinkToken(_token);
        setOracle(_oracle);
        jobId = _jobId;
    }

    /**
        @dev Request the price of ETH using Bitstamp and Coinbase, returning a median value
        @dev Value is multiplied by 100 to include 2 decimal places
    */
    function requestETHUSDPrice() public {
        Chainlink.Request memory req = newRequest(jobId, this, this.fulfill.selector);
        string[] memory api = new string[](2);
        api[0] = "https://www.bitstamp.net/api/v2/ticker/ethusd/";
        api[1] = "https://api.pro.coinbase.com/products/eth-usd/ticker";
        req.addStringArray("api", api);
        string[] memory paths = new string[](2);
        paths[0] = "$.last";
        paths[1] = "$.price";
        req.addStringArray("paths", paths);
        req.add("aggregationType", "median");
        req.add("copyPath", "aggregateValue");
        req.addInt("times", 100);
        bytes32 requestId = chainlinkRequest(req, ORACLE_PAYMENT);
        requests[requestId] = keccak256("ETHUSD");
    }

    /**
        @dev Request the price of BTC using Bitstamp and Coinbase, returning a median value
        @dev Value is multiplied by 100 to include 2 decimal places
    */
    function requestBTCUSDPrice() public {
        Chainlink.Request memory req = newRequest(jobId, this, this.fulfill.selector);
        string[] memory api = new string[](2);
        api[0] = "https://www.bitstamp.net/api/v2/ticker/btcusd/";
        api[1] = "https://api.pro.coinbase.com/products/btc-usd/ticker";
        req.addStringArray("api", api);
        string[] memory paths = new string[](2);
        paths[0] = "$.last";
        paths[1] = "$.price";
        req.addStringArray("paths", paths);
        req.add("aggregationType", "median");
        req.add("copyPath", "aggregateValue");
        req.addInt("times", 100);
        bytes32 requestId = chainlinkRequestTo(oracleAddress(), req, ORACLE_PAYMENT);
        requests[requestId] = keccak256("BTCUSD");
    }

    function cancelRequest(
        bytes32 _requestId,
        uint256 _payment,
        bytes4 _callbackFunctionId,
        uint256 _expiration
    )
    public
    onlyOwner
    {
        cancelChainlinkRequest(_requestId, _payment, _callbackFunctionId, _expiration);
    }

    function fulfill(bytes32 _requestId, uint256 _price)
    public
    recordChainlinkFulfillment(_requestId)
    {
        emit RequestFulfilled(_requestId, _price);
        prices[requests[_requestId]] = _price;
        delete requests[_requestId];
    }

}