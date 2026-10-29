/// A bidirectional binary channel to the game server.
///
/// Platforms provide implementations; `WebSocketTransport` works on web,
/// mobile and desktop.
abstract interface class GameTransport {
  /// Opens the channel. Completes once it is ready to send.
  Future<void> connect(Uri uri);

  /// Frames received from the server. Done when the channel closes.
  Stream<List<int>> get frames;

  /// Sends a binary frame.
  void send(List<int> frame);

  /// Closes the channel.
  Future<void> close();
}
