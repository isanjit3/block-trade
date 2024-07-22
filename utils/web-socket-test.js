const WebSocket = require('ws');

const ws = new WebSocket('ws://localhost:8545');

ws.on('open', function open() {
  console.log('connected');
  ws.send(JSON.stringify({
    "jsonrpc": "2.0",
    "method": "eth_blockNumber",
    "params": [],
    "id": 1
  }));
});

ws.on('message', function incoming(data) {
  console.log(data);
});

ws.on('error', function error(err) {
  console.error('Connection error:', err);
});

ws.on('close', function close() {
  console.log('disconnected');
});
