import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:thoth/components/kart/kart_game.dart';

class PauseMenu extends PositionComponent
    with HasGameRef<KartGame>, TapCallbacks {
  @override
  FutureOr<void> onLoad() async {
    position = Vector2(game.size.x - 50, 50);
    anchor = Anchor.center;

    TextComponent text = TextComponent(text: "||");
    add(text);
  }

  @override
  void onTapDown(TapDownEvent event) {
    game.pauseEngine();
  }
}
