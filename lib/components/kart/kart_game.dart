import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';
import 'package:thoth/components/kart/collectible_spawner.dart';
import 'package:thoth/components/kart/components/car.dart';
import 'package:thoth/components/kart/components/collectible.dart';

class KartGame extends FlameGame with TapDetector, HasCollisionDetection {
  late final CarComponent player;
  //TODO: trocar por componente que mostra a pergunta
  late final TextComponent points;
  final List<CollectibleComponent> onScreenCollectibles = [];

  final int totalLanes = 5;
  int lane = 2;
  late final double carY;

  @override
  FutureOr<void> onLoad() async {
    carY = size.y - 100;

    //Carrega o player na tela
    player = CarComponent();
    add(player);
    player.position = Vector2(size.x / 2, carY);

    final spawner = CollectibleSpawner(period: 1);
    add(spawner);

    points = TextComponent(anchor: Anchor.center, priority: 10);
    points.position = Vector2(size.x / 2, size.y * .2);
    add(points);
  }

  void explodeParticles(Vector2 position) {
    const color = Colors.yellow;
    final particles = ParticleSystemComponent(
      particle: Particle.generate(
          count: 10,
          generator: (i) => MovingParticle(
              child: CircleParticle(radius: 3, paint: Paint()..color = color),
              to: (position -
                  (position - Vector2.all(50) + Vector2.random() * 100)))),
    )
      ..position = position
      ..priority = 8;
    add(particles);
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
    points.text = player.points.toString();
    super.update(dt);
  }

  //Divide a tela em [totalLanes] e posiciona no meio da lane
  double laneX(int lane) {
    //Calcula o centro da lane
    return size.x / totalLanes * lane + (size.x / totalLanes / 2);
  }
}
