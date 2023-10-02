import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:thoth/components/kart/kart_game.dart';

class Button extends SpriteComponent with TapCallbacks, HasGameRef<KartGame> {
  late TextComponent textComponent;
  int selection = 0;

  Button({required String text, required this.selection}) {
    textComponent = TextComponent(
        text: text,
        anchor: Anchor.center,
        textRenderer: TextPaint(
            style: const TextStyle(color: Colors.black, fontSize: 24)));
  }

  @override
  FutureOr<void> onLoad() async {
    final sprite = await Sprite.load("button.png");
    this.sprite = sprite;
    size = Vector2(game.size.x / 2, 100);
    textComponent.position = size / 2;
    anchor = Anchor.center;
    priority = 9;

    add(textComponent);
  }

  set text(String text) {
    textComponent.text = text;
  }

  @override
  void onTapDown(TapDownEvent event) {
    game.answered(selection);
    super.onTapDown(event);
  }
}
