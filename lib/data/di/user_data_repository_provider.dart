import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thundercard/data/di/local_user_data_repository_provider.dart';
import 'package:thundercard/data/repository/user_data_repository.dart';

final userDataRepositoryProvider = Provider<UserDataRepository>(
  (ref) => ref.watch(localUserDataRepositoryProvider),
);
