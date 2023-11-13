import 'package:flame/game.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:thoth/components/kart/kart_game.dart';
import 'package:thoth/models/atividade.dart';
import 'package:thoth/models/tema.dart';
import 'package:thoth/models/topico.dart';
import 'package:thoth/routes.dart';
import 'package:thoth/views/pontuacao.dart';

class Kart extends StatelessWidget {
  final Tema tema;
  final Topico topico;
  const Kart({super.key, required this.tema, required this.topico});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return GameWidget(
      game: KartGame(tema: tema, topico: topico),
      overlayBuilderMap: {
        'Pause': (BuildContext context, KartGame game) {
          return Text("teste");
        },
        'Exit': (BuildContext context, KartGame game) {
          game.pauseEngine();
          return Pontuacao(atividade: game.atividade, cor: CorPontuacao.kart);
        },
      },
    );
  }
}
