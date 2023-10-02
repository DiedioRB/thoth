import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:thoth/components/kart/kart_game.dart';

class CollectibleComponent extends SpriteAnimationComponent
    with HasGameRef<KartGame> {
  double animationTime = 6;
  int lane;
  late final EffectController effectController;

  final farSize = Vector2(10, 10);
  Vector2 closeSize = Vector2(50, 50);

  late MoveEffect fallingEffect;
  late SizeEffect approachingEffect;

  CollectibleComponent({required this.lane});
  @override
  FutureOr<void> onLoad() async {
    closeSize = Vector2(game.size.x * .1, game.size.x * .1);
    // final sprite = await Sprite.load("temp_item.png");
    final image = await game.images.load("item.png");
    final sheet = SpriteSheet(image: image, srcSize: Vector2(16, 16));
    SpriteAnimation animation = sheet.createAnimation(row: 0, stepTime: 0.1);
    this.animation = animation;

    // this.sprite = Sprite(image);
    size = farSize;
    priority = 2;
    anchor = Anchor.center;
    final hitbox =
        RectangleHitbox(isSolid: true, collisionType: CollisionType.passive);
    add(hitbox);

    effectController = CurvedEffectController(animationTime, Curves.easeIn);

    fallingEffect = MoveEffect.to(
      Vector2(
          game.laneX(lane) + ((lane - 2) * game.size.x * .03), game.size.y + 1),
      effectController,
    );
    approachingEffect = SizeEffect.to(
      closeSize,
      effectController,
    );
    add(fallingEffect);
    add(approachingEffect);
  }

  @override
  void update(double dt) {
    if (position.y > game.size.y) {
      removeFromParent();
      game.onScreenCollectibles.remove(this);
    }
    super.update(dt);
  }

  @override
  void onGameResize(Vector2 size) {
    if (isMounted) {
      removeFromParent();
    }
    super.onGameResize(size);
  }
}
