import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:thesis/pages/game/play_button.dart';

class BlockGame extends FlameGame<BlockGameWorld> {
  BlockGame()
      : super(
            world: BlockGameWorld(),
            camera:
                CameraComponent.withFixedResolution(width: 600, height: 1000));

  late final RouterComponent router;

  @override
  void onGameResize(Vector2 size) {
    // TODO: implement onGameResize
    super.onGameResize(size);
  }

  @override
  FutureOr<void> onLoad() async {
    // TODO: implement onLoad
    super.onLoad();
  }

  @override
  void onMount() {
    // TODO: implement onMount
    super.onMount();
  }

  @override
  void update(double dt) {
    // TODO: implement update
    super.update(dt);
  }

  @override
  void render(Canvas canvas) {
    // TODO: implement render
    super.render(canvas);
  }
}

class BlockGameWorld extends World {
  late PlayButton playButton;

  @override
  FutureOr<void> onLoad() {
    // PLAY BUTTON
    playButton = PlayButton();

    playButton.anchor = Anchor.center;
    add(Dash());
    // add(playButton);
    return super.onLoad();
  }
}

class Dash extends PositionComponent with DragCallbacks {
  Dash() : super(position: Vector2(0, 0), size: Vector2(50, 50));
  @override
  void update(double dt) {
    // TODO: implement update
    super.update(dt);

    // position = Vector2.zero();
    // angle += 0.01;
  }

  @override
  void onDragStart(DragStartEvent event) {
    priority = 100;
    super.onDragStart(event);
    position += event.localPosition;
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    position += event.localDelta;
  }

  @override
  void render(Canvas canvas) {
    // TODO: implement render
    super.render(canvas);
    canvas.drawRect(
        Rect.fromCenter(center: Offset.zero, width: size.x, height: size.y),
        BasicPalette.red.paint());
    // canvas.drawCircle(Offset.zero, 20, BasicPalette.blue.paint());
  }
}
