import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';

import 'game.dart';

class Player extends SpriteAnimationComponent
    with CollisionCallbacks, HasGameRef<FlappyEmber> {
  Player() : super(size: Vector2(100, 100), position: Vector2(100, 100));

  @override
  Future<void>? onLoad() async {
    add(CircleHitbox(radius: 40));

    final image = await Flame.images.load('bluebird.png');
    animation = SpriteAnimation.fromFrameData(
      image,
      SpriteAnimationData.sequenced(
        amount: 4,
        stepTime: 0.10,
        textureSize: Vector2.all(222),
      ),
    );
  }

  @override
  void onCollisionStart(_, __) {
    super.onCollisionStart(_, __);
    gameRef.gameover();
  }

  @override
  void update(double dt) {
    super.update(dt);

    position.y += 300 * dt;
  }

  void fly() {
    final effect = MoveByEffect(
        Vector2(0, -150),
        EffectController(
          duration: 0.5,
          curve: Curves.decelerate,
        ));

    add(effect);
  }
}
