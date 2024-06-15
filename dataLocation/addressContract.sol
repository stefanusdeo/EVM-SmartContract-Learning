// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

//lokasi data

//storage (gas lebih besar)
//memory(gas lebih kecil)

//calldata
//stack

contract Location{

// type values
    function iniFungsi()public pure returns(uint) {
        uint localVar = 20;
        uint stateVar = 30;

        localVar = stateVar;
        stateVar = 40;

        return stateVar;
    }

// refType
    function iniFungsi2()public pure returns(uint[] memory, uint[] memory) {
        uint[] memory localMemoryArr1 = new uint[](3);

        localMemoryArr1[0]=1;
        localMemoryArr1[1]=2;
        localMemoryArr1[2]=3;

// shadow clone
        uint[] memory localMemoryArr2 = localMemoryArr1;
        localMemoryArr1[0]=4;

        return(localMemoryArr1, localMemoryArr2);
    }
}