import 'package:bloc/bloc.dart';
import 'package:craftaria/bootstrap.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

class _CounterCubit extends Cubit<int> {
  _CounterCubit() : super(0);

  void increment() => emit(state + 1);

  void fail() => addError(StateError('boom'));
}

void main() {
  group('bootstrap', () {
    testWidgets('installs the observer and runs the app', (tester) async {
      final originalOnError = FlutterError.onError;
      addTearDown(() => FlutterError.onError = originalOnError);

      await bootstrap(() => const Text('hi', textDirection: TextDirection.ltr));
      await tester.pump();

      expect(find.text('hi'), findsOneWidget);
      expect(Bloc.observer, isA<AppBlocObserver>());
      FlutterError.onError!(FlutterErrorDetails(exception: Exception('x')));
    });
  });

  group('AppBlocObserver', () {
    test('observes changes and errors', () {
      Bloc.observer = const AppBlocObserver();
      _CounterCubit()
        ..increment()
        ..fail();
    });
  });
}
