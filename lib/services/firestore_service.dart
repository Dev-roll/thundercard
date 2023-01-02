import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class FirestoreService {
  FirestoreService({required this.uid});
  final String uid;

  final CollectionReference _cardsCollectionReference = FirebaseFirestore
      .instance
      .collection('version')
      .doc('2')
      .collection('cards');
  final CollectionReference _usersCollectionReference =
      FirebaseFirestore.instance.collection('users');

  Future<String> getCurrentCardId() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> cardId =
          await _usersCollectionReference
              .doc(uid)
              .collection('card')
              .doc('current_card')
              .get();
      return cardId.data()!['current_card'] as String;
    } catch (e) {
      if (e is PlatformException) {
        throw PlatformException(code: e.message as String);
      }
      throw Exception(e.toString());
    }
  }

  Future<List<String>> getExchangedCards() async {
    final String currentCardId = await getCurrentCardId();

    try {
      DocumentSnapshot<Map<String, dynamic>> exchangedCards =
          await _cardsCollectionReference
              .doc(currentCardId)
              .collection('visibility')
              .doc('c10r10u11d10')
              .get();
      return exchangedCards.data()!['exchanged_cards'].cast<String>()
          as List<String>;
    } catch (e) {
      if (e is PlatformException) {
        throw PlatformException(code: e.message as String);
      }
      throw Exception(e.toString());
    }
  }

  Stream<List<String>> exchangedCardsStream(String currentCardId) {
    final Stream<DocumentSnapshot<Map<String, dynamic>>> snapshots =
        _cardsCollectionReference
            .doc(currentCardId)
            .collection('visibility')
            .doc('c10r10u11d10')
            .snapshots();
    return snapshots.map((event) {
      if (event.data() == null) {
        return <String>[];
      }
      return event.data()!['exchanged_cards'].cast<String>() as List<String>;
    });
  }
}
