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
import 'boxstack.dart';
import 'fog.dart';
import 'ground.dart';
import 'sky.dart';
import 'trees.dart';
import 'utils_websockets.dart';

class FlappyEmber extends FlameGame with TapDetector, HasCollisionDetection {
  late final Player player;
  final Map<String, Player> enemies = {};
  double speed = 500;
  late Random random;
  TextComponent? scoreText;
  late WebSocketsHandler websocket;
  int score = 0;
  late BuildContext context;
  FlappyEmber(this.websocket, this.context);
  late AppData appData;
  late TextComponent countdownText;
  int countdown = 3;
  bool countdownStarted = false;

  @override
  Future<void>? onLoad() async {
    appData = Provider.of<AppData>(context, listen: false);
    random = Random(appData.seed);
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
    countdownText = TextComponent(text: '3');
    countdownText.anchor = Anchor.center;
    countdownText.x = size.x / 2;
    countdownText.y = size.y / 2;
    add(countdownText);
    startCountdown();
    return null;
  }

  void gameover() {
    websocket.sendMessage('{"type": "lost"}');
    pauseEngine();
  }

  double _timeSinceBox = 0;
  final double _boxInterval = 0.9;
  @override
  void update(double dt) {
    super.update(dt);
    if (!countdownStarted) {
      player.position.y = 50;
      appData.players.forEach((key, value) {
        if (key != appData.id) {
          enemies[key]?.position.y = 50;
        }
      });
    } else {
      speed += 10 * dt;
      _timeSinceBox += dt;

      appData.players.forEach((key, value) {
        if (key != appData.id && value['x'] != null) {
          enemies[key]?.position.x = value['x'].toDouble();
          enemies[key]?.position.y = value['y'].toDouble();
        }
      });

      if (_timeSinceBox > _boxInterval) {
        add(BoxStack(isBottom: random.nextBool(), context: context));
        appData.seed++;
        _timeSinceBox = 0;
      }
      scoreText?.text = 'Puntuación: $score';
      websocket.sendMessage(
          '{"type": "move", "x": ${player.position.x}, "y": ${player.position.y}}');
    }
  }

  void initializeGame({required bool loadHud}) {
    // Initialize websocket
    //initializeWebSocket();
  }

  @override
  void onTap() {
    if (!countdownStarted) {
      player.position.y = 50;
    } else {
      super.onTap();
      player.fly();
    }
  }

  void startCountdown() async {
    while (countdown > 0) {
      await Future.delayed(const Duration(seconds: 1));
      countdown--;
      if (countdown == 0) {
        remove(countdownText);
        initializeGame(loadHud: true);
      } else {
        countdownText.text = countdown.toString();
      }
    }
    countdownStarted = true;
  }
}
