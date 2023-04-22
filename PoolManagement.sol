pragma solidity ^0.8.0;
import "./UserManagement.sol";

contract PoolManagement{
	UserManagement UM = new UserManagement();

	address public operator;
	Pool[] public pools;
	uint256 lastPoolId;

	struct Pool {
		uint256 poolID;
		string insuranceType;
		uint256 minPoolMembers;
		uint256 maxPoolMembers;
		uint256 minMembershipFee;
		uint256 maxClaimAmt;
		address[] poolMemberIDs;
		bool poolStatus;
		bool poolIsRecruiting;
		uint256 poolEnrolmentPeriod;
		uint256 poolActivePeriod;
	}

	event PoolCreated (uint256 poolID, string insuranceType, uint256 minPoolMembers, uint256 maxPoolMembers, uint256 minMembershipFee, uint256 maxClaimAmt, uint256 poolEnrolmentPeriod, uint256 poolActivePeriod);
	event PoolIsActive(uint256 poolID, poolStatus);

    function createPool(string memory _insuranceType, uint256 _minPoolMembers, uint256 _maxPoolMembers, uint256 _minMembershipFee, uint256 _maxClaimAmt, uint256 _poolEnrolmentPeriod, uint256 _poolActivePeriod) public onlyOperator {
		uint256 poolId = lastPoolId;
		// Usage of memory (keyword) is to create temporary place (Analogy to RAM) to store variables/information
		// Will be cleared off once function has executed
        address[] memory members;
        Pool memory newPool = Pool({
            poolID: poolId,
            insuranceType: _insuranceType,
            minPoolMembers: _minPoolMembers,
            maxPoolMembers: _maxPoolMembers,
            minMembershipFee: _minMembershipFee,
            maxClaimAmt: _maxClaimAmt,
            poolMemberIDs: members,
            poolStatus: false,	// Start as inactive first.
            poolEnrolmentPeriod: _poolEnrolmentPeriod,
            poolActivePeriod: _poolActivePeriod
        });
        pools.push(newPool);
        emit PoolCreated(poolId, _insuranceType, _minPoolMembers, _maxPoolMembers, _minMembershipFee, _maxClaimAmt, _poolEnrolmentPeriod, _poolActivePeriod);
		lastPoolId++;
    }
	
	function pmApplicationDecision(userId) private returns (string, bool, byte){
		(userName, userStatus, userData) = UM.checkUserDetails(userId)
		// Check if user has been suspended
		require(userStatus == true, "User has been suspended") 
		// Perform pool application review process (more advanced processes)
	}
	
	function joinPool(uint poolID) public{
		require(poolIsRecruiting==true, "Pool is not accepting new members");
		require(pools[poolID].poolMemberIDs.length < pools[poolID].maxPoolMembers, "Pool is full")
		
		// Triggers the application review process which can be manual or automatic (ideally automatic)
		pmApplicationDecision(poolID, msg.sender);
		
	}
	
	function requestNewPoolPolicy() public{
		// function for none operators to request for new pool poly
	}
	
	function listPools() public view returns (Pool[]) {
	// Pool[]: returning an array of <Pool structs>
		return pools;
	}
	
	function checkPool(uint256 poolID) public view returns(Pool){
		require(poolID < lastPoolId, "No such pool")
		return pools[poolID]
	}
}