import 'dart:async';

import 'package:game_client/src/game_transport.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

/// Opens a [WebSocketChannel], overridable in tests.
typedef WebSocketConnector = WebSocketChannel Function(Uri uri);

/// [GameTransport] over a WebSocket.
class WebSocketTransport implements GameTransport {
  /// Creates a [WebSocketTransport].
  WebSocketTransport({WebSocketConnector? connector})
    : _connector = connector ?? WebSocketChannel.connect;

  final WebSocketConnector _connector;
  final _frames = StreamController<List<int>>.broadcast();
  WebSocketChannel? _channel;

  @override
  Stream<List<int>> get frames => _frames.stream;

  @override
  Future<void> connect(Uri uri) async {
    final channel = _connector(uri);
    await channel.ready;
    _channel = channel;
    channel.stream.listen(
      (frame) {
        // The server only speaks binary; drop anything else.
        if (frame is List<int>) _frames.add(frame);
      },
      onError: _frames.addError,
      onDone: _frames.close,
    );
  }

  @override
  void send(List<int> frame) {
    final channel = _channel;
    if (channel == null) throw StateError('send before connect');
    channel.sink.add(frame);
  }

  @override
  Future<void> close() async {
    await _channel?.sink.close();
    if (!_frames.isClosed) await _frames.close();
  }
}
