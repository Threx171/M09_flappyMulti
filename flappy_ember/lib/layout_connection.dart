// connection_screen.dart
import 'dart:convert';
import 'dart:math';

import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_data.dart';
import 'game.dart'; // Import the game file
import 'loading_menu.dart';
import 'utils_websockets.dart';

class ConnectionScreen extends StatefulWidget {
  @override
  _ConnectionScreenState createState() => _ConnectionScreenState();
}

class _ConnectionScreenState extends State<ConnectionScreen> {
  String ipAddress = '127.0.0.1';
  String ipPort = '8888';
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
                    initializeWebSocket(
                        ipAddress, int.parse(ipPort), username, context);
                  },
                ),
              ],
            ),
          ),
        ));
  }

  void initializeWebSocket(
      String ip, int port, String username, BuildContext context) {
    websocket = WebSocketsHandler();
    websocket.connectToServer(ip, port, serverMessageHandler);
    Future.delayed(Duration(seconds: 3), () {
      // Simular retraso para dar tiempo al servidor a responder
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoadingMenu(websocket)),
      );
    });
  }

  void serverMessageHandler(String message) {
    //print("Message received: $message");
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
          updateOpponents(value);
        }
      }
      if (data['type'] == 'start') {
        print("AAAAAAAAAA");
        final game = FlappyEmber();
        game.initializeGame(loadHud: true);

        final gameWidget = GameWidget(game: game);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => gameWidget),
        );
      }
    }
  }

  void updateOpponents(List value) {
    AppData appData = Provider.of<AppData>(context, listen: false); // ESTO PETA
    for (var item in value) {
      try {
        String id = item['id'];
        String nombre = item['name'];
        if (!appData.idList.contains(id)) {
          appData.idList.add(id);
          appData.nombresList.add(nombre);
        }
      } catch (e) {
        print(e);
      }
    }
  }

  void initPlayer(String id) {
    websocket.sendMessage('{"type": "init", "name": "$username"}');
  }
}
