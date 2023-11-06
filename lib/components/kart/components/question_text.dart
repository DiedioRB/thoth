import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:thoth/components/kart/kart_game.dart';

class QuestionText extends TextComponent with HasGameRef<KartGame> {
  String? hiddenText;
  String shownText = "";
  int totalParts;

  int parts = 0;

  QuestionText({this.hiddenText, this.totalParts = 10});

  @override
  FutureOr<void> onLoad() {
    anchor = Anchor.center;
    priority = 10;
    position = Vector2(game.size.x / 2, game.size.y * .2);

    obscureText();
    text = shownText;
  }

  void solvePartial({int? amount}) {
    amount ??= hiddenText!.length ~/ totalParts + 1;
    for (var i = 0; i < amount; i++) {
      shownText = shownText.replaceRange(
          min(parts, shownText.length),
          min(parts + 1, shownText.length),
          hiddenText?.substring(min(parts, hiddenText!.length),
                  min(parts + 1, hiddenText!.length)) ??
              "");
      parts++;
    }
    text = shownText;
    if (parts >= hiddenText!.length) {
      game.buildAnswers();
    }
  }

  void solveText() {
    text = hiddenText!;
  }

  void newText(String newText) {
    hiddenText = newText;
    parts = 0;
    obscureText();
    text = shownText;
  }

  void obscureText() {
    shownText = "";
    for (var i = 0; i < (hiddenText?.length ?? 0); i++) {
      shownText += "_";
    }
  }

  @override
  void onGameResize(Vector2 size) {
    position = Vector2(game.size.x / 2, game.size.y * .2);
    super.onGameResize(size);
  }
}
