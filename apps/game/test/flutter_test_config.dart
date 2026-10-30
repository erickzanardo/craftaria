import 'dart:async';

import 'package:craftaria_protocol/craftaria_protocol.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  // The game loads its sprite sheets from the asset bundle.
  TestWidgetsFlutterBinding.ensureInitialized();
  registerFallbackValue(Uri());
  registerFallbackValue(Appearance());
  await testMain();
}
