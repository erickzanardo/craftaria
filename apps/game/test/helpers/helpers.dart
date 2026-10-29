import 'dart:async';

import 'package:auth_repository/auth_repository.dart';
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

ServerMessage welcome({String playerId = 'me', int x = 64, int y = 64}) =>
    ServerMessage(
      welcome: Welcome(
        playerId: playerId,
        tickRate: 20,
        spawn: Vec2(x: x, y: y),
      ),
    );

ServerMessage snapshot(
  Map<String, (int, int)> entities, {
  int lastInputSeq = 0,
}) => ServerMessage(
  snapshot: Snapshot(
    lastInputSeq: lastInputSeq,
    entities: [
      for (final MapEntry(key: id, value: (x, y)) in entities.entries)
        EntityState(
          id: id,
          position: Vec2(x: x, y: y),
        ),
    ],
  ),
);
