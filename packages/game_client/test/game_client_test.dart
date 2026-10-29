import 'dart:async';

import 'package:craftaria_protocol/craftaria_protocol.dart';
import 'package:game_client/game_client.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class _MockTransport extends Mock implements GameTransport {}

void main() {
  group('GameClient', () {
    late _MockTransport transport;
    late StreamController<List<int>> frames;
    late GameClient client;

    setUp(() {
      transport = _MockTransport();
      frames = StreamController<List<int>>();
      when(() => transport.frames).thenAnswer((_) => frames.stream);
      when(() => transport.connect(any())).thenAnswer((_) async {});
      when(() => transport.close()).thenAnswer((_) async {});
      client = GameClient(transport: transport);
    });

    setUpAll(() => registerFallbackValue(Uri()));

    List<ClientMessage> sent() => verify(() => transport.send(captureAny()))
        .captured
        .map((frame) => ClientMessage.fromBuffer(frame as List<int>))
        .toList();

    test('connect opens the transport and says hello', () async {
      final uri = Uri.parse('ws://localhost/zones/overworld/ws');

      await client.connect(uri, token: 'abc');

      verify(() => transport.connect(uri)).called(1);
      final [hello] = sent();
      expect(hello.hello.token, equals('abc'));
      expect(hello.hello.protocolVersion, equals(protocolVersion));
    });

    test('sendMove sends a move input', () {
      client.sendMove(seq: 3, dx: 1, dy: -1);

      final [message] = sent();
      expect(message.move, equals(MoveInput(seq: 3, dx: 1, dy: -1)));
    });

    test('sendGather sends a gather with its seq', () {
      client.sendGather(seq: 4, tileX: -2, tileY: 7);
      final [message] = sent();
      expect(message.gather, equals(Gather(seq: 4, tileX: -2, tileY: 7)));
    });

    test('sendCancelAction and sendEquip', () {
      client
        ..sendCancelAction()
        ..sendEquip(3);
      final [cancel, equip] = sent();
      expect(cancel.hasCancelAction(), isTrue);
      expect(equip.equip.slot, equals(3));
    });

    test('debug commands', () {
      client
        ..sendDebugGrantItem('iron_axe', 1)
        ..sendDebugGrantXp('woodcutting', 500);
      final [item, xp] = sent();
      expect(
        item.debug.grantItem,
        equals(GrantItem(itemId: 'iron_axe', count: 1)),
      );
      expect(
        xp.debug.grantXp,
        equals(GrantXp(skillId: 'woodcutting', amount: 500)),
      );
    });

    test('ping sends the client time', () {
      client.ping(DateTime.fromMillisecondsSinceEpoch(42));

      final [message] = sent();
      expect(message.ping.clientTimeMs.toInt(), equals(42));
    });

    test('messages decodes frames and reports malformed ones', () async {
      final events = <Object>[];
      final done = Completer<void>();
      client.messages.listen(
        events.add,
        onError: events.add,
        onDone: done.complete,
      );

      frames
        ..add(ServerMessage(welcome: Welcome(playerId: 'p')).writeToBuffer())
        ..add([0xff, 0xff, 0xff]);
      await frames.close();
      await done.future;

      expect(events, hasLength(2));
      expect((events.first as ServerMessage).welcome.playerId, equals('p'));
      expect(events.last, isA<Exception>());
    });

    test('close closes the transport', () async {
      await client.close();
      verify(() => transport.close()).called(1);
    });
  });
}
