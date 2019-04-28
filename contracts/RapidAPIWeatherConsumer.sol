pragma solidity ^0.4.24;

import "openzeppelin-solidity/contracts/ownership/Ownable.sol";
import "chainlink/contracts/Chainlinked.sol";

/**
    @dev Rapid API Docs: https://rapidapi.com/community/api/open-weather-map
    @dev Open Weather Docs: https://openweathermap.org/current
*/
contract RapidAPIWeatherConsumer is Chainlinked, Ownable {
    // solium-disable-next-line zeppelin/no-arithmetic-operations
    uint256 constant private ORACLE_PAYMENT = 1 * LINK;

    bytes32 public jobId;

    event RequestFulfilled(
        bytes32 indexed requestId,
        bytes32 indexed hash,
        uint256 weather
    );

    mapping(bytes32 => bytes32) requests;
    mapping(bytes32 => uint256) public temps;
    mapping(bytes32 => uint256) public humidities;
    mapping(bytes32 => uint256) public windSpeeds;

    constructor(address _token, address _oracle, bytes32 _jobId) public {
        setLinkToken(_token);
        setOracle(_oracle);
        jobId = _jobId;
    }

    /**
        @dev Request the temperature in imperial units (fahrenheit)
        @param _location Enter any location as the input, for example: "London,uk", "New York,us"
    */
    function requestImperialTemp(string _location) public {
        requestWeather(_location, "imperial", "main.temp", 100, this.fulfillTemp.selector);
    }

    /**
        @dev Request the temperature in imperial units (celsius)
        @param _location Enter any location as the input, for example: "London,uk", "New York,us"
    */
    function requestMetricTemp(string _location) public {
        requestWeather(_location, "metric", "main.temp", 100, this.fulfillTemp.selector);
    }

    /**
        @dev Request the humidity percentage in a location
        @param _location Enter any location as the input, for example: "London,uk", "New York,us"
    */
    function requestHumidity(string _location) public {
        requestWeather(_location, "", "main.humidity", 1, this.fulfillHumidity.selector);
    }

    /**
        @dev Request the wind speed in a location returned in mph
        @param _location Enter any location as the input, for example: "London,uk", "New York,us"
    */
    function requestWindSpeed(string _location) public {
        requestWeather(_location, "imperial", "wind.speed", 10, this.fulfillWindSpeed.selector);
    }

    function requestWeather(
        string _location,
        string _units,
        string _path,
        int256 _times,
        bytes4 _selector
    ) internal {
        Chainlink.Request memory req = newRequest(jobId, this, _selector);
        req.add("url", "https://community-open-weather-map.p.rapidapi.com/weather");
        req.add("q", _location);
        req.add("copyPath", _path);
        req.add("units", _units);
        req.addInt("times", _times);
        bytes32 requestId = chainlinkRequest(req, ORACLE_PAYMENT);
        requests[requestId] = keccak256(abi.encodePacked(_location, _units));
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

    function fulfillTemp(bytes32 _requestId, uint256 _temp)
    public
    recordChainlinkFulfillment(_requestId)
    {
        emit RequestFulfilled(_requestId, requests[_requestId], _temp);
        temps[requests[_requestId]] = _temp;
        delete requests[_requestId];
    }

    function fulfillHumidity(bytes32 _requestId, uint256 _humidity)
    public
    recordChainlinkFulfillment(_requestId)
    {
        emit RequestFulfilled(_requestId, requests[_requestId], _humidity);
        humidities[requests[_requestId]] = _humidity;
        delete requests[_requestId];
    }

    function fulfillWindSpeed(bytes32 _requestId, uint256 _windSpeed)
    public
    recordChainlinkFulfillment(_requestId)
    {
        emit RequestFulfilled(_requestId, requests[_requestId], _windSpeed);
        windSpeeds[requests[_requestId]] = _windSpeed;
        delete requests[_requestId];
    }

}