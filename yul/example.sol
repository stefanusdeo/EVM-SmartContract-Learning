// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract YulExample {
    uint private data;

    function setData(uint _data) public {
        assembly {
            let ptr := mload(0x40)
            mstore(ptr, _data)

            sstore(data.slot, mload(ptr))
        }
    }

    function getX() public view returns (uint) {
        uint value;
        assembly {
            value := sload(data.slot)
        }
        return value;
    }
}

contract optimizeYul {
    function setData(uint _data) public {
        assembly {
            sstore(0, _data)
        }
    }

    function getX() public view returns (uint result) {
        assembly {
            result := sload(0)
        }
    }
}