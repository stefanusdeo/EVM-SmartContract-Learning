// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AddressContract{
    // address public caller;

    // function getCallerAddress()public returns(address) {
    //     caller = msg.sender;

    //     return caller;
    // }

    // function anotherGetCallerAddress()public view returns(address caller) {
    //     caller = msg.sender;
    // }

    uint receivedAmount;

    function getAddress()public view returns(address) {
        address myAddress = address(this);
        return myAddress;
    }

    // address payable
    function receiveEther()payable public {
        receivedAmount = msg.value;
    }

    function transferFund(address payable _address, uint nominal)public {
        _address.transfer(nominal);
    }

    function sendFund(address payable _address, uint nominal) public returns(bool) {
        _address.send(nominal);
    }
}