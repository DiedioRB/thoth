import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:thoth/components/kart/kart_game.dart';

class Background extends SpriteAnimationComponent with HasGameRef<KartGame> {
  @override
  FutureOr<void> onLoad() async {
    final image = await game.images.load("background_animation.png");
    final sheet = SpriteSheet(image: image, srcSize: Vector2(128, 128));
    SpriteAnimation animation = sheet.createAnimation(row: 0, stepTime: 0.1);
    this.animation = animation;
    // anchor = Anchor.topCenter;
    size = Vector2(1, 1);
    scale = Vector2(game.size.x, game.size.y);
    // final decorator = Rotate3DDecorator(
    //     center: Vector2(size.x / 2, size.y), angleX: 1.5, perspective: 0.002);
    // this.decorator = decorator;
  }

  @override
  void onGameResize(Vector2 size) {
    scale = Vector2(game.size.x, game.size.y);
    super.onGameResize(size);
  }
}
