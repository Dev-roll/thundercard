import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../main.dart';
import '../../providers/firebase_firestore.dart';
import '../../providers/index.dart';
import '../../utils/constants.dart';
import '../../utils/firebase_auth.dart';
import '../../utils/setSystemChrome.dart';
import '../widgets/card_info.dart';
import '../widgets/custom_progress_indicator.dart';
import '../widgets/error_message.dart';
import '../widgets/my_card.dart';
import 'auth_gate.dart';
import 'link_auth.dart';

class Account extends ConsumerWidget {
  const Account({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    setSystemChrome(context);

    final String? uid = getUid();
    final customTheme = ref.watch(customThemeProvider);
    final currentCardAsyncValue = ref.watch(currentCardStream);
    return currentCardAsyncValue.when(
      error: (err, _) => ErrorMessage(err: '$err'),
      loading: () => const Scaffold(
        body: SafeArea(
          child: Center(
            child: CustomProgressIndicator(),
          ),
        ),
      ),
      data: (currentCard) {
        final currentCardId = currentCard?['current_card'];
        return Scaffold(
          body: SafeArea(
            child: SizedBox(
              width: double.infinity,
              child: SingleChildScrollView(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 800,
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                          child:
                              CardInfo(cardId: currentCardId, editable: true),
                        ),
                        Divider(
                          height: 32,
                          thickness: 1,
                          indent: 16,
                          endIndent: 16,
                          color: Theme.of(context)
                              .colorScheme
                              .outline
                              .withOpacity(0.5),
                        ),
                        Container(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    '??????????????????',
                                    style:
                                        Theme.of(context).textTheme.titleLarge,
                                  ),
                                ],
                              ),
                              GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () async {
                                  await showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        icon: [
                                          const Icon(
                                              Icons.brightness_medium_rounded),
                                          const Icon(
                                              Icons.brightness_low_rounded),
                                          const Icon(
                                              Icons.brightness_high_rounded),
                                        ][customTheme.currentAppThemeIdx],
                                        title: const Text('?????????????????????'),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Divider(
                                              height: 16,
                                              thickness: 1,
                                              indent: 0,
                                              endIndent: 0,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .outline
                                                  .withOpacity(0.5),
                                            ),
                                            RadioListTile(
                                              title: const Text('??????????????????'),
                                              activeColor: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              value: 0,
                                              groupValue: customTheme
                                                  .currentAppThemeIdx,
                                              onChanged: (value) {
                                                customTheme.appThemeChange(
                                                    value as int);
                                              },
                                            ),
                                            RadioListTile(
                                              title: const Text('??????????????????'),
                                              activeColor: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              value: 1,
                                              groupValue: customTheme
                                                  .currentAppThemeIdx,
                                              onChanged: (value) {
                                                customTheme.appThemeChange(
                                                    value as int);
                                              },
                                            ),
                                            RadioListTile(
                                              title: const Text('??????????????????'),
                                              activeColor: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              value: 2,
                                              groupValue: customTheme
                                                  .currentAppThemeIdx,
                                              onChanged: (value) {
                                                customTheme.appThemeChange(
                                                    value as int);
                                              },
                                            ),
                                            Divider(
                                              height: 16,
                                              thickness: 1,
                                              indent: 0,
                                              endIndent: 0,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .outline
                                                  .withOpacity(0.5),
                                            ),
                                          ],
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('???????????????'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                              if (customTheme
                                                      .currentAppThemeIdx !=
                                                  customTheme.appThemeIdx) {
                                                customTheme.appThemeUpdate();
                                              }
                                            },
                                            child: const Text('??????'),
                                          ),
                                        ],
                                      );
                                    },
                                  ).then((value) {
                                    if (customTheme.currentAppThemeIdx !=
                                        customTheme.appThemeIdx) {
                                      customTheme.appThemeChange(
                                          customTheme.appThemeIdx);
                                    }
                                  });
                                },
                                child: Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(8, 20, 8, 8),
                                  child: Row(children: [
                                    [
                                      Icon(
                                        Icons.brightness_medium_rounded,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurfaceVariant,
                                      ),
                                      Icon(
                                        Icons.brightness_low_rounded,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurfaceVariant,
                                      ),
                                      Icon(
                                        Icons.brightness_high_rounded,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurfaceVariant,
                                      ),
                                    ][customTheme.currentAppThemeIdx],
                                    const SizedBox(width: 8),
                                    Text(
                                      '?????????????????????',
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurfaceVariant,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Container(
                                        alignment: Alignment.centerRight,
                                        child: [
                                          const Text(
                                            '??????????????????',
                                            softWrap: false,
                                            overflow: TextOverflow.fade,
                                          ),
                                          const Text(
                                            '??????????????????',
                                            softWrap: false,
                                            overflow: TextOverflow.fade,
                                          ),
                                          const Text(
                                            '??????????????????',
                                            softWrap: false,
                                            overflow: TextOverflow.fade,
                                          )
                                        ][customTheme.currentAppThemeIdx],
                                      ),
                                    )
                                  ]),
                                ),
                              ),
                              GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () async {
                                  await showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        icon: const Icon(
                                            Icons.settings_brightness_rounded),
                                        title: const Text('?????????????????????'),
                                        scrollable: true,
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Divider(
                                              height: 16,
                                              thickness: 1,
                                              indent: 0,
                                              endIndent: 0,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .outline
                                                  .withOpacity(0.5),
                                            ),
                                            Text(
                                              '????????????????????????',
                                              style: TextStyle(
                                                height: 1.6,
                                                fontSize: 12,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSurfaceVariant
                                                    .withOpacity(0.7),
                                              ),
                                            ),
                                            ConstrainedBox(
                                              constraints: const BoxConstraints(
                                                maxWidth: 400,
                                              ),
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        16, 8, 16, 8),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Flexible(
                                                      fit: FlexFit.tight,
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                0, 0, 4, 0),
                                                        child: const FittedBox(
                                                          child: MyCard(
                                                            cardId: 'Light',
                                                            cardType: CardType
                                                                .preview,
                                                            light: true,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Flexible(
                                                      fit: FlexFit.tight,
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                4, 0, 0, 0),
                                                        child: const FittedBox(
                                                          child: MyCard(
                                                            cardId: 'Dark',
                                                            cardType: CardType
                                                                .preview,
                                                            light: false,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Divider(
                                              height: 16,
                                              thickness: 1,
                                              indent: 0,
                                              endIndent: 0,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .outline
                                                  .withOpacity(0.5),
                                            ),
                                            Column(
                                              children: [
                                                RadioListTile(
                                                  title: const Text('???????????????'),
                                                  subtitle: Text(
                                                    '?????????????????????????????????????????????',
                                                    style: TextStyle(
                                                      height: 1.6,
                                                      fontSize: 12,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .onSurfaceVariant
                                                          .withOpacity(0.7),
                                                    ),
                                                  ),
                                                  activeColor: Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                                  value: 0,
                                                  groupValue: customTheme
                                                      .currentDisplayCardThemeIdx,
                                                  onChanged: (value) {
                                                    customTheme.cardThemeChange(
                                                        value as int);
                                                  },
                                                ),
                                                RadioListTile(
                                                  title: const Text('??????????????????'),
                                                  subtitle: Text(
                                                    '????????????????????????????????????????????????',
                                                    style: TextStyle(
                                                      height: 1.6,
                                                      fontSize: 12,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .onSurfaceVariant
                                                          .withOpacity(0.7),
                                                    ),
                                                  ),
                                                  activeColor: Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                                  value: 1,
                                                  groupValue: customTheme
                                                      .currentDisplayCardThemeIdx,
                                                  onChanged: (value) {
                                                    customTheme.cardThemeChange(
                                                        value as int);
                                                  },
                                                ),
                                                RadioListTile(
                                                  title: const Text('??????????????????'),
                                                  subtitle: Text(
                                                    '???????????????????????????????????????',
                                                    style: TextStyle(
                                                      height: 1.6,
                                                      fontSize: 12,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .onSurfaceVariant
                                                          .withOpacity(0.7),
                                                    ),
                                                  ),
                                                  activeColor: Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                                  value: 2,
                                                  groupValue: customTheme
                                                      .currentDisplayCardThemeIdx,
                                                  onChanged: (value) {
                                                    customTheme.cardThemeChange(
                                                        value as int);
                                                  },
                                                ),
                                                RadioListTile(
                                                  title: const Text('??????????????????'),
                                                  subtitle: Text(
                                                    '???????????????????????????????????????',
                                                    style: TextStyle(
                                                      height: 1.6,
                                                      fontSize: 12,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .onSurfaceVariant
                                                          .withOpacity(0.7),
                                                    ),
                                                  ),
                                                  activeColor: Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                                  value: 3,
                                                  groupValue: customTheme
                                                      .currentDisplayCardThemeIdx,
                                                  onChanged: (value) {
                                                    customTheme.cardThemeChange(
                                                        value as int);
                                                  },
                                                ),
                                              ],
                                            ),
                                            Divider(
                                              height: 16,
                                              thickness: 1,
                                              indent: 0,
                                              endIndent: 0,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .outline
                                                  .withOpacity(0.5),
                                            ),
                                          ],
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('???????????????'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                              if (customTheme
                                                      .currentDisplayCardThemeIdx !=
                                                  customTheme
                                                      .displayCardThemeIdx) {
                                                customTheme.cardThemeUpdate();
                                              }
                                            },
                                            child: const Text('??????'),
                                          )
                                        ],
                                      );
                                    },
                                  ).then((value) {
                                    if (customTheme
                                            .currentDisplayCardThemeIdx !=
                                        customTheme.displayCardThemeIdx) {
                                      customTheme.cardThemeChange(
                                          customTheme.displayCardThemeIdx);
                                    }
                                  });
                                },
                                child: Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(8, 20, 8, 8),
                                  child: Row(children: [
                                    Icon(
                                      Icons.settings_brightness_rounded,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      '?????????????????????',
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurfaceVariant,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Container(
                                        alignment: Alignment.centerRight,
                                        child: [
                                          const Text(
                                            '???????????????',
                                            softWrap: false,
                                            overflow: TextOverflow.fade,
                                          ),
                                          const Text(
                                            '??????????????????',
                                            softWrap: false,
                                            overflow: TextOverflow.fade,
                                          ),
                                          const Text(
                                            '??????????????????',
                                            softWrap: false,
                                            overflow: TextOverflow.fade,
                                          ),
                                          const Text(
                                            '??????????????????',
                                            softWrap: false,
                                            overflow: TextOverflow.fade,
                                          )
                                        ][customTheme
                                            .currentDisplayCardThemeIdx],
                                      ),
                                    )
                                  ]),
                                ),
                              ),
                            ],
                          ),
                        ),

                        Divider(
                          height: 32,
                          thickness: 1,
                          indent: 16,
                          endIndent: 16,
                          color: Theme.of(context)
                              .colorScheme
                              .outline
                              .withOpacity(0.5),
                        ),
                        Container(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    '????????????',
                                    style:
                                        Theme.of(context).textTheme.titleLarge,
                                  ),
                                ],
                              ),
                              // Container(
                              //   padding: EdgeInsets.fromLTRB(8, 20, 8, 8),
                              //   child: Row(children: [
                              //     Icon(
                              //       Icons.lock_rounded,
                              //       color:
                              //           Theme.of(context).colorScheme.onSurfaceVariant,
                              //     ),
                              //     SizedBox(
                              //       width: 8,
                              //     ),
                              //     Text(
                              //       '??????????????????',
                              //       style: TextStyle(
                              //         color: Theme.of(context)
                              //             .colorScheme
                              //             .onSurfaceVariant,
                              //       ),
                              //     ),
                              //   ]),
                              // ),
                              Container(
                                padding: const EdgeInsets.fromLTRB(8, 20, 8, 8),
                                alignment: Alignment.center,
                                child: ElevatedButton.icon(
                                  icon: const Icon(
                                    Icons.add_circle_outline_rounded,
                                  ),
                                  label: const Text('?????????????????????'),
                                  style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    foregroundColor: Theme.of(context)
                                        .colorScheme
                                        .onSecondaryContainer,
                                    backgroundColor: Theme.of(context)
                                        .colorScheme
                                        .secondaryContainer,
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => const LinkAuth(),
                                      ),
                                    );
                                  },
                                  onLongPress: null,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          height: 32,
                          thickness: 1,
                          indent: 16,
                          endIndent: 16,
                          color: Theme.of(context)
                              .colorScheme
                              .outline
                              .withOpacity(0.5),
                        ),
                        Container(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '????????????????????????',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              Container(
                                padding: const EdgeInsets.fromLTRB(8, 20, 8, 8),
                                alignment: Alignment.center,
                                child: Column(
                                  children: [
                                    // ElevatedButton.icon(
                                    //   icon: const Icon(
                                    //     Icons.save_alt_rounded,
                                    //   ),
                                    //   label: const Text('???????????????????????????'),
                                    //   style: ElevatedButton.styleFrom(
                                    //     elevation: 0,
                                    //     foregroundColor: Theme.of(context)
                                    //         .colorScheme
                                    //         .onSecondaryContainer,
                                    //     backgroundColor: Theme.of(context)
                                    //         .colorScheme
                                    //         .secondaryContainer,
                                    //   ),
                                    //   onPressed: () async {
                                    //     final path =
                                    //         await getApplicationDocumentsDirectory()
                                    //             .then((value) => value.path);
                                    //     Share.shareFiles(
                                    //       [
                                    //         '$path/appThemeIdx.txt',
                                    //       ],
                                    //       text: 'username????????????',
                                    //       subject: 'username???????????????????????????',
                                    //     );
                                    //   },
                                    //   onLongPress: null,
                                    // ),
                                    ElevatedButton.icon(
                                      icon: const Icon(
                                        Icons.share_rounded,
                                      ),
                                      label: const Text('??????????????????'),
                                      style: ElevatedButton.styleFrom(
                                        elevation: 0,
                                        foregroundColor: Theme.of(context)
                                            .colorScheme
                                            .onSecondaryContainer,
                                        backgroundColor: Theme.of(context)
                                            .colorScheme
                                            .secondaryContainer,
                                      ),
                                      onPressed: () async {
                                        final path =
                                            await getApplicationDocumentsDirectory()
                                                .then((value) => value.path);
                                        Share.shareXFiles(
                                          [
                                            // '$path/list.txt',
                                            XFile('$path/appThemeIdx.txt'),
                                            XFile(
                                                '$path/displayCardThemeIdx.txt'),
                                          ],
                                          text: 'Thundercard?????????????????????',
                                          subject: 'Thundercard???????????????????????????',
                                        );
                                      },
                                      onLongPress: null,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          height: 32,
                          thickness: 1,
                          indent: 16,
                          endIndent: 16,
                          color: Theme.of(context)
                              .colorScheme
                              .outline
                              .withOpacity(0.5),
                        ),
                        Container(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '?????????',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              Container(
                                padding: const EdgeInsets.fromLTRB(8, 20, 8, 8),
                                alignment: Alignment.center,
                                child: Column(
                                  children: [
                                    ElevatedButton.icon(
                                      icon: const Icon(
                                        Icons.logout_rounded,
                                      ),
                                      label: const Text('??????????????????'),
                                      style: ElevatedButton.styleFrom(
                                        elevation: 0,
                                        foregroundColor: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                        backgroundColor: Theme.of(context)
                                            .colorScheme
                                            .background,
                                      ),
                                      onPressed: () async {
                                        await showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            icon: const Icon(
                                                Icons.logout_rounded),
                                            title: const Text('??????????????????'),
                                            content: Text(
                                              '????????????????????????????????????????????????????????????',
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSurfaceVariant,
                                              ),
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context, false);
                                                },
                                                onLongPress: null,
                                                child: const Text('???????????????'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                  FirebaseAuth.instance
                                                      .signOut();
                                                  Navigator.of(context)
                                                      .pushAndRemoveUntil(
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          AuthGate(),
                                                    ),
                                                    (_) => false,
                                                  );
                                                  ref
                                                      .watch(
                                                          currentIndexProvider
                                                              .notifier)
                                                      .state = 0;
                                                },
                                                onLongPress: null,
                                                child: const Text('??????????????????'),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                      onLongPress: null,
                                    ),
                                    const SizedBox(height: 28),
                                    ElevatedButton.icon(
                                      icon: const Icon(
                                        Icons.person_off_rounded,
                                      ),
                                      label: const Text('????????????????????????'),
                                      style: ElevatedButton.styleFrom(
                                        elevation: 0,
                                        foregroundColor:
                                            Theme.of(context).colorScheme.error,
                                        backgroundColor: Theme.of(context)
                                            .colorScheme
                                            .background,
                                      ),
                                      onPressed: () async {
                                        await showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            icon: const Icon(
                                                Icons.person_off_rounded),
                                            title: const Text('????????????????????????'),
                                            content: Text(
                                              '?????????????????????????????????????????????',
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSurfaceVariant,
                                              ),
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context, false);
                                                },
                                                onLongPress: null,
                                                child: const Text('???????????????'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                  FirebaseAuth.instance
                                                      .signOut();
                                                  Navigator.of(context)
                                                      .pushAndRemoveUntil(
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          AuthGate(),
                                                    ),
                                                    (_) => false,
                                                  );
                                                  ref
                                                      .watch(
                                                          currentIndexProvider
                                                              .notifier)
                                                      .state = 0;
                                                  final data = {
                                                    'uid': uid,
                                                    'createdAt':
                                                        Timestamp.now(),
                                                  };
                                                  FirebaseFirestore.instance
                                                      .collection(
                                                          'deleted_users')
                                                      .add(data)
                                                      .then((value) {
                                                        FirebaseAuth.instance
                                                            .signOut();
                                                      })
                                                      .then((_) {})
                                                      .catchError((e) {
                                                        debugPrint(
                                                            'Failed to delete user: $e');
                                                      });
                                                },
                                                onLongPress: null,
                                                child: Text(
                                                  '????????????????????????',
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .error),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                      onLongPress: null,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        // ??????????????????
                        // const SizedBox(height: 28),
                        // const OutlinedButton(
                        //   onPressed: maintenance,
                        //   onLongPress: null,
                        //   child: Text('????????????'),
                        // ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          // floatingActionButton: ElevatedButton.icon(
          //   onPressed: () {
          //     maintenance();
          //   },
          //   icon: const Icon(
          //     Icons.qr_code_scanner_rounded,
          //     size: 26,
          //   ),
          //   label: const Text(
          //     '????????????',
          //     style: TextStyle(fontSize: 16),
          //   ),
          //   style: ElevatedButton.styleFrom(
          //     elevation: 0,
          //     foregroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
          //     backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
          //   ),
          // ),
          // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        );
      },
    );
  }
}
