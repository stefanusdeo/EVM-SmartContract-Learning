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