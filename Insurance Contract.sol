pragma solidity ^0.8.0;

//"SPDX-License-Identifier: UNLICENSED"

contract DynamisInsurance {
    uint256 premium;
    uint256 payout;
    address payable insured;
    address payable insurer;
    uint256 expiration;

    constructor(uint _premium, uint _payout, address payable _insured, address payable _insurer, uint _expiration) {
        premium = _premium;
        payout = _payout;
        insured = _insured;
        insurer = _insurer;
        expiration = _expiration;
    }

    function payPremium() external payable {
        require(msg.value == premium, "Incorrect premium amount");
    }

    function fileClaim() external {
        require(block.timestamp <= expiration, "Policy has expired");
        require(msg.sender == insured, "Only the insured can file a claim");
        insured.transfer(payout);
    }

    function cancelPolicy() external {
        require(msg.sender == insurer || msg.sender == insured, "Only the insurer or insured can cancel the policy");
        selfdestruct(insurer);
    }
}