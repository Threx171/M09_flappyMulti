import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flappy_ember/player.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_data.dart';
import 'utils_websockets.dart';

import 'ground.dart';
import 'sky.dart';
import 'trees.dart';
import 'fog.dart';
import 'boxstack.dart';

class FlappyEmber extends FlameGame with TapDetector, HasCollisionDetection {
  late final Player player;
  final Map<String, Player> enemies = {};
  double speed = 500;
  final random = Random();
  TextComponent? scoreText;
  late WebSocketsHandler websocket;
  int score = 0;
  late BuildContext context;
  FlappyEmber(this.websocket, this.context);
  late AppData appData;

  @override
  Future<void>? onLoad() async {
    appData = Provider.of<AppData>(context, listen: false);
    player = Player(appData.players[appData.id]?["color"], false);
    appData.players.forEach((key, value) {
      if (key != appData.id) {
        enemies[key] = Player(value['color'], true);
      }
    });
    appData.players.forEach((key, value) {
      if (key != appData.id) {
        add(enemies[key]!);
      }
    });
    add(Sky());
    add(Ground());
    add(Fog());
    add(ScreenHitbox());
    add(player);
    scoreText = TextComponent(text: 'Score: $score');
    scoreText!.anchor = Anchor.topLeft;
    scoreText!.x = 10.0;
    scoreText!.y = 10.0;
    add(scoreText!);
    return null;
  }

  void gameover() {
    websocket.sendMessage('{"type": "lost"}');
    pauseEngine();
  }

  double _timeSinceBox = 0;
  double _boxInterval = 0.9;
  @override
  void update(double dt) {
    super.update(dt);
    speed += 10 * dt;
    _timeSinceBox += dt;

    appData.players.forEach((key, value) {
      if (key != appData.id && value['x'] != null) {
        enemies[key]?.position.x = value['x'].toDouble();
        enemies[key]?.position.y = value['y'].toDouble();
        // enemies[key]?.position.x = double.parse(value['x'].toString());
        // enemies[key]?.position.y = double.parse(value['y'].toString());
      }
    });

    if (_timeSinceBox > _boxInterval) {
      add(BoxStack(isBottom: random.nextBool()));
      _timeSinceBox = 0;
    }
    scoreText?.text = 'Puntuación: $score';
    websocket.sendMessage(
        '{"type": "move", "x": ${player.position.x}, "y": ${player.position.y}}');
  }

  void initializeGame({required bool loadHud}) {
    // Initialize websocket
    //initializeWebSocket();
  }

  @override
  void onTap() {
    super.onTap();
    player.fly();
  }
}
