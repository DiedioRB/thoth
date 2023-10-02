import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:thoth/components/kart/components/collectible.dart';
import 'package:thoth/components/kart/kart_game.dart';

class CarComponent extends SpriteComponent
    with CollisionCallbacks, HasGameRef<KartGame> {
  int points = 0;
  late int lane;
  late MoveEffect shake;
  double factor = 1;

  @override
  FutureOr<void> onLoad() async {
    final sprite = await Sprite.load("carro.png");
    size = Vector2(1, 1);
    factor = game.size.x * .07;
    scale = Vector2(2 * factor, 1 * factor);
    priority = 5;
    this.sprite = sprite;
    anchor = Anchor.center;

    final hitbox = RectangleHitbox.relative(Vector2(1, 0.3),
        parentSize: size, isSolid: true);
    add(hitbox);

    lane = game.totalLanes ~/ 2;
    EffectController controller =
        EffectController(duration: 0.05, infinite: true, alternate: true);
    shake = MoveEffect.by(Vector2(0, 2), controller);
    add(shake);
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
        game.question.solvePartial(amount: 3);
      }
    }
    super.onCollision(intersectionPoints, other);
  }

  @override
  void onGameResize(Vector2 size) {
    if (isLoaded) {
      move(lane);
      scale = Vector2(2 * factor, 1 * factor);
    }
    super.onGameResize(size);
  }
}
