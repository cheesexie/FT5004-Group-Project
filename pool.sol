pragma solidity ^0.5.0;

contract InsurancePool {
    struct Claim {
        address member;
        uint256 amount;
        bool isApproved;
    }

    struct Pool {
        uint256 id;
        string insuranceType;
        uint256 minUsers;
        uint256 maxUsers;
        uint256 minJoiningFunds;
        uint256 maxClaimAmount;
        address[] members;
        uint256 creationTime;
        uint256 joiningPeriod;
        uint256 expiryDateTime;
        bool isActive;
        Claim[] claims;
    }

    mapping(uint256 => Pool) pools;
    mapping(uint256 => mapping(address => bool)) memberClaims;

    event ClaimSubmitted(uint256 poolId, address member, uint256 amount);
    event ClaimApproved(uint256 poolId, address member, uint256 amount);
    event ClaimRejected(uint256 poolId, address member, uint256 amount);
    event PoolExpired(uint256 poolId, uint256 expiryDateTime);

    function submitClaim(uint256 poolId, uint256 amount) public {
        Pool storage pool = pools[poolId];
        require(pool.id != 0, "Pool does not exist");
        require(pool.isActive, "Pool is not active");
        require(pool.members.length >= pool.minUsers, "Pool does not have enough members");
        require(amount <= pool.maxClaimAmount, "Claim amount exceeds maximum allowed");
        require(memberClaims[poolId][msg.sender] == false, "Already submitted a claim");

        Claim memory newClaim = Claim(msg.sender, amount, false);
        pool.claims.push(newClaim);
        memberClaims[poolId][msg.sender] = true;

        emit ClaimSubmitted(poolId, msg.sender, amount);
    }

    function approveClaim(uint256 poolId, address member, uint256 claimIndex) public {
        Pool storage pool = pools[poolId];
        require(pool.id != 0, "Pool does not exist");
        require(pool.isActive, "Pool is not active");
        require(pool.members.length >= pool.minUsers, "Pool does not have enough members");
        require(msg.sender != member, "Cannot approve own claim");

        Claim storage claim = pool.claims[claimIndex];
        require(claim.member == member, "Claim does not belong to member");
        require(!claim.isApproved, "Claim is already approved");

        claim.isApproved = true;

        emit ClaimApproved(poolId, member, claim.amount);
    }

    function rejectClaim(uint256 poolId, address member, uint256 claimIndex) public {
        Pool storage pool = pools[poolId];
        require(pool.id != 0, "Pool does not exist");
        require(pool.isActive, "Pool is not active");
        require(pool.members.length >= pool.minUsers, "Pool does not have enough members");
        require(msg.sender != member, "Cannot reject own claim");

        Claim storage claim = pool.claims[claimIndex];
        require(claim.member == member, "Claim does not belong to member");
        require(!claim.isApproved, "Claim is already approved");

        claim.isApproved = false;

        emit ClaimRejected(poolId, member, claim.amount);
    }

    function expirePool(uint256 poolId) public{
        Pool storage pool = pools[poolId];
        require(pool.id != 0, "Pool does not exist");
        require(pool.isActive, "Pool is not active");
        pool.isActive = false;
        emit PoolExpired(poolId, pool.expiryDateTime);
    }
    function getPoolInfo(uint256 poolId) public view returns (uint256, string memory, uint256, uint256, uint256, uint256, address[] memory, uint256, uint256, uint256, bool) {
    Pool storage pool = pools[poolId];
    return (
        pool.id,
        pool.insuranceType,
        pool.minUsers,
        pool.maxUsers,
        pool.minJoiningFunds,
        pool.maxClaimAmount,
        pool.members,
        pool.creationTime,
        pool.joiningPeriod,
        pool.expiryDateTime,
        pool.isActive
    );
}

function getClaimInfo(uint256 poolId, uint256 claimIndex) public view returns (address, uint256, bool) {
    Pool storage pool = pools[poolId];
    Claim storage claim = pool.claims[claimIndex];
    return (
        claim.member,
        claim.amount,
        claim.isApproved
    );
}
}

