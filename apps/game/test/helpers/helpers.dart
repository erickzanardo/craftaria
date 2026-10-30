import 'dart:async';

import 'package:auth_repository/auth_repository.dart';
import 'package:craftaria/game/game.dart';
import 'package:craftaria_protocol/craftaria_protocol.dart';
import 'package:game_client/game_client.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockGameClient extends Mock implements GameClient {}

/// A [MockGameClient] whose messages come from [messages].
MockGameClient mockGameClient(StreamController<ServerMessage> messages) {
  final client = MockGameClient();
  // GameClient.messages is a broadcast stream.
  final stream = messages.stream.asBroadcastStream();
  when(() => client.messages).thenAnswer((_) => stream);
  when(
    () => client.connect(any(), token: any(named: 'token')),
  ).thenAnswer((_) async {});
  when(client.close).thenAnswer((_) async {});
  return client;
}

/// A palette of 46 distinct colors, like the game's.
final List<int> testPalette = [for (var i = 0; i < 46; i++) 0x010203 * i];

/// Skin indexes of [testPalette].
const testSkinColors = [12, 13, 14, 15, 16, 17, 18, 19];

/// A valid look in [testPalette].
const testLook = CharacterLook(skin: 12, shirt: 0, pants: 1);

/// A welcome for a player who has created their character as [look], or
/// who has not when [look] is null.
ServerMessage welcome({
  String playerId = 'me',
  int x = 64,
  int y = 64,
  CharacterLook? look = testLook,
}) => ServerMessage(
  welcome: Welcome(
    playerId: playerId,
    tickRate: 20,
    spawn: Vec2(x: x, y: y),
    palette: testPalette,
    skinColors: testSkinColors,
    appearance: look?.toProto(),
  ),
);

/// A snapshot of [entities] at their positions, all looking like
/// [testLook] except the [uncreated] ones.
ServerMessage snapshot(
  Map<String, (int, int)> entities, {
  int lastInputSeq = 0,
  Set<String> uncreated = const {},
}) => ServerMessage(
  snapshot: Snapshot(
    lastInputSeq: lastInputSeq,
    entities: [
      for (final MapEntry(key: id, value: (x, y)) in entities.entries)
        EntityState(
          id: id,
          position: Vec2(x: x, y: y),
          appearance: uncreated.contains(id) ? null : testLook.toProto(),
        ),
    ],
  ),
);
