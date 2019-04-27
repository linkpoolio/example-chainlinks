pragma solidity ^0.4.24;

import "openzeppelin-solidity/contracts/ownership/Ownable.sol";
import "chainlink/contracts/Chainlinked.sol";

contract WolframAlphaConsumer is Chainlinked, Ownable {
    // solium-disable-next-line zeppelin/no-arithmetic-operations
    uint256 constant private ORACLE_PAYMENT = 1 * LINK;

    bytes32 public jobId;

    event RequestFulfilled(
        bytes32 indexed requestId,
        bytes32 indexed hash,
        int256 distance
    );

    mapping(bytes32 => bytes32) requests;
    mapping(bytes32 => int256) public distances;

    constructor(address _oracle, bytes32 _jobId) public {
        setLinkToken(0x20fE562d797A42Dcb3399062AE9546cd06f63280);
        setOracle(_oracle);
        jobId = _jobId;
    }

    function requestDistance(string _from, string _to) public {
        Chainlink.Request memory req = newRequest(jobId, this, this.fulfill.selector);
        req.add("query", string(abi.encodePacked("What's the distance between ", _from, " and ", _to, "?")));
        req.addInt("index", 1);
        req.add("copyPath", "result");
        bytes32 requestId = chainlinkRequestTo(oracleAddress(), req, ORACLE_PAYMENT);
        requests[requestId] = keccak256(abi.encodePacked(_from, _to));
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

    function fulfill(bytes32 _requestId, int256 _distance)
    public
    recordChainlinkFulfillment(_requestId)
    {
        emit RequestFulfilled(_requestId, requests[_requestId], _distance);
        distances[requests[_requestId]] = _distance;
        delete requests[_requestId];
    }

}