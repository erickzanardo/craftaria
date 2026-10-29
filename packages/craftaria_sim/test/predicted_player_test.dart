import 'package:craftaria_sim/craftaria_sim.dart';
import 'package:test/test.dart';

bool _open(int x, int y) => false;

void main() {
  group('PredictedPlayer', () {
    test('applies inputs immediately with increasing seqs', () {
      final player = PredictedPlayer(
        position: const Position(0, 0),
        isBlocked: _open,
      );

      final first = player.apply(const MoveIntent(1, 0));
      final second = player.apply(const MoveIntent(1, 0));

      expect(first.seq, equals(1));
      expect(second.seq, equals(2));
      expect(player.previous, equals(const Position(playerSpeed, 0)));
      expect(player.position, equals(const Position(playerSpeed * 2, 0)));
      expect(player.pending, hasLength(2));
    });

    test('reserveSeq keeps seqs increasing across moves', () {
      final player = PredictedPlayer(
        position: const Position(0, 0),
        isBlocked: _open,
      )..apply(const MoveIntent(1, 0));
      expect(player.reserveSeq(), equals(2));
      expect(player.apply(const MoveIntent(1, 0)).seq, equals(3));
      expect(player.pending, hasLength(2));
    });

    test('hold settles the previous position', () {
      final player =
          PredictedPlayer(position: const Position(0, 0), isBlocked: _open)
            ..apply(const MoveIntent(1, 0))
            ..hold();
      expect(player.previous, equals(player.position));
      expect(player.pending, hasLength(1));
    });

    test('reconcile drops acknowledged inputs and replays the rest', () {
      final player = PredictedPlayer(
        position: const Position(0, 0),
        isBlocked: _open,
      );
      for (var i = 0; i < 3; i++) {
        player.apply(const MoveIntent(0, 1));
      }

      // Server applied the first input but from a different spot.
      player.reconcile(
        server: const Position(100, playerSpeed),
        lastInputSeq: 1,
      );

      expect(player.pending.map((input) => input.seq), equals([2, 3]));
      expect(player.position, equals(const Position(100, playerSpeed * 3)));
    });

    test('reconcile with everything acknowledged snaps to the server', () {
      final player =
          PredictedPlayer(position: const Position(0, 0), isBlocked: _open)
            ..apply(const MoveIntent(1, 1))
            ..reconcile(server: const Position(5, 5), lastInputSeq: 1);

      expect(player.pending, isEmpty);
      expect(player.position, equals(const Position(5, 5)));
    });
  });
}
