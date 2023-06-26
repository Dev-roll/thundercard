import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thundercard/data/di/shared_preferences_service_provider.dart';
import 'package:thundercard/data/repository/local_user_data_repository.dart';

final localUserDataRepositoryProvider = Provider<LocalUserDataRepository>(
  (ref) => LocalUserDataRepository(ref.watch(sharedPreferencesServiceProvider)),
);
