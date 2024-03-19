import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/widgets.dart';
import 'package:flame/flame.dart';

class Box extends SpriteComponent {
  static Vector2 initialSize = Vector2.all(150);
  static final Random _rng = Random();
  Box({super.position}) : super(size: initialSize);

  @override
  Future<void>? onLoad() async {
    int box = _rng.nextInt(2) + 1;
    final image = await Flame.images.load('./boxes/$box.png');

    sprite = Sprite(image);

    add(RectangleHitbox());
  }
}
