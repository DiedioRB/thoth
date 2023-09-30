import 'package:flame/game.dart';
import 'package:flutter/widgets.dart';
import 'package:thoth/components/kart/kart_game.dart';

class Kart extends StatelessWidget {
  const Kart({super.key});

  @override
  Widget build(BuildContext context) {
    return GameWidget(
      game: KartGame(),
    );
  }
}
