// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thundercard/api/current_brightness.dart';
import 'package:thundercard/widgets/avatar.dart';
import 'package:thundercard/widgets/custom_skeletons/skeleton_card_info.dart';

import '../api/provider/firebase_firestore.dart';
import '../api/return_original_color.dart';
import '../account_editor.dart';
import '../constants.dart';

class CardInfo extends ConsumerWidget {
  const CardInfo({
    Key? key,
    required this.cardId,
    required this.editable,
    this.isUser = true,
  }) : super(key: key);
  final String cardId;
  final bool editable;
  final bool isUser;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // CollectionReference cards = FirebaseFirestore.instance.collection('cards');
    // var screenSize = MediaQuery.of(context).size;
    // var vw = screenSize.width * 0.01;
    // final FutureProvider c10r21u10d10Provider =
    //     FutureProvider<dynamic>((ref) async {
    //   final prefs = await FirebaseFirestore.instance
    //       .collection('version')
    //       .doc('2')
    //       .collection('cards')
    //       .doc(cardId)
    //       .collection('visibility')
    //       .doc('c10r21u10d10')
    //       .get();
    //   return prefs.data();
    // });

    // final _ = ref.refresh(c10r21u10d10Provider);
    final c10r21u10d10AsyncValue = ref.watch(c10r21u10d10Stream(cardId));

    return c10r21u10d10AsyncValue.when(
      error: (err, _) => Scaffold(
        body: SafeArea(
          child: Center(
            child: Text(
              '$err',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ),
      ),
      loading: () => const Scaffold(
        body: SafeArea(
          child: Center(
            child: SkeletonCardInfo(),
          ),
        ),
      ),
      data: (c10r21u10d10) {
        final c10r20u10d10AsyncValue = ref.watch(c10r20u10d10Stream(cardId));
        return c10r20u10d10AsyncValue.when(
          error: (err, _) => Scaffold(
            body: SafeArea(
              child: Center(
                child: Text(
                  '$err',
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
            ),
          ),
          loading: () => const Scaffold(
            body: SafeArea(
              child: Center(
                child: SkeletonCardInfo(),
              ),
            ),
          ),
          data: (c10r20u10d10) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Theme(
                      data: ThemeData(
                        colorSchemeSeed: Color(returnOriginalColor(cardId)),
                        brightness:
                            currentBrightness(Theme.of(context).colorScheme) ==
                                    Brightness.light
                                ? Brightness.light
                                : Brightness.dark,
                        useMaterial3: true,
                      ),
                      child: const SizedBox(
                        width: 68,
                        height: 68,
                        child: FittedBox(child: Avatar()),
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  '${c10r20u10d10?['name']}',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  softWrap: false,
                                  overflow: TextOverflow.fade,
                                ),
                              ),
                            ],
                          ),
                          if (isUser)
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    '@$cardId',
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground
                                          .withOpacity(0.7),
                                    ),
                                    softWrap: false,
                                    overflow: TextOverflow.fade,
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                    if (editable)
                      Container(
                        margin: const EdgeInsets.only(left: 8),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  AccountEditor(cardId: cardId),
                            ));
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            foregroundColor: Theme.of(context)
                                .colorScheme
                                .onSecondaryContainer,
                            backgroundColor: Theme.of(context)
                                .colorScheme
                                .secondaryContainer,
                            padding: const EdgeInsets.all(8),
                          ),
                          child: const Icon(Icons.edit_rounded),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                  child: Column(
                    children: [
                      const SizedBox(height: 8),
                      if (c10r21u10d10?['profiles']['company']['value'] != '')
                        Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.only(top: 1),
                                child: Icon(
                                  iconTypeToIconData[
                                      linkTypeToIconType['company']],
                                  size: 18,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground
                                      .withOpacity(0.7),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  '${c10r21u10d10?['profiles']['company']['value']}',
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (c10r21u10d10?['profiles']['position']['value'] != '')
                        Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.only(top: 1),
                                child: Icon(
                                  iconTypeToIconData[
                                      linkTypeToIconType['position']],
                                  size: 18,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground
                                      .withOpacity(0.7),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  '${c10r21u10d10?['profiles']['position']['value']}',
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (c10r21u10d10?['profiles']['address']['value'] != '')
                        Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.only(top: 1),
                                child: Icon(
                                  iconTypeToIconData[
                                      linkTypeToIconType['address']],
                                  size: 18,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground
                                      .withOpacity(0.7),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  '${c10r21u10d10?['profiles']['address']['value']}',
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (c10r21u10d10?['profiles']['bio']['value'] != '')
                        Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.only(top: 1),
                                child: Icon(
                                  iconTypeToIconData[linkTypeToIconType['bio']],
                                  size: 18,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground
                                      .withOpacity(0.7),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  '${c10r21u10d10?['profiles']['bio']['value']}',
                                ),
                              ),
                            ],
                          ),
                        ),
                      // if (c10r21u10d10?['profiles']['bio']['value'] != '')
                      //   Container(
                      //     // padding: EdgeInsets.all(16),
                      //     width: double.infinity,
                      //     decoration: BoxDecoration(
                      //         // borderRadius: BorderRadius.circular(8),
                      //         // color: Theme.of(context)
                      //         //     .colorScheme
                      //         //     .primary
                      //         //     .withOpacity(0.08),
                      //         ),
                      //     child: Flexible(
                      //       child: Text(
                      //         '${c10r21u10d10?['profiles']['bio']['value']}',
                      //       ),
                      //     ),
                      //   ),
                      // icons
                      // SizedBox(
                      //   height: 32,
                      // ),
                      Column(
                        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          for (var i = 0;
                              i < c10r21u10d10?['account']['links'].length;
                              i++)
                            Container(
                              margin: const EdgeInsets.only(bottom: 20),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.only(top: 1),
                                    child: Icon(
                                      iconTypeToIconData[linkTypeToIconType[
                                          c10r21u10d10?['account']['links'][i]
                                              ['key']]],
                                      size: 18,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground
                                          .withOpacity(0.7),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      '${c10r21u10d10?['account']['links'][i]['value']}',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
