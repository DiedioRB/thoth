import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:thoth/components/kart/kart_game.dart';

class GameOverDialog extends RectangleComponent with HasGameRef<KartGame> {
  int corretas = 0;
  int erradas = 0;

  GameOverDialog({required this.corretas, required this.erradas});

  @override
  FutureOr<void> onLoad() async {
    size = game.size;
    position = Vector2.zero();
    paint = Paint()..color = Colors.black.withOpacity(0.5);
    priority = 9;
    opacity = 0.5;

    TextComponent text = TextComponent(
        text: "Fim de jogo\n\nCorretas: $corretas\nErradas: $erradas",
        anchor: Anchor.topLeft,
        textRenderer: TextPaint(
          style: const TextStyle(color: Colors.black, fontSize: 24),
        ));
    Vector2 spriteSize = text.size + Vector2.all(100);
    final sprite = await Sprite.load("button.png");
    add(SpriteComponent(
        sprite: sprite,
        anchor: Anchor.center,
        position: size / 2,
        size: spriteSize,
        children: [text..position = spriteSize / 4]));
  }
}
