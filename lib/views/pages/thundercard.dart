import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:share_plus/share_plus.dart';
import 'package:thundercard/providers/current_card_id_provider.dart';
import 'package:thundercard/providers/dynamic_links_provider.dart';
import 'package:thundercard/utils/constants.dart';
import 'package:thundercard/utils/current_brightness.dart';
import 'package:thundercard/utils/export_to_image.dart';
import 'package:thundercard/utils/firebase_auth.dart';
import 'package:thundercard/utils/get_application_documents_file.dart';
import 'package:thundercard/utils/return_original_color.dart';
import 'package:thundercard/views/pages/exchange_card.dart';
import 'package:thundercard/views/pages/home_page.dart';
import 'package:thundercard/views/pages/my_card_details.dart';
import 'package:thundercard/views/widgets/custom_progress_indicator.dart';
import 'package:thundercard/views/widgets/my_card.dart';
import 'package:thundercard/views/widgets/notification_item.dart';
import 'package:thundercard/views/widgets/positioned_snack_bar.dart';

class Thundercard extends ConsumerStatefulWidget {
  const Thundercard({Key? key}) : super(key: key);

  @override
  ConsumerState<Thundercard> createState() => _ThundercardState();
}

class _ThundercardState extends ConsumerState<Thundercard> {
  final String? uid = getUid();
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  final GlobalKey _myCardKey = GlobalKey();
  var myCardId = '';

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    final iconColorNum = Theme.of(context)
        .colorScheme
        .onBackground
        .value
        .toRadixString(16)
        .substring(2);

    final dynamicLink = ref.watch(dynamicLinkProvider(myCardId));
    final String dynamicLinksValue = dynamicLink.when(
      data: (data) => data.shortUrl.toString(), // データを表示
      loading: () => '',
      error: (err, stack) => err.toString(),
    );

    myCardId = ref.watch(currentCardIdProvider);
    // String thunderCardUrl =
    //     'https://thundercard-test.web.app/?card_id=$myCardId';
    // 'thundercard://user?card_id=$myCardId';
    Color myPrimary = ColorScheme.fromSeed(
      seedColor: Color(returnOriginalColor(myCardId)),
      brightness: currentBrightness(Theme.of(context).colorScheme),
    ).primary;
    Color myPrimaryContainer = ColorScheme.fromSeed(
      seedColor: Color(returnOriginalColor(myCardId)),
      brightness: currentBrightness(Theme.of(context).colorScheme),
    ).primaryContainer;
    // Color myPrimary = Theme.of(context).colorScheme.primary;
    // Color myPrimaryContainer =
    //     Theme.of(context).colorScheme.primaryContainer;

