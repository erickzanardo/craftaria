import 'dart:async';

import 'package:game_client/game_client.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class _MockChannel extends Mock implements WebSocketChannel {}

class _MockSink extends Mock implements WebSocketSink {}

void main() {
  group('WebSocketTransport', () {
    late _MockChannel channel;
    late _MockSink sink;
    late StreamController<dynamic> incoming;
    late Uri connectedTo;
    late WebSocketTransport transport;

    setUp(() {
      channel = _MockChannel();
      sink = _MockSink();
      incoming = StreamController<dynamic>();
      when(() => channel.ready).thenAnswer((_) async {});
      when(() => channel.stream).thenAnswer((_) => incoming.stream);
      when(() => channel.sink).thenReturn(sink);
      when(() => sink.close()).thenAnswer((_) async {});
      transport = WebSocketTransport(
        connector: (uri) {
          connectedTo = uri;
          return channel;
        },
      );
    });

    test('can be created with the default connector', () {
      expect(WebSocketTransport.new, returnsNormally);
    });

    test('connects and forwards binary frames only', () async {
      final uri = Uri.parse('ws://localhost:8787/zones/overworld/ws');
      final received = <List<int>>[];
      final errors = <Object>[];
      final done = Completer<void>();
      transport.frames.listen(
        received.add,
        onError: errors.add,
        onDone: done.complete,
      );

      await transport.connect(uri);
      incoming
        ..add([1, 2, 3])
        ..add('text is ignored')
        ..addError(StateError('boom'));
      await incoming.close();
      await done.future;

      expect(connectedTo, equals(uri));
      expect(
        received,
        equals([
          [1, 2, 3],
        ]),
      );
      expect(errors, hasLength(1));
    });

    test('send writes to the socket', () async {
      await transport.connect(Uri.parse('ws://localhost'));
      transport.send([4, 5]);
      verify(() => sink.add([4, 5])).called(1);
    });

    test('send before connect throws', () {
      expect(() => transport.send([1]), throwsStateError);
    });

    test('close closes the socket and the frame stream', () async {
      await transport.connect(Uri.parse('ws://localhost'));
      await transport.close();
      verify(() => sink.close()).called(1);
      await expectLater(transport.frames, emitsDone);
    });

    test('close is safe before connect and after the server closed', () async {
      await transport.close();

      final other = WebSocketTransport(connector: (_) => channel);
      await other.connect(Uri.parse('ws://localhost'));
      await incoming.close();
      await Future<void>.delayed(Duration.zero);
      await other.close();
    });
  });
}
