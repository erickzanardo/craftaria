import 'dart:async';

import 'package:craftaria_protocol/craftaria_protocol.dart';
import 'package:fixnum/fixnum.dart';
import 'package:game_client/src/game_transport.dart';

/// Speaks the craftaria protocol over a [GameTransport].
class GameClient {
  /// Creates a [GameClient].
  GameClient({required GameTransport transport}) : _transport = transport;

  final GameTransport _transport;

  /// Messages from the server. Malformed frames are reported as errors.
  /// Done when the connection closes.
  late final Stream<ServerMessage> messages = _transport.frames
      .transform(
        StreamTransformer<List<int>, ServerMessage>.fromHandlers(
          handleData: (frame, sink) {
            try {
              sink.add(ServerMessage.fromBuffer(frame));
            } on Exception catch (error, stackTrace) {
              sink.addError(error, stackTrace);
            }
          },
        ),
      )
      .asBroadcastStream();

  /// Connects to a zone at [uri] and authenticates with [token].
  Future<void> connect(Uri uri, {required String token}) async {
    await _transport.connect(uri);
    _send(
      ClientMessage(
        hello: Hello(token: token, protocolVersion: protocolVersion),
      ),
    );
  }

  /// Sends one tick of movement intent.
  void sendMove({required int seq, required int dx, required int dy}) {
    _send(
      ClientMessage(
        move: MoveInput(seq: seq, dx: dx, dy: dy),
      ),
    );
  }

  /// Sends a ping stamped with [clientTime].
  void ping(DateTime clientTime) {
    _send(
      ClientMessage(
        ping: Ping(clientTimeMs: Int64(clientTime.millisecondsSinceEpoch)),
      ),
    );
  }

  /// Closes the connection.
  Future<void> close() => _transport.close();

  void _send(ClientMessage message) => _transport.send(message.writeToBuffer());
}