    return Scaffold(
      body: Column(
        children: [
          AppBar(
            leading: IconButton(
              onPressed: () {
                drawerKey.currentState!.openDrawer();
              },
              icon: const Icon(Icons.menu_rounded),
            ),
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.string(
                  '<svg width="400" height="400" viewBox="0 0 400 400" fill="#$iconColorNum" xmlns="http://www.w3.org/2000/svg"><path d="M193.367 13.2669C197.432 5.13606 205.742 0 214.833 0H260.584C269.504 0 275.306 9.38775 271.317 17.3666L174.633 210.733C170.568 218.864 162.258 224 153.167 224H107.416C98.4958 224 92.6939 214.612 96.6833 206.633L193.367 13.2669Z"/><path d="M225.367 189.267C229.432 181.136 237.742 176 246.833 176H292.584C301.504 176 307.306 185.388 303.317 193.367L206.633 386.733C202.568 394.864 194.258 400 185.167 400H139.416C130.496 400 124.694 390.612 128.683 382.633L225.367 189.267Z"/></svg>',
                  width: 18,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Thundercard',
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
            centerTitle: true,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: SizedBox(
                width: double.infinity,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 800,
                  ),
                  child: Container(
                    alignment: Alignment.topCenter,
                    padding: const EdgeInsets.fromLTRB(16, 32, 16, 100),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              0.03 * MediaQuery.of(context).size.width,
                            ),
                            boxShadow: currentBrightness(
                                      Theme.of(context).colorScheme,
                                    ) ==
                                    Brightness.light
                                ? [
                                    BoxShadow(
                                      color: myPrimary.withOpacity(0.1),
                                      blurRadius: 8,
                                      spreadRadius: 0,
                                    ),
                                    BoxShadow(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground
                                          .withOpacity(0.25),
                                      blurRadius: 20,
                                      spreadRadius: 0,
                                    ),
                                    BoxShadow(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground
                                          .withOpacity(0.25),
                                      blurRadius: 60,
                                      spreadRadius: 0,
                                    ),
                                  ]
                                : [
                                    BoxShadow(
                                      color: myPrimary.withOpacity(0.08),
                                      blurRadius: 20,
                                      spreadRadius: 8,
                                    ),
                                    BoxShadow(
                                      color:
                                          myPrimaryContainer.withOpacity(0.15),
                                      blurRadius: 20,
                                      spreadRadius: 8,
                                    ),
                                  ],
                          ),
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => MyCardDetails(
                                    cardId: myCardId,
                                  ),
                                ),
                              );
                            },
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(
                                maxHeight: 400,
                              ),
                              child: FittedBox(
                                child: RepaintBoundary(
                                  key: _myCardKey,
                                  child: MyCard(
                                    cardId: myCardId,
                                    cardType: CardType.normal,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxWidth: 660,
                          ),
                          child: Container(
                            margin: const EdgeInsets.fromLTRB(8, 16, 8, 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                  child: IconButton(
                                    onPressed: () async {
                                      final bytes =
                                          await exportToImage(_myCardKey);
                                      //byte data→Uint8List
                                      final widgetImageBytes =
                                          bytes?.buffer.asUint8List(
                                        bytes.offsetInBytes,
                                        bytes.lengthInBytes,
                                      );
                                      //App directoryファイルに保存
                                      final applicationDocumentsFile =
                                          await getApplicationDocumentsFile(
                                        myCardId,
                                        widgetImageBytes!,
                                      );

                                      final path =
                                          applicationDocumentsFile.path;
                                      await Share.shareXFiles(
                                        [
                                          XFile(path),
                                        ],
                                        text: dynamicLinksValue,
                                        subject: '$myCardIdさんのThundercardの共有',
                                      );
                                      debugPrint(dynamicLinksValue);
                                      await applicationDocumentsFile.delete();
                                    },
                                    icon: const Icon(Icons.share_rounded),
                                    padding: const EdgeInsets.all(20),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                  child: IconButton(
                                    onPressed: () {
                                      //byte data→Uint8List
                                      exportToImage(_myCardKey)
                                          .then(
                                            (bytes) =>
                                                bytes?.buffer.asUint8List(
                                              bytes.offsetInBytes,
                                              bytes.lengthInBytes,
                                            ),
                                          )
                                          .then(
                                            (widgetImageBytes) =>
                                                ImageGallerySaver.saveImage(
                                              widgetImageBytes!,
                                              name: myCardId,
                                            ),
                                          )
                                          .then(
                                            (value) =>
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                              PositionedSnackBar(
                                                context,
                                                'カードをダウンロードしました',
                                                icon: Icons
                                                    .file_download_done_rounded,
                                              ),
                                            ),
                                          );
                                    },
                                    icon: const Icon(Icons.save_alt_rounded),
                                    padding: const EdgeInsets.all(20),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                  child: IconButton(
                                    onPressed: () async {
                                      await Clipboard.setData(
                                        ClipboardData(text: dynamicLinksValue),
                                      ).then(
                                        (value) {
                                          debugPrint(dynamicLinksValue);
                                          return ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            PositionedSnackBar(
                                              context,
                                              'クリップボードにコピーしました',
                                              icon: Icons
                                                  .library_add_check_rounded,
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    icon: const Icon(Icons.copy_rounded),
                                    padding: const EdgeInsets.all(20),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('version')
                              .doc('2')
                              .collection('cards')
                              .doc(myCardId)
                              .collection('visibility')
                              .doc('c10r10u10d10')
                              .collection('notifications')
                              .orderBy('read')
                              .orderBy('created_at', descending: true)
                              .limit(2)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              debugPrint('${snapshot.error}');
                              return Text('エラーが発生しました: ${snapshot.error}');
                            }

                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CustomProgressIndicator();
                            }

                            if (!snapshot.hasData) {
                              return const Text('通知の取得に失敗しました');
                            }

                            dynamic data = snapshot.data;
                            final interactions = data?.docs;
                            final interactionsLength = interactions.length;

                            return (interactionsLength != 0)
                                ? SingleChildScrollView(
                                    child: Container(
                                      padding: const EdgeInsets.fromLTRB(
                                        0,
                                        12,
                                        0,
                                        16,
                                      ),
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            ListView.builder(
                                              shrinkWrap: true,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              itemCount: interactionsLength,
                                              itemBuilder: (context, index) {
                                                DateTime time =
                                                    interactions[index]
                                                            ['created_at']
                                                        .toDate();
                                                return Center(
                                                  child: NotificationItem(
                                                    title: interactions[index]
                                                        ['title'],
                                                    content: interactions[index]
                                                        ['content'],
                                                    createdAt: time.toString(),
                                                    read: interactions[index]
                                                        ['read'],
                                                    index: 0,
                                                    myCardId: myCardId,
                                                    tags: interactions[index]
                                                        ['tags'],
                                                    notificationId:
                                                        interactions[index]
                                                            ['notification_id'],
                                                    documentId:
                                                        interactions[index].id,
                                                  ),
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                : Center(
                                    child: Card(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .surfaceVariant
                                          .withOpacity(0.5),
                                      child: SizedBox(
                                        width:
                                            min(screenSize.width * 0.91, 800),
                                        height: 160,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons
                                                  .notifications_paused_rounded,
                                              size: 80,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onBackground
                                                  .withOpacity(0.3),
                                            ),
                                            const SizedBox(height: 12),
                                            Text(
                                              'まだ通知はありません',
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSurfaceVariant,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: ElevatedButton.icon(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => Theme(
                data: ThemeData(
                  colorScheme: Theme.of(context).colorScheme.brightness ==
                          Brightness.dark
                      ? Theme.of(context).colorScheme
                      : ColorScheme.fromSeed(
                          seedColor: Theme.of(context).colorScheme.primary,
                          brightness: Brightness.dark,
                        ),
                  useMaterial3: true,
                ),
                child: ExchangeCard(currentCardId: myCardId),
              ),
            ),
          );
        },
        icon: const Icon(
          Icons.swap_horiz_rounded,
          size: 26,
        ),
        label: const Text(
          'カードを交換',
          style: TextStyle(fontSize: 16),
        ),
        style: ElevatedButton.styleFrom(
          elevation: 0,
          fixedSize:
              Size(min(MediaQuery.of(context).size.width * 0.7, 400), 56),
          foregroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
          backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
