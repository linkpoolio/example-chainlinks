pragma solidity ^0.4.24;

import "openzeppelin-solidity/contracts/ownership/Ownable.sol";
import "chainlink/contracts/Chainlinked.sol";

/**
    @dev WolframAlpha Short Answers API Docs: https://products.wolframalpha.com/short-answers-api/documentation/
*/
contract WolframAlphaConsumer is Chainlinked, Ownable {
    // solium-disable-next-line zeppelin/no-arithmetic-operations
    uint256 constant private ORACLE_PAYMENT = 1 * LINK;
    string constant public BASE_URL = "https://www.wolframalpha.com/input/?i=";

    bytes32 public jobId;

    event RequestFulfilled(
        bytes32 indexed requestId,
        bytes32 indexed hash,
        int256 answer
    );

    event WolframAlphaQuery(
        string url
    );

    mapping(bytes32 => bytes32) requests;
    mapping(bytes32 => int256) public answers;

    constructor(address _token, address _oracle, bytes32 _jobId) public {
        setLinkToken(_token);
        setOracle(_oracle);
        jobId = _jobId;
    }

    /**
        @dev Request an answer to a query
        @param _query query to request answer for
    */
    function requestAnswer(string _query, uint8 _index) public {
        Chainlink.Request memory req = newRequest(jobId, this, this.fulfill.selector);
        req.add("query", _query);
        req.addInt("index", _index);
        req.add("copyPath", "result");
        bytes32 requestId = chainlinkRequest(req, ORACLE_PAYMENT);
        requests[requestId] = keccak256(abi.encodePacked(_query));

        emit WolframAlphaQuery(string(abi.encodePacked(BASE_URL, formatUrl(_query))));
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

    function fulfill(bytes32 _requestId, int256 _answer)
    public
    recordChainlinkFulfillment(_requestId)
    {
        emit RequestFulfilled(_requestId, requests[_requestId], _answer);
        answers[requests[_requestId]] = _answer;
        delete requests[_requestId];
    }

    function formatUrl(string _url) private pure returns (string){
      bytes memory urlBytes = bytes(_url);
      bytes memory formatted = new bytes(urlBytes.length);
      for(uint i = 0; i < urlBytes.length; i++) {
        if (urlBytes[i] == " ") {
          formatted[i] = "+";
        } else {
          formatted[i] = urlBytes[i];
        }
      }
      return string(formatted);
    }

}
