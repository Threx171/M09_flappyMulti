import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/widgets.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_data.dart';
import 'game.dart';
import 'box.dart';

class BoxStack extends PositionComponent with HasGameRef<FlappyEmber> {
  final bool isBottom;
  late Random random;
  late BuildContext context;

  BoxStack({required this.isBottom, required this.context});

  @override
  Future<void>? onLoad() async {
    AppData appData = Provider.of<AppData>(context, listen: false);
    random = Random(appData.seed);
    position.x = gameRef.size.x;
    final gameHeight = gameRef.size.y;
    final boxHeight = Box.initialSize.y;
    final maxStackHeight = (gameHeight / boxHeight).floor();

    final stackHeight = random.nextInt(maxStackHeight + 1);
    final boxSpacing = boxHeight * (2 / 3);
    final initialY = isBottom ? gameHeight - boxHeight : -boxHeight / 3;

    final boxs = List.generate(stackHeight, (index) {
      return Box(
        position:
            Vector2(0, initialY + index * boxSpacing * (isBottom ? -1 : 1)),
      );
    });
    addAll(isBottom ? boxs : boxs.reversed);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (position.x < -Box.initialSize.x) {
      gameRef.score += 100;
      removeFromParent();
    }
    position.x -= gameRef.speed * dt;
  }
}
