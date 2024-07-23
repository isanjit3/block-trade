// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract OrderBook {
    struct Order {
        uint id;
        string symbol;
        uint quantity;
        uint price;
        address trader;
        string user_id;
        string order_id;
    }

    uint public orderCount = 0;
    mapping(uint => Order) public buyOrders;
    mapping(uint => Order) public sellOrders;

    event BuyOrderPlaced(uint id, string symbol, uint quantity, uint price, address trader, string user_id, string order_id);
    event SellOrderPlaced(uint id, string symbol, uint quantity, uint price, address trader, string user_id, string order_id);
    event OrderMatched(uint buyOrderId, uint sellOrderId, string symbol, uint quantity, uint price, address buyer, string buyer_user_id, string buyer_order_id, address seller, string seller_user_id, string seller_order_id);

    function placeBuyOrder(string memory symbol, uint quantity, uint price, string memory user_id, string memory order_id) public {
        orderCount++;
        buyOrders[orderCount] = Order(orderCount, symbol, quantity, price, msg.sender, user_id, order_id);
        emit BuyOrderPlaced(orderCount, symbol, quantity, price, msg.sender, user_id, order_id);
        matchOrders();
    }

    function placeSellOrder(string memory symbol, uint quantity, uint price, string memory user_id, string memory order_id) public {
        orderCount++;
        sellOrders[orderCount] = Order(orderCount, symbol, quantity, price, msg.sender, user_id, order_id);
        emit SellOrderPlaced(orderCount, symbol, quantity, price, msg.sender, user_id, order_id);
        matchOrders();
    }

    function matchOrders() internal {
        for (uint i = 1; i <= orderCount; i++) {
            if (buyOrders[i].quantity > 0) {
                for (uint j = 1; j <= orderCount; j++) {
                    if (sellOrders[j].quantity > 0) {
                        if (keccak256(bytes(buyOrders[i].symbol)) == keccak256(bytes(sellOrders[j].symbol)) &&
                            buyOrders[i].price >= sellOrders[j].price) {
                            
                            uint matchQuantity = buyOrders[i].quantity < sellOrders[j].quantity ? buyOrders[i].quantity : sellOrders[j].quantity;

                            buyOrders[i].quantity -= matchQuantity;
                            sellOrders[j].quantity -= matchQuantity;

                            emit OrderMatched(
                                buyOrders[i].id, sellOrders[j].id, buyOrders[i].symbol, matchQuantity, buyOrders[i].price,
                                buyOrders[i].trader, buyOrders[i].user_id, buyOrders[i].order_id,
                                sellOrders[j].trader, sellOrders[j].user_id, sellOrders[j].order_id
                            );

                            if (buyOrders[i].quantity == 0) {
                                break;
                            }
                        }
                    }
                }
            }
        }
    }

    function getBuyOrder(uint id) public view returns (Order memory) {
        return buyOrders[id];
    }

    function getSellOrder(uint id) public view returns (Order memory) {
        return sellOrders[id];
    }
}