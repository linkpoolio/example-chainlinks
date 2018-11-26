pragma solidity ^0.4.24;

import "openzeppelin-solidity/contracts/ownership/Ownable.sol";
import "chainlink/solidity/contracts/Chainlinked.sol";

contract AlphaVantageConsumer is Chainlinked, Ownable {

    bytes32 public jobId;

    event RequestFulfilled(
        bytes32 indexed requestId,
        uint256 price
    );

    mapping(bytes32 => bytes32) requests;
    mapping(bytes32 => uint256) public prices;

    constructor(address _oracle, bytes32 _jobId) public {
        setLinkToken(0x20fE562d797A42Dcb3399062AE9546cd06f63280);
        setOracle(_oracle);
        jobId = _jobId;
    }

    /**
        @dev Request a currency exchange rate
        @dev This includes Forex and Cryptocurrencies
        @param _from The currency you want to use as the base
        @param _to The currency to get in quote
     */
    function requestExchangeRate(string _from, string _to) public {
        ChainlinkLib.Run memory run = newRun(jobId, this, "fulfill(bytes32,uint256)");
        run.add("function", "CURRENCY_EXCHANGE_RATE");
        run.add("from_currency", _from);
        run.add("to_currency", _to);
        string[] memory path = new string[](2);
        path[0] = "Realtime Currency Exchange Rate";
        path[1] = "5. Exchange Rate";
        run.addStringArray("copyPath", path);
        run.addInt("times", 100);
        bytes32 requestId = chainlinkRequest(run, LINK(1));
        requests[requestId] = keccak256(abi.encodePacked(_from, _to));
    }

    function cancelRequest(bytes32 _requestId) public onlyOwner {
        cancelChainlinkRequest(_requestId);
    }

    function fulfill(bytes32 _requestId, uint256 _price)
    public
    checkChainlinkFulfillment(_requestId)
    {
        emit RequestFulfilled(_requestId, _price);
        prices[requests[_requestId]] = _price;
        delete requests[_requestId];
    }

}