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
    uint memberId =1;
    struct Member {
        uint256 Id;
        string name;
        uint256 balance;
        bool membershipType;
    }

    enum memberType { Active, NotActive }
    mapping (address => Member) members;

    function addMember(address _member, string memory _name, uint256 _balance, memberType _membershipType) external {
        memberId++; 

        members[_member] = Member({
            Id: memberId,
            name: _name,
            balance: _balance,
            membershipType: _membershipType == memberType.Active
        });
    }
    
    function isMember(address _member) external view returns (bool) {
        return members[_member].Id != 0;
    }

    function removeMember(address _member) external {
        delete members[_member];
    }
    
}