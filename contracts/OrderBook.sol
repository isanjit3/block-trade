// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract OrderBook {
    struct Order {
        uint id;
        string symbol;
        uint quantity;
        uint price;
        address trader;
    }

    uint public orderCount = 0;
    mapping(uint => Order) public buyOrders;
    mapping(uint => Order) public sellOrders;

    event BuyOrderPlaced(uint id, string symbol, uint quantity, uint price, address trader);
    event SellOrderPlaced(uint id, string symbol, uint quantity, uint price, address trader);

    function placeBuyOrder(string memory symbol, uint quantity, uint price) public {
        require(bytes(symbol).length > 0, "Symbol is required");
        require(quantity > 0, "Quantity must be greater than zero");
        require(price > 0, "Price must be greater than zero");

        orderCount++;
        buyOrders[orderCount] = Order(orderCount, symbol, quantity, price, msg.sender);
        emit BuyOrderPlaced(orderCount, symbol, quantity, price, msg.sender);
    }

    function placeSellOrder(string memory symbol, uint quantity, uint price) public {
        require(bytes(symbol).length > 0, "Symbol is required");
        require(quantity > 0, "Quantity must be greater than zero");
        require(price > 0, "Price must be greater than zero");

        orderCount++;
        sellOrders[orderCount] = Order(orderCount, symbol, quantity, price, msg.sender);
        emit SellOrderPlaced(orderCount, symbol, quantity, price, msg.sender);
    }

    function getBuyOrder(uint id) public view returns (Order memory) {
        return buyOrders[id];
    }

    function getSellOrder(uint id) public view returns (Order memory) {
        return sellOrders[id];
    }
}
