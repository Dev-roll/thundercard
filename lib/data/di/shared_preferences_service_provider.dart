import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thundercard/data/di/shared_preferences_provider.dart';
import 'package:thundercard/data/service/shared_preferences_service.dart';

final sharedPreferencesServiceProvider = Provider<SharedPreferencesService>(
  (ref) => SharedPreferencesService(ref.watch(sharedPreferencesProvider)),
);
