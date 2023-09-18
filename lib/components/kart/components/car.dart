import 'dart:async';
import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';
import 'package:thoth/components/kart/components/collectible.dart';
import 'package:thoth/components/kart/kart_game.dart';

class CarComponent extends SpriteComponent
    with CollisionCallbacks, HasGameRef<KartGame> {
  int points = 0;
  late int lane;

  @override
  FutureOr<void> onLoad() async {
    final sprite = await Sprite.load("car.png");
    size = Vector2(100, 80);
    priority = 5;
    this.sprite = sprite;
    anchor = Anchor.center;

    final hitbox = RectangleHitbox.relative(Vector2(1, 0.3),
        parentSize: size, isSolid: true);
    add(hitbox);

    lane = game.totalLanes ~/ 2;
  }

  void move(lane) {
    add(MoveEffect.to(Vector2(game.laneX(lane), game.size.y - 100),
        EffectController(duration: 0.1)));
  }

  void moveLeft() {
    if (lane > 0) {
      lane--;
      move(lane);
    }
  }

  void moveRight() {
    if (lane < game.totalLanes - 1) {
      lane++;
      move(lane);
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is CollectibleComponent) {
      if (other.lane == lane) {
        game.explodeParticles(other.position);
        other.removeFromParent();
        points++;
      }
    }
    super.onCollision(intersectionPoints, other);
  }
}
