import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thundercard/api/return_original_color.dart';
import 'package:thundercard/widgets/preview_card.dart';

import '../api/current_brightness.dart';
import '../api/settings/display_card_theme.dart';
import '../main.dart';
import 'custom_progress_indicator.dart';
import 'switch_card.dart';
import '../constants.dart';

class MyCard extends ConsumerWidget {
  const MyCard(
      {Key? key,
      required this.cardId,
      required this.cardType,
      this.light = true})
      : super(key: key);

  final String cardId;
  final CardType cardType;
  final bool light;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final displayCardTheme = ref.watch(displayCardThemeProvider);
    if (cardType == CardType.preview) {
      return Theme(
        data: ThemeData(
          colorSchemeSeed: Color(returnOriginalColor(cardId)),
          brightness: [
            light ? Brightness.light : Brightness.dark,
            currentBrightness(Theme.of(context).colorScheme) == Brightness.light
                ? Brightness.light
                : Brightness.dark,
            Brightness.dark,
            Brightness.light,
          ][displayCardTheme.currentDisplayCardThemeIdx],
        ),
        child: PreviewCard(cardId: cardId),
      );
    }
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
        late bool lightTheme;
        try {
          lightTheme = true;
          lightTheme = data?['thundercard']?['light_theme'];
        } catch (e) {
          debugPrint('$e');
        }

        return Theme(
          data: ThemeData(
            colorSchemeSeed: Color(returnOriginalColor(cardId)),
            brightness: [
              lightTheme ? Brightness.light : Brightness.dark,
              currentBrightness(Theme.of(context).colorScheme) ==
                      Brightness.light
                  ? Brightness.light
                  : Brightness.dark,
              Brightness.dark,
              Brightness.light,
            ][displayCardTheme.currentDisplayCardThemeIdx],
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
