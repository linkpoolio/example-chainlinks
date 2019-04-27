pragma solidity 0.4.24;

import "chainlink/contracts/Chainlinked.sol";
import "openzeppelin-solidity/contracts/ownership/Ownable.sol";

contract Consumer is Chainlinked, Ownable {
  // solium-disable-next-line zeppelin/no-arithmetic-operations
  uint256 constant private ORACLE_PAYMENT = 1 * LINK;

  bytes32 internal specId;
  bytes32 public currentPrice;

  event RequestFulfilled(
    bytes32 indexed requestId,  // User-defined ID
    bytes32 indexed price
  );

  constructor(address _oracle, bytes32 _specId) public {
    setLinkToken(0x20fE562d797A42Dcb3399062AE9546cd06f63280);
    setOracle(_oracle);
    specId = _specId;
  }

  function requestEthereumPrice(string _currency) public {
    Chainlink.Request memory req = newRequest(specId, this, this.fulfill.selector);
    req.add("url", "https://min-api.cryptocompare.com/data/price?fsym=ETH&tsyms=USD,EUR,JPY");
    string[] memory path = new string[](1);
    path[0] = _currency;
    req.addStringArray("path", path);
    chainlinkRequestTo(oracleAddress(), req, ORACLE_PAYMENT);
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

  function withdrawLink() public {
    LinkTokenInterface link = LinkTokenInterface(chainlinkToken());
    require(link.transfer(msg.sender, link.balanceOf(address(this))), "Unable to transfer");
  }

  function fulfill(bytes32 _requestId, bytes32 _price)
    public
  recordChainlinkFulfillment(_requestId)
  {
    emit RequestFulfilled(_requestId, _price);
    currentPrice = _price;
  }

}
