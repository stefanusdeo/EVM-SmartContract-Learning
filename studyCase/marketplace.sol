// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.2 <0.9.0;


contract Marketplace{
    struct Item{
        uint id;
        string name;
        uint price;
        address payable seller;
        bool sold;
    }

    uint uniqueId;

    mapping(uint => Item) public items;

    mapping(uint => address payable) public owners;

    mapping(address => uint) balance;

    event FundsWithdrawn(address seller, uint amount);

    event ItemPurchased(uint id, string name, address buyer, address seller);

    event ItemListed(uint id, string name, uint price, address seller);
    
    function addItem(string memory _name, uint _price) external {
        uint _id = ++uniqueId;
        items[_id]= Item({
            id:_id,
            name:_name,
            price:_price,
            seller:payable(msg.sender),
            sold:false
        });

        owners[_id] = payable(msg.sender);

        emit ItemListed(_id, _name, _price, msg.sender);
    }

    function purchaseItem(uint _id) public payable {
        require(items[_id].sold == false, "Item is already sold");
        require(items[_id].price == msg.value, "Incorrect purchase amount");

        owners[_id] = payable(msg.sender);
        items[_id].sold = true;

        balance[items[_id].seller]+= items[_id].price;

        // items[_id].seller.transfer(msg.value);

        emit ItemPurchased(_id, items[_id].name, msg.sender, items[_id].seller);
    }

    function withdraw() public {
        address payable seller = payable(msg.sender);
        uint amount = balance[msg.sender];

        require(amount > 0, "No funds to withdraw");

        seller.transfer(amount);

        balance[msg.sender] = 0;

        emit FundsWithdrawn(seller, amount);
    }


}