import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:thoth/components/kart/components/button.dart';
import 'package:thoth/components/kart/kart_game.dart';


class AnswerDialogComponent extends RectangleComponent
    with HasGameRef<KartGame> {
  List<String> respostas = [];
  List<Button> buttons = [];

  @override
  FutureOr<void> onLoad() async {
    size = game.size;
    position = Vector2.zero();
    paint = Paint()..color = Colors.black.withOpacity(0.5);
    priority = 9;
    opacity = 0.5;
  }

  void updateRespostas(List<String> respostas) {
    this.respostas = respostas;
    for (var button in buttons) {
      button.removeFromParent();
    }
    buttons = [];
    double printY = size.y * 0.3;
    for (var (index, resposta) in this.respostas.indexed) {
      buttons.add(
        Button(text: resposta, selection: index)
          ..position = Vector2(size.x / 2, printY),
      );
      printY += 110;
    }
    game.addAll(buttons);
  }
}
