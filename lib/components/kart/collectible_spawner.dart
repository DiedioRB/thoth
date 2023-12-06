import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:thoth/components/kart/components/collectible.dart';
import 'package:thoth/components/kart/kart_game.dart';

class CollectibleSpawner extends TimerComponent with HasGameRef<KartGame> {
  final int period = 1;
  final List<CollectibleComponent> onScreenCollectibles = [];
  late double spawnY;

  CollectibleSpawner({required super.period});
  @override
  FutureOr<void> onLoad() {
    timer.repeat = true;
    //Aparece abaixo do topo da tela para simular ponto de escape
    spawnY = game.size.y * .35;
  }

  @override
  void onTick() {
    final rand = Random().nextInt(game.totalLanes);
    final collectible = CollectibleComponent(lane: rand);
    onScreenCollectibles.add(collectible);
    add(collectible);
    collectible.position = Vector2(game.size.x / 2, spawnY);
  }

  void cleanCollectibles() {
    for (CollectibleComponent collectible in onScreenCollectibles) {
      collectible.removeFromParent();
    }
    onScreenCollectibles.clear();
  }

  void start() {
    timer.start();
  }

  void pause() {
    timer.pause();
  }

  void stop() {
    timer.stop();
  }

  @override
  void onGameResize(Vector2 size) {
    spawnY = game.size.y * .35;
    super.onGameResize(size);
  }
}
