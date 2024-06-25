// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.2 <0.9.0;

contract MemberShip {
    mapping (address => bool) members;

    function addMember(address _member) external {
        members[_member] = true;
    }
    
    function isMember(address _member) external view returns (bool) {
        return members[_member];
    }

    function removeMember(address _member) external {
        members[_member] = false;
    }
    
}

contract MemberShipUpgrade {
    uint memberId;

    address public owner;

    struct Member {
        uint256 Id;
        string name;
        uint256 balance;
        bool membershipType;
    }

    enum MemberType { Active, NotActive }
    mapping (address => Member) public members;
    error NotAuthorized();

    constructor() { // dijalankan saat pertama kali dideploy
        owner=msg.sender;
    }

    modifier onlyOwner(){ //tidak disarankan karna terlalu mahal untuk gasnya. ini seperti middleware,
        if(owner != msg.sender) revert NotAuthorized();
        _;
    }

    function addMember(address _member, string calldata _name, uint256 _balance, MemberType _membershipType) external {
        members[_member] = Member({
            Id: ++memberId,
            name: _name,
            balance: _balance,
            membershipType: _membershipType == MemberType.Active
        });
    }

// calldata bersifat constant jika memory tidak.
    function editMember(address _member, string calldata _name, uint256 _balance, MemberType _membershipType) external {

        members[_member].name = _name;
        members[_member].balance = _balance;
        members[_member].membershipType = _membershipType == MemberType.Active;

    }

    function removeMember(address _member) external onlyOwner{
        delete members[_member];
    }
    
}