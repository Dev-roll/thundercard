import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:thundercard/api/return_original_color.dart';

import '../api/current_brightness.dart';
import 'custom_progress_indicator.dart';
import 'switch_card.dart';
import '../constants.dart';

class MyCard extends StatelessWidget {
  const MyCard({Key? key, required this.cardId, required this.cardType})
      : super(key: key);
  final String cardId;
  final CardType cardType;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('cards')
          .doc(cardId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('問題が発生しました');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CustomProgressIndicator();
        }

        dynamic data = snapshot.data;
        final account = data?['account'];

        return Theme(
          data: ThemeData(
            colorSchemeSeed: Color(returnOriginalColor(cardId)),
            brightness: currentBrightness(Theme.of(context).colorScheme) ==
                    Brightness.light
                ? Brightness.light
                : Brightness.dark,
          ),
          child: SwitchCard(
            cardId: cardId,
            cardType: cardType,
          ),
        );
      },
    );
  }
}
