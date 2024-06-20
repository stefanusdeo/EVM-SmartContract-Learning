// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Exercise2 {
    struct Box{
        uint width;
        uint length;
        uint height;
    }

    Box[] boxes;


    function addBox(uint _width, uint _length, uint _height) public {
        Box memory newBox = Box({ width: _width, length: _length, height: _height });

        boxes.push(newBox);

    }

    function getBoxAtIndex(uint index) public view returns (uint, uint, uint) {

        Box memory box = boxes[index];
        return (box.width, box.length, box.height);
    }
}