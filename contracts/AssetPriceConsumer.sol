pragma solidity ^0.4.24;

import "openzeppelin-solidity/contracts/ownership/Ownable.sol";
import "chainlink/contracts/Chainlinked.sol";

contract AssetPriceConsumer is Chainlinked, Ownable {
    // solium-disable-next-line zeppelin/no-arithmetic-operations
    uint256 constant private ORACLE_PAYMENT = 1 * LINK;

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
        Chainlink.Request memory req = newRequest(jobId, this, this.fulfill.selector);
        req.add("base", _base);
        req.add("quote", _quote);
        req.add("copyPath", "price");
        req.addInt("times", _times);
        bytes32 requestId = chainlinkRequestTo(oracleAddress(), req, ORACLE_PAYMENT);
        requests[requestId] = keccak256(abi.encodePacked(_base, _quote));
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