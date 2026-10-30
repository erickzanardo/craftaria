import 'dart:math' as math;

import 'package:craftaria/game/character/character_sprites.dart';
import 'package:craftaria/game/client_world.dart';
import 'package:craftaria/game/components/action_progress_component.dart';
import 'package:craftaria/game/components/player_component.dart';
import 'package:craftaria/game/input/movement_input.dart';
import 'package:craftaria_map/craftaria_map.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:world_renderer/world_renderer.dart';

/// Vertical world pixels the camera aims to show; zoom is the largest whole
/// number that fits, keeping pixels crisp.
const targetViewHeight = 180.0;

/// Renders a [ClientWorld] and feeds it the player's input.
class CraftariaGame extends FlameGame with KeyboardEvents, TapCallbacks {
  /// Creates a [CraftariaGame].
  CraftariaGame({
    required this.clientWorld,
    KeyboardMovementInput? input,
    TileRenderer? tileRenderer,
  }) : input = input ?? KeyboardMovementInput(),
       tileRenderer = tileRenderer ?? DebugTileRenderer();

  /// Sprite sheet of the characters, under `assets/images/`.
  static const charactersSheet = 'characters.png';

  /// State being rendered.
  final ClientWorld clientWorld;

  /// Movement input.
  final KeyboardMovementInput input;

  /// Draws tiles.
  final TileRenderer tileRenderer;

  /// Tinted character sprites, once loaded.
  late final CharacterSprites characterSprites;
  PlayerComponent? _localPlayer;
  final _remotePlayers = <String, PlayerComponent>{};
  final _chunkComponents = <ChunkCoord, List<ChunkComponent>>{};

  /// Components of the other players, by id.
  Map<String, PlayerComponent> get remotePlayers =>
      Map.unmodifiable(_remotePlayers);

  @override
  Future<void> onLoad() async {
    characterSprites = await CharacterSprites.load(
      await images.load(charactersSheet),
      palette: () => clientWorld.status.palette,
    );
  }

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
  void onTapUp(TapUpEvent event) => tapAt(event.canvasPosition);

  /// Acts on the world tile under [canvasPosition].
  void tapAt(Vector2 canvasPosition) {
    final point = camera.globalToLocal(canvasPosition);
    clientWorld.interact(
      (point.x / tileSize).floor(),
      (point.y / tileSize).floor(),
    );
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
      // A changed chunk is redrawn by replacing its components.
      for (final old in _chunkComponents[chunk.coord] ?? <ChunkComponent>[]) {
        old.removeFromParent();
      }
      final ground = ChunkComponent(
        chunk: chunk,
        tileRenderer: tileRenderer,
        priority: CraftariaLayers.ground,
      )..parent = world;
      final overlay = ChunkComponent(
        chunk: chunk,
        tileRenderer: tileRenderer,
        overlay: true,
        priority: CraftariaLayers.overlay,
      );
      if (overlay.hasLayers) overlay.parent = world;
      _chunkComponents[chunk.coord] = [ground, if (overlay.hasLayers) overlay];
    }
  }

  void _syncPlayers() {
    final localId = clientWorld.localPlayerId;
    if (_localPlayer == null && localId != null) {
      _localPlayer = PlayerComponent(
        playerId: localId,
        locate: () => clientWorld.localRenderPosition,
        look: () => clientWorld.lookOf(localId),
        sprites: characterSprites,
      )..parent = world;
      ActionProgressComponent(
        locate: () => clientWorld.localRenderPosition,
        progress: () => clientWorld.actionProgress,
      ).parent = world;
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
          look: () => clientWorld.lookOf(id),
          sprites: characterSprites,
        )..parent = world;
      });
    }
  }
}
