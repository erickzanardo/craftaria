import 'dart:async';

import 'package:mocktail/mocktail.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  registerFallbackValue(Uri());
  await testMain();
}
