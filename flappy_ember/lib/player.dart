import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';

import 'game.dart';

class Player extends SpriteAnimationComponent
    with CollisionCallbacks, HasGameRef<FlappyEmber> {
  final int type;
  late var image;
  final bool isEnemy;
  final CircleHitbox hitbox = CircleHitbox(radius: 40);
  Player(this.type, this.isEnemy)
      : super(size: Vector2(100, 100), position: Vector2(100, 100));

  @override
  Future<void>? onLoad() async {
    if (!isEnemy) add(hitbox);

    switch (type) {
      case 0:
        image = await Flame.images.load('bluebird.png');
        break;
      case 1:
        image = await Flame.images.load('image_taronja.png');
        break;
      case 2:
        image = await Flame.images.load('image_verd.png');
        break;
      case 3:
        image = await Flame.images.load('image_vermell.png');
        break;
    }

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
