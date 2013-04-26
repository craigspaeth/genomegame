var app = require('express')();
var server = require('http').Server(app);
var io = require('socket.io')(server);
io.on('connection', console.log);
server.listen(3000);