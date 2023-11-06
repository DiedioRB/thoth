import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:thoth/components/kart/background.dart';
import 'package:thoth/components/kart/collectible_spawner.dart';
import 'package:thoth/components/kart/components/answer_dialog.dart';
import 'package:thoth/components/kart/components/car.dart';
import 'package:thoth/components/kart/components/collectible.dart';
import 'package:thoth/components/kart/components/game_over_dialog.dart';
import 'package:thoth/components/kart/components/pause.dart';
import 'package:thoth/components/kart/components/question_text.dart';
import 'package:thoth/components/kart/pergunta_manager.dart';
import 'package:thoth/models/atividade.dart';
import 'package:thoth/models/tema.dart';
import 'package:thoth/models/topico.dart';
import 'package:thoth/routes.dart';

enum State { playing, answering, paused, starting, finishing }

class KartGame extends FlameGame
    with TapDetector, HasCollisionDetection, KeyboardEvents {
  bool keyboardPressed = false;

  State state = State.starting;

  late final Atividade atividade;
  final Topico topico;
  KartGame({required this.topico});

  late final CarComponent player;
  late final Background background;
  //TODO: trocar por componente que mostra a pergunta
  late final QuestionText question;
  final List<CollectibleComponent> onScreenCollectibles = [];

  final int totalLanes = 5;
  int lane = 2;
  late final double carY;

  late final CollectibleSpawner spawner;
  late final AnswerDialogComponent answerDialog;

  @override
  FutureOr<void> onLoad() async {
    await carregaAtividade();
    final background = Background();
    add(background);

    add(PauseMenu());

    carY = size.y - 100;

    //Carrega o player na tela
    player = CarComponent();
    add(player);
    player.position = Vector2(size.x / 2, carY);

    spawner = CollectibleSpawner(period: 1);
    add(spawner);

    answerDialog = AnswerDialogComponent();
    // answerDialog.updateRespostas(perguntaManager.perguntaAtual.respostas);

    question =
        QuestionText(hiddenText: atividade.pergunta.pergunta, totalParts: 3);
    add(question);
  }

  Future<void> carregaAtividade() async {
    Tema tema = await topico.tema as Tema;
    atividade = Atividade(tema: tema, topico: topico);
    await atividade.carregarPerguntas();
  }

  void explodeParticles(Vector2 position) {
    const color = Colors.yellow;
    final particles = ParticleSystemComponent(
      particle: Particle.generate(
          count: 20,
          generator: (i) => MovingParticle(
              child: CircleParticle(radius: 3, paint: Paint()..color = color),
              to: (position -
                  (position - Vector2.all(50) + Vector2.random() * 100)))),
    )
      ..position = position
      ..priority = 8;
    add(particles);
  }

  void buildAnswers() {
    spawner.pause();
    add(answerDialog);
    answerDialog.updateRespostas(atividade.pergunta.respostas);
    for (var component in spawner.onScreenCollectibles) {
      component.removeFromParent();
    }
  }

  void answered(int answer) {
    for (var button in answerDialog.buttons) {
      button.removeFromParent();
    }
    answerDialog.removeFromParent();
    atividade.responder(answer);
    if (!atividade.finalizado) {
      question.newText(atividade.pergunta.pergunta);
      spawner.start();
    } else {
      question.removeFromParent();
      overlays.add('Exit');
      add(GameOverDialog(
          corretas: atividade.acertos, erradas: atividade.erros));
    }
  }

  @override
  void onTapDown(TapDownInfo info) {
    if (info.eventPosition.game.x < size.x / 2) {
      //Move para esquerda
      if (lane > 0) {
        player.moveLeft();
      }
    } else {
      //Move para direita
      if (lane < totalLanes - 1) {
        player.moveRight();
      }
    }
  }

  @override
  void update(double dt) {
    question.text = question.text;
    super.update(dt);
  }

  //Divide a tela em [totalLanes] e posiciona no meio da lane
  double laneX(int lane) {
    //Calcula o centro da lane
    return size.x / totalLanes * lane + (size.x / totalLanes / 2);
  }

  @override
  KeyEventResult onKeyEvent(
      RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    final isKeyDown = event is RawKeyDownEvent;
    final isKeyUp = event is RawKeyUpEvent;

    if (isKeyDown && !keyboardPressed) {
      keyboardPressed = true;
      if (keysPressed.contains(LogicalKeyboardKey.arrowLeft) ||
          keysPressed.contains(LogicalKeyboardKey.keyA)) {
        player.moveLeft();
      } else if (keysPressed.contains(LogicalKeyboardKey.arrowRight) ||
          keysPressed.contains(LogicalKeyboardKey.keyD)) {
        player.moveRight();
      }
      return KeyEventResult.handled;
    } else if (isKeyUp) {
      keyboardPressed = false;
    }

    return KeyEventResult.ignored;
  }
}
