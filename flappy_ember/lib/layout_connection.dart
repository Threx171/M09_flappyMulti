// connection_screen.dart
import 'dart:convert';
import 'dart:math';

import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'game.dart'; // Import the game file
import 'utils_websockets.dart';

class ConnectionScreen extends StatefulWidget {
  @override
  _ConnectionScreenState createState() => _ConnectionScreenState();
}

class _ConnectionScreenState extends State<ConnectionScreen> {
  String ipAddress = '';
  String ipPort = '';
  String username = '';
  late WebSocketsHandler websocket;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Connect to Game'),
        ),
        body: Center(
          child: Container(
            width: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(
                    labelText: 'IP Address',
                  ),
                  onChanged: (value) {
                    setState(() {
                      ipAddress = value;
                    });
                  },
                ),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'IP Port',
                  ),
                  onChanged: (value) {
                    setState(() {
                      ipPort = value;
                    });
                  },
                ),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Username',
                  ),
                  onChanged: (value) {
                    setState(() {
                      username = value;
                    });
                  },
                ),
                SizedBox(
                  height: 24,
                ),
                ElevatedButton(
                  child: Text('Connect'),
                  onPressed: () {
                    // Initialize the game
                    initializeWebSocket(ipAddress, int.parse(ipPort), username);
                    final game = FlappyEmber();
                    game.initializeGame(loadHud: true);

                    final gameWidget = GameWidget(game: game);

                    // Navigate to the game screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => gameWidget),
                    );
                  },
                ),
              ],
            ),
          ),
        ));
  }

  void initializeWebSocket(String ip, int port, String username) {
    websocket = WebSocketsHandler();
    try {
      websocket.connectToServer(ip, port, serverMessageHandler);
    } catch (e) {
      print("Error: $e");
    }
  }

  void serverMessageHandler(String message) {
    print("Message received: $message");
    // Processar els missatges rebuts
    final data = json.decode(message);

    // Comprovar si 'data' és un Map i si 'type' és igual a 'data'
    if (data is Map<String, dynamic>) {
      if (data['type'] == 'welcome') {
        initPlayer(data['id'].toString());
      }
      if (data['type'] == 'data') {
        var value = data['value'];
        if (value is List) {
          //updateOpponents(value);
        }
      }
    }
  }

  void initPlayer(String id) {
    websocket.sendMessage('{"type": "init", "name": "$username"}');
  }
}
