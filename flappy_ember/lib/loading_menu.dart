import 'dart:convert';
import 'dart:io';

import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_data.dart';
import 'game.dart';
import 'utils_websockets.dart';

class LoadingMenu extends StatefulWidget {
  late WebSocketsHandler websocket;

  LoadingMenu(this.websocket);

  @override
  _LoadingMenuState createState() => _LoadingMenuState(websocket);
}

class _LoadingMenuState extends State<LoadingMenu> {
  late WebSocketsHandler websocket;

  _LoadingMenuState(this.websocket);

  @override
  Widget build(BuildContext context) {
    AppData appData = Provider.of<AppData>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Jugadores'),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 100,
            child: ListView.builder(
              itemCount: appData.nombresList.length,
              itemBuilder: (context, index) {
                return Container(
                  child: Column(
                    children: [
                      PlayerListItem(name: appData.nombresList[index]),
                    ],
                  ),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              websocket.sendMessage('{"type": "ready"}');
            },
            child: Text('PLAY'),
          ),
        ],
      )),
    );
  }
}

class PlayerListItem extends StatelessWidget {
  final String name;

  PlayerListItem({required this.name});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(name),
    );
  }
}

class Player {
  final String name;
  final String position;

  Player({required this.name, required this.position});
}
