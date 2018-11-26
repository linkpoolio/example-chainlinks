pragma solidity ^0.4.24;

import "openzeppelin-solidity/contracts/ownership/Ownable.sol";
import "chainlink/solidity/contracts/Chainlinked.sol";

contract AssetPriceConsumer is Chainlinked, Ownable {

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

    function requestWeiPrice(string _base) public {
        requestPrice(_base, "ETH", 1 ether);
    }

    function requestSatsPrice(string _base) public {
        requestPrice(_base, "BTC", 100000000);
    }

    function requestUSDPrice(string _base) public {
        requestPrice(_base, "USD", 100);
    }

    function requestEURPrice(string _base) public {
        requestPrice(_base, "EUR", 100);
    }

    function requestPrice(string _base, string _quote, int _times) internal {
        ChainlinkLib.Run memory run = newRun(jobId, this, "fulfill(bytes32,uint256)");
        run.add("base", _base);
        run.add("quote", _quote);
        run.add("copyPath", "price");
        run.addInt("times", _times);
        bytes32 requestId = chainlinkRequest(run, LINK(1));
        requests[requestId] = keccak256(abi.encodePacked(_base, _quote));
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