import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:thoth/components/kart/kart_game.dart';

class CollectibleComponent extends SpriteComponent with HasGameRef<KartGame> {
  double animationTime = 6;
  int lane;
  late final EffectController effectController;

  final farSize = Vector2(10, 10);
  final closeSize = Vector2(50, 50);

  CollectibleComponent({required this.lane});
  @override
  FutureOr<void> onLoad() async {
    final sprite = await Sprite.load("question_block.png");
    this.sprite = sprite;
    size = farSize;
    priority = 2;
    anchor = Anchor.center;
    final hitbox =
        RectangleHitbox(isSolid: true, collisionType: CollisionType.passive);
    add(hitbox);

    effectController = CurvedEffectController(animationTime, Curves.easeIn);

    final fallingEffect = MoveEffect.to(
      Vector2(game.laneX(lane), game.size.y + 1),
      effectController,
    );
    final approachingEffect = SizeEffect.to(
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
  }
}
