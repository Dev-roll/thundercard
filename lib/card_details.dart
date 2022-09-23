import 'package:flutter/material.dart';
import 'package:thundercard/custom_progress_indicator.dart';
import 'package:thundercard/widgets/card_info.dart';
import 'package:thundercard/widgets/scan_qr_code.dart';
import 'api/firebase_auth.dart';
import 'widgets/my_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CardDetails extends StatelessWidget {
  const CardDetails({Key? key, required this.cardId}) : super(key: key);
  final String cardId;

  @override
  Widget build(BuildContext context) {
    final String? uid = getUid();
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              padding: const EdgeInsets.only(bottom: 100),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: MyCard(cardId: cardId),
                  ),
                  CardInfo(cardId: cardId, editable: false)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
