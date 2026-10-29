import 'dart:math' as math;

import 'package:craftaria/game/client_world.dart';
import 'package:craftaria/game/components/player_component.dart';
import 'package:craftaria/game/input/movement_input.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:world_renderer/world_renderer.dart';

/// Vertical world pixels the camera aims to show; zoom is the largest whole
/// number that fits, keeping pixels crisp.
const targetViewHeight = 180.0;

/// Renders a [ClientWorld] and feeds it the player's input.
class CraftariaGame extends FlameGame with KeyboardEvents {
  /// Creates a [CraftariaGame].
  CraftariaGame({
    required this.clientWorld,
    KeyboardMovementInput? input,
    TileRenderer? tileRenderer,
  }) : input = input ?? KeyboardMovementInput(),
       tileRenderer = tileRenderer ?? DebugTileRenderer();

  /// Local color of the player until sprites exist.
  static const localPlayerColor = Color(0xFFFFE066);

  /// Color of other players until sprites exist.
  static const remotePlayerColor = Color(0xFFE06666);

  /// State being rendered.
  final ClientWorld clientWorld;

  /// Movement input.
  final KeyboardMovementInput input;

  /// Draws tiles.
  final TileRenderer tileRenderer;

  PlayerComponent? _localPlayer;
  final _remotePlayers = <String, PlayerComponent>{};

  /// Components of the other players, by id.
  Map<String, PlayerComponent> get remotePlayers =>
      Map.unmodifiable(_remotePlayers);

  @override
  Color backgroundColor() => const Color(0xFF000000);

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    camera.viewfinder.zoom = math
        .max(1, (size.y / targetViewHeight).floor())
        .toDouble();
  }

  @override
  void update(double dt) {
    clientWorld.update(dt, input.intent);
    _addNewChunks();
    _syncPlayers();
    super.update(dt);

    final local = clientWorld.localRenderPosition;
    if (local != null) {
      camera.viewfinder.position = Vector2(
        local.pixelX.roundToDouble(),
        local.pixelY.roundToDouble(),
      );
    }
  }

  @override
  KeyEventResult onKeyEvent(
    KeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    return input.onKeysPressed(keysPressed)
        ? KeyEventResult.handled
        : KeyEventResult.ignored;
  }

  void _addNewChunks() {
    for (final chunk in clientWorld.takeNewChunks()) {
      ChunkComponent(
        chunk: chunk,
        tileRenderer: tileRenderer,
        priority: CraftariaLayers.ground,
      ).parent = world;
      final overlay = ChunkComponent(
        chunk: chunk,
        tileRenderer: tileRenderer,
        overlay: true,
        priority: CraftariaLayers.overlay,
      );
      if (overlay.hasLayers) overlay.parent = world;
    }
  }

  void _syncPlayers() {
    final localId = clientWorld.localPlayerId;
    if (_localPlayer == null && localId != null) {
      _localPlayer = PlayerComponent(
        playerId: localId,
        locate: () => clientWorld.localRenderPosition,
        color: localPlayerColor,
      )..parent = world;
    }

    final visible = clientWorld.remotePlayerIds.toSet();
    _remotePlayers.removeWhere((id, component) {
      if (visible.contains(id)) return false;
      component.removeFromParent();
      return true;
    });
    for (final id in visible) {
      _remotePlayers.putIfAbsent(id, () {
        return PlayerComponent(
          playerId: id,
          locate: () => clientWorld.remotePosition(id),
          color: remotePlayerColor,
        )..parent = world;
      });
    }
  }
}
