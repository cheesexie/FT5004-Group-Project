pragma solidity ^0.8.0;

contract UserManagement {
    struct User {
        string name;
        bool active;
        mapping(uint256 => bool) poolIds;
        mapping(uint256 => bool) claimIds;
        bytes userData; // For this part, use bytes for dynamic array (not sure what data yet)
    }

    event UserApplication(uint256 userId, string name);
    event UserApplicationDecision(uint256 userId, bool approved);
    event UserDetails(uint256 userId, string name, bool active, bytes userData);
    event UserStatusChanged(uint256 userId, bool active);

    mapping(uint256 => User) public users;
    uint256 public lastUserId;

    address public operator;

    constructor() {
        operator = msg.sender;
    }

    modifier onlyOperator() {
        require(msg.sender == operator, "Only accessible by operators");
    }

    function userApplication(string _name, bytes _userData) public {
        uint256 userId = lastUserId + 1;
        users[userId].name = _name;
        users[userId].active = false;
        users[userId].userData = _userData;
        emit UserApplication(userId, _name);
        lastUserId = userId;
    }

    function userApplicationDecision(uint256 _userId, bool _approved) public onlyOperator {
        users[_userId].active = _approved;
        emit UserApplicationDecision(_userId, _approved);
        emit UserStatusChanged(_userId, _approved);
    }

    function checkUserDetails(uint256 _userId) public view returns (string, bool, bytes) {
		return (users[_userId].name, users[_userId].active, users[_userId].userData);
    }

    function changeUserStatus(uint256 _userId, bool _active) public onlyOperator {
        users[_userId].active = _active;
        emit UserStatusChanged(_userId, _active);
    }
}