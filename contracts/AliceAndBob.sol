pragma solidity ^0.4.24;

import "openzeppelin-solidity/contracts/ownership/Ownable.sol";
import "chainlink/contracts/Chainlinked.sol";

contract AliceAndBob is Chainlinked, Ownable {
    using SafeMath for uint256;
    uint256 constant private ORACLE_PAYMENT = 1 * LINK; // solium-disable-line zeppelin/no-arithmetic-operations

    address public aliceAddress;
    address public bobAddress;
    bytes32 public jobId;

    uint256 constant ESCROW_AMOUNT_USD = 50;

    event DepositMade(uint256 amount);
    event RankingReturned(uint256 rank);

    constructor(
        address _token,
        address _oracle,
        bytes32 _jobId,
        address _alice,
        address _bob
    ) Ownable() public {
        setLinkToken(_token);
        setOracle(_oracle);
        jobId = _jobId;
        aliceAddress = _alice;
        bobAddress = _bob;
    }

    function()
    external
    payable
    onlyDepositor
    {
        emit DepositMade(msg.value);
    }

    function checkSiteListing() public {
        Chainlink.Request memory req = newRequest(jobId, this, this.fulfillRanking.selector);
        req.add("url", "https://pastebin.com/raw/NPXL33mj");
        req.add("path", "ranking");
        chainlinkRequest(req, ORACLE_PAYMENT);
    }

    function fulfillRanking(bytes32 _requestId, uint256 _ranking)
    public
    recordChainlinkFulfillment(_requestId)
    {
        emit RankingReturned(_ranking);
        if (_ranking < 10) {
            requestEthereumPrice();
        }
    }

    function requestEthereumPrice()
    internal
    {
        Chainlink.Request memory req = newRequest(jobId, this, this.fulfillEthereumPrice.selector);
        req.add("url", "https://min-api.cryptocompare.com/data/price?fsym=ETH&tsyms=USD,EUR,JPY");
        req.add("path", "EUR");
        req.addInt("times", 100);
        chainlinkRequest(req, ORACLE_PAYMENT);
    }

    function fulfillEthereumPrice(bytes32 _requestId, uint256 _price)
    public
    recordChainlinkFulfillment(_requestId)
    {
        uint256 transferAmount = ESCROW_AMOUNT_USD.mul(10**20).div(_price);
        if (transferAmount <= address(this).balance) {
            bobAddress.transfer(transferAmount);
            selfdestruct(aliceAddress);
        }
    }

    function getChainlinkToken() public view returns (address) {
        return chainlinkToken();
    }

    function getOracle() public view returns (address) {
        return oracleAddress();
    }

    function withdrawLink() public onlyOwner {
        LinkTokenInterface link = LinkTokenInterface(chainlinkToken());
        require(link.transfer(msg.sender, link.balanceOf(address(this))), "Unable to transfer");
    }

    modifier onlyDepositor() {
        require(msg.sender == aliceAddress, "Only the depositor may call this function.");
        _;
    }

}