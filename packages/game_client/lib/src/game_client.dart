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

  /// Asks to gather from the resource node on a world tile. [seq] continues
  /// the move sequence so the server applies it after earlier moves.
  void sendGather({required int seq, required int tileX, required int tileY}) {
    _send(
      ClientMessage(
        gather: Gather(seq: seq, tileX: tileX, tileY: tileY),
      ),
    );
  }

  /// Stops the current action.
  void sendCancelAction() => _send(ClientMessage(cancelAction: CancelAction()));

  /// Equips the tool in inventory [slot].
  void sendEquip(int slot) =>
      _send(ClientMessage(equip: EquipItem(slot: slot)));

  /// Development only: asks for [count] of [itemId].
  void sendDebugGrantItem(String itemId, int count) => _send(
    ClientMessage(
      debug: DebugCommand(
        grantItem: GrantItem(itemId: itemId, count: count),
      ),
    ),
  );

  /// Development only: asks for [amount] XP in [skillId].
  void sendDebugGrantXp(String skillId, int amount) => _send(
    ClientMessage(
      debug: DebugCommand(
        grantXp: GrantXp(skillId: skillId, amount: amount),
      ),
    ),
  );

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
