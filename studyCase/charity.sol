// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.2 <0.9.0;

contract CharityContract {
    address owner;
    address charity;

    constructor(address payable _charity) {
        owner=msg.sender;
        charity=_charity;
    }

    error invalidAmount(uint amount, uint balance);

    receive() external payable {}

    function tip() external payable{ 
        if (msg.value > 0) {
            (bool success, ) = owner.call{value: msg.value}("");
            require(success, "Failed send eth to owner");
        }else{
            revert invalidAmount(msg.value, msg.sender.balance);
        }
    }

    function donate()external payable  {
        if (msg.value > 0) {
            (bool success, ) = charity.call{value:msg.value}("");
            require(success, "Failed send charity");
        }else{
            revert invalidAmount(msg.value, msg.sender.balance);
        }
    }
}