import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thundercard/providers/current_card_id_provider.dart';
import 'package:thundercard/providers/firestore_service_provider.dart';
import 'package:thundercard/services/firestore_service.dart';

final exchangedCardsStreamProvider = StreamProvider.autoDispose<List<String>>(
  (ref) {
    final FirestoreService? firestoreService =
        ref.watch(firestoreServiceProvider);
    final String? currentCardId = ref.watch(currentCardIdProvider);

    if (firestoreService == null) {
      throw Exception('FirestoreService is null');
    }

    return firestoreService.exchangedCardsStream(currentCardId!);
  },
  dependencies: [currentCardIdProvider, firestoreServiceProvider],
);

final exchangedCardsProvider = Provider<List<String>>((ref) {
  throw UnimplementedError();
});
