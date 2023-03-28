/*To build a peer-to-peer insurance platform using Solidity, you would need to write a set of smart contracts that handle the logic of policy creation,
policy management, and claims processing.*/



//Policy Creation: The first step in building a peer-to-peer insurance platform is to allow users to create and join insurance pools. To do this, you would need to create a smart contract that allows users to set their own coverage limits and premiums, 
and then automatically creates a new insurance policy when enough users have joined the pool. Here is some sample code to get started//



//Policy Management: Once the policy is created, the smart contract should manage it and enforce the terms of the policy. For example, 
it should enforce premium payments, handle policy cancellations, and enforce coverage limits//



//Claims Processing: Finally, the smart contract should handle claims processing automatically, based on the terms of the policy. 
For example, it should automatically pay out claims when triggered, and enforce the terms of the policy based on the claims made.// 


//Code Skeleton//

pragma solidity ^0.8.0;

contract InsurancePolicy {
    address[] public policyMembers;
    uint256 public coverageLimit;
    uint256 public premiumAmount;
    
    constructor(address[] memory members, uint256 limit, uint256 premium) {
        policyMembers = members;
        coverageLimit = limit;
        premiumAmount = premium;
    }
    
    function joinPolicy() public payable {
        require(msg.value == premiumAmount, "Premium amount is required to join the policy");
        policyMembers.push(msg.sender);
    }
    
    function isPolicyActive() public view returns(bool) {
        return policyMembers.length >= 2;
    }
    
    function getPayoutAmount() public view returns(uint256) {
        return address(this).balance;
    }
}


