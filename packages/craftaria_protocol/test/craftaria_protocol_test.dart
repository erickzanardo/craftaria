import 'package:craftaria_protocol/craftaria_protocol.dart';
import 'package:test/test.dart';

void main() {
  group('craftaria_protocol', () {
    test('protocolVersion is 3', () {
      expect(protocolVersion, equals(3));
    });

    test('ClientMessage round trips through the binary format', () {
      final message = ClientMessage(move: MoveInput(seq: 7, dx: -1, dy: 1));

      final decoded = ClientMessage.fromBuffer(message.writeToBuffer());

      expect(decoded.whichPayload(), equals(ClientMessage_Payload.move));
      expect(decoded.move.seq, equals(7));
      expect(decoded.move.dx, equals(-1));
      expect(decoded.move.dy, equals(1));
    });
  });
}
