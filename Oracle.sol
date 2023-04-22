//example how oracle enquires a trusted API and relays the information to blockchain through use of smart contract

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Import Oracle contract
import "Oracle.sol";

contract FlightDataImport {

    // Define variables
    address public oracleAddress;
    bytes32 public flightNumber;
    uint public departureTime;
    uint public arrivalTime;

    // Define events
    event DataImported(bytes32 flightNumber, uint departureTime, uint arrivalTime);

    // Constructor
    constructor(address _oracleAddress) {
        oracleAddress = _oracleAddress;
    }

    // Import flight data from Oracle contract
    function importData() public {
        Oracle oracle = Oracle(oracleAddress);
        (flightNumber, departureTime, arrivalTime) = oracle.getFlightData();
        emit DataImported(flightNumber, departureTime, arrivalTime);
    }

    // Get flight number
    function getFlightNumber() public view returns (bytes32) {
        return flightNumber;
    }

    // Get departure time
    function getDepartureTime() public view returns (uint) {
        return departureTime;
    }

    // Get arrival time
    function getArrivalTime() public view returns (uint) {
        return arrivalTime;
    }
}