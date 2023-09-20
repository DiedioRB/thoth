import 'dart:async';

import 'package:flame/components.dart';

class QuestionText extends TextComponent {
  String? hiddenText;
  int totalParts;

  int parts = 0;

  QuestionText({this.hiddenText, this.totalParts = 10});

  @override
  FutureOr<void> onLoad() {
    anchor = Anchor.center;
  }

  void solvePartial({int parts = 1}) {}

  void solveText() {
    text = hiddenText!;
  }
}
