import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:thoth/components/kart/background.dart';
import 'package:thoth/components/kart/collectible_spawner.dart';
import 'package:thoth/components/kart/components/car.dart';
import 'package:thoth/components/kart/components/collectible.dart';
import 'package:thoth/components/kart/components/question_text.dart';

class KartGame extends FlameGame
    with TapDetector, HasCollisionDetection, KeyboardEvents {
  late final CarComponent player;
  late final Background background;
  //TODO: trocar por componente que mostra a pergunta
  late final QuestionText question;
  final List<CollectibleComponent> onScreenCollectibles = [];

  final int totalLanes = 5;
  int lane = 2;
  late final double carY;

  late final CollectibleSpawner spawner;

  @override
  FutureOr<void> onLoad() async {
    // Sprite s = await Sprite.load("track.png");
    // add(SpriteComponent(
    //     sprite: s, size: Vector2.all(50), position: Vector2(size.x / 2, 0)));
    final background = Background();
    add(background);

    carY = size.y - 100;

    //Carrega o player na tela
    player = CarComponent();
    add(player);
    player.position = Vector2(size.x / 2, carY);

    spawner = CollectibleSpawner(period: 1);
    add(spawner);

    question = QuestionText(hiddenText: "Qual a pergunta mostrada na tela?");
    add(question);
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
    Future.delayed(
      const Duration(seconds: 3),
      () {
        question.newText("Qual a pergunta agora?");
        spawner.start();
      },
    );
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

    if (isKeyDown) {
      if (keysPressed.contains(LogicalKeyboardKey.arrowLeft) ||
          keysPressed.contains(LogicalKeyboardKey.keyA)) {
        player.moveLeft();
      } else if (keysPressed.contains(LogicalKeyboardKey.arrowRight) ||
          keysPressed.contains(LogicalKeyboardKey.keyD)) {
        player.moveRight();
      }
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }
}
