const express = require('express')
const gameLoop = require('./utilsGameLoop.js')
const webSockets = require('./utilsWebSockets.js')
const debug = true

/*
    WebSockets server, example of messages:

    From client to server:
        - Client init           { "type": "init", "name": "name", "color": "0x000000" }
        - Player movement       { "type": "move", "x": 0, "y": 0 }

    From server to client:
        - Welcome message       { "type": "welcome", "value": "Welcome to the server", "id", "clientId" }
        
    From server to everybody (broadcast):
        - All clients data      { "type": "data", "data": "clientsData" }
*/

var ws = new webSockets()
var gLoop = new gameLoop()
let gameStart = false; 
let gameOver = false;
var colors = [0, 1, 2, 3]

// Start HTTP server
const app = express()
const port = process.env.PORT || 8888
const host = '0.0.0.0'

// Publish static files from 'public' folder
app.use(express.static('public'))

// Activate HTTP server
const httpServer = app.listen(port, host, appListen)
async function appListen() {
  console.log(`Listening for HTTP queries on: http://localhost:${port}`)
}

// Close connections when process is killed
process.on('SIGTERM', shutDown);
process.on('SIGINT', shutDown);
function shutDown() {
  console.log('Received kill signal, shutting down gracefully');
  httpServer.close()
  ws.end()
  gLoop.stop()
  process.exit(0);
}

// WebSockets
ws.init(httpServer, port)

ws.onConnection = (socket, id) => {
  if (debug) console.log("WebSocket client connected: " + id)

  // Saludem personalment al nou client
  socket.send(JSON.stringify({
    type: "welcome",
    value: "Welcome to the server",
    id: id
  }))

  // Enviem el nou client a tothom
  ws.broadcast(JSON.stringify({
    type: "newClient",
    id: id
  }))
}

ws.onMessage = (socket, id, msg) => {
  if (debug) console.log(`New message from ${id}:  ${msg.substring(0, 32)}...`)

  let clientData = ws.getClientData(id)
  if (clientData == null) return

  let obj = JSON.parse(msg)
  switch (obj.type) {
    case "init":
      if(colors.length > 0){
        clientData.name = obj.name
        clientData.color = colors[0]
        clientData.status = false
        colors.splice(0, 1);
      }
      break;
    case "move":
      clientData.x = obj.x
      clientData.y = obj.y
      break
    case "ready":
      clientData.status = !clientData.status
    case "lost":
      clientData.lost = true
  }
}

ws.onClose = (socket, id) => {
  if (debug) console.log("WebSocket client disconnected: " + id)

  // Informem a tothom que el client s'ha desconnectat
  ws.broadcast(JSON.stringify({
    type: "disconnected",
    from: "server",
    id: id
  }))
}

gLoop.init();
gLoop.run = (fps) => {
  // Aquest mètode s'intenta executar 30 cops per segon

  let clientsData = ws.getClientsData()

  // Gestionar aquí la partida, estats i final
  if(clientsData.length == 0) gameStart = false;

  if(!gameStart){
    if(clientsData.length > 0) gameStart = true;
    clientsData.forEach(function(client) {
      if(!client.status) gameStart = false;
    });
    if(gameStart){
      if(clientsData.length > 0) gameStart = true;
      clientsData.forEach(function(client) {
        client.lost = false;
      });
      ws.broadcast(JSON.stringify({ type: "start" }));
    }
  }else{
    let playersAlive = 0;
    let winnerName = "";
    clientsData.forEach(function(client) {
      if(!client.lost){
        ++playersAlive;
        winnerName = client.name;
      } 
    });
    if(playersAlive ==1 && !gameOver){
      clientsData.forEach(function(client) {
        client.status = false;
      });
      gameOver=true;
      ws.broadcast(JSON.stringify({ type: "finish", winner: winnerName }));
    }
  }
  //console.log(clientsData)

  // Send game status data to everyone
  ws.broadcast(JSON.stringify({ type: "data", value: clientsData }));
}