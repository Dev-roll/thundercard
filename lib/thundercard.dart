import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:share_plus/share_plus.dart';
import 'package:thundercard/api/current_brightness.dart';
import 'package:thundercard/api/return_original_color.dart';
import 'package:thundercard/my_card_details.dart';

import 'api/colors.dart';
import 'api/export_to_image.dart';
import 'api/firebase_auth.dart';
import 'api/get_application_documents_file.dart';
import 'home_page.dart';
import 'widgets/custom_progress_indicator.dart';
import 'widgets/my_card.dart';
import 'widgets/scan_qr_code.dart';
import 'constants.dart';

class Thundercard extends StatefulWidget {
  const Thundercard({Key? key}) : super(key: key);

  @override
  State<Thundercard> createState() => _ThundercardState();
}

class _ThundercardState extends State<Thundercard> {
  final String? uid = getUid();
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  final GlobalKey _myCardKey = GlobalKey();
  var myCardId = '';

  @override
  Widget build(BuildContext context) {
    final iconColorNum = Theme.of(context)
        .colorScheme
        .onBackground
        .value
        .toRadixString(16)
        .substring(2);

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor: alphaBlend(
            Theme.of(context).colorScheme.primary.withOpacity(0.08),
            Theme.of(context).colorScheme.surface),
        statusBarIconBrightness:
            Theme.of(context).colorScheme.background.computeLuminance() < 0.5
                ? Brightness.light
                : Brightness.dark,
        statusBarBrightness:
            Theme.of(context).colorScheme.background.computeLuminance() < 0.5
                ? Brightness.dark
                : Brightness.light,
        statusBarColor: Colors.transparent,
      ),
    );

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            AppBar(
              // backgroundColor: alphaBlend(
              //     Theme.of(context).colorScheme.primary.withOpacity(0.08),
              //     Theme.of(context).colorScheme.surface),
              // systemOverlayStyle: SystemUiOverlayStyle(
              //   systemNavigationBarColor: alphaBlend(
              //       Theme.of(context).colorScheme.primary.withOpacity(0.08),
              //       Theme.of(context).colorScheme.surface),
              //   statusBarColor: Colors.transparent,
              // ),
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
              child: Center(
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
                        child: FutureBuilder(
                          future: users
                              .doc(uid)
                              .collection('card')
                              .doc('current_card')
                              .get(),
                          builder: (BuildContext context,
                              AsyncSnapshot<DocumentSnapshot> snapshot) {
                            if (snapshot.hasError) {
                              return const Text('問題が発生しました');
                            }
                            if (snapshot.hasData && !snapshot.data!.exists) {
                              return Text(
                                'ユーザー情報の取得に失敗しました',
                                style: TextStyle(
                                    color: Theme.of(context).colorScheme.error),
                              );
                            }
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              Map<String, dynamic> currentCard =
                                  snapshot.data!.data() as Map<String, dynamic>;
                              myCardId = currentCard['current_card'];
                              String thunderCardUrl =
                                  'https://thundercard-test.web.app/?card_id=$myCardId';
                              // 'thundercard://user?card_id=$myCardId';
                              Color myPrimary = ColorScheme.fromSeed(
                                seedColor: Color(returnOriginalColor(myCardId)),
                                brightness: currentBrightness(
                                    Theme.of(context).colorScheme),
                              ).primary;
                              Color myPrimaryContainer = ColorScheme.fromSeed(
                                seedColor: Color(returnOriginalColor(myCardId)),
                                brightness: currentBrightness(
                                    Theme.of(context).colorScheme),
                              ).primaryContainer;
                              // Color myPrimary = Theme.of(context).colorScheme.primary;
                              // Color myPrimaryContainer =
                              //     Theme.of(context).colorScheme.primaryContainer;
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(0.03 *
                                          MediaQuery.of(context).size.width),
                                      boxShadow: currentBrightness(
                                                  Theme.of(context)
                                                      .colorScheme) ==
                                              Brightness.light
                                          ? [
                                              BoxShadow(
                                                color:
                                                    myPrimary.withOpacity(0.1),
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
                                                color:
                                                    myPrimary.withOpacity(0.08),
                                                blurRadius: 20,
                                                spreadRadius: 8,
                                              ),
                                              BoxShadow(
                                                color: myPrimaryContainer
                                                    .withOpacity(0.15),
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
                                      margin: const EdgeInsets.fromLTRB(
                                          8, 16, 8, 16),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                20, 0, 20, 0),
                                            child: IconButton(
                                              onPressed: () async {
                                                final bytes =
                                                    await exportToImage(
                                                        _myCardKey);
                                                //byte data→Uint8List
                                                final widgetImageBytes =
                                                    bytes?.buffer.asUint8List(
                                                        bytes.offsetInBytes,
                                                        bytes.lengthInBytes);
                                                //App directoryファイルに保存
                                                final applicationDocumentsFile =
                                                    await getApplicationDocumentsFile(
                                                        myCardId,
                                                        widgetImageBytes!);

                                                final path =
                                                    applicationDocumentsFile
                                                        .path;
                                                await Share.shareFiles(
                                                  [
                                                    path,
                                                  ],
                                                  text: thunderCardUrl,
                                                  subject:
                                                      '$myCardIdさんのThundercardの共有',
                                                );
                                                applicationDocumentsFile
                                                    .delete();
                                              },
                                              icon: const Icon(
                                                  Icons.share_rounded),
                                              padding: const EdgeInsets.all(20),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                20, 0, 20, 0),
                                            child: IconButton(
                                              onPressed: () {
                                                //byte data→Uint8List
                                                exportToImage(_myCardKey)
                                                    .then(
                                                      (bytes) => bytes?.buffer
                                                          .asUint8List(
                                                        bytes.offsetInBytes,
                                                        bytes.lengthInBytes,
                                                      ),
                                                    )
                                                    .then(
                                                      (widgetImageBytes) =>
                                                          ImageGallerySaver
                                                              .saveImage(
                                                        widgetImageBytes!,
                                                        name: myCardId,
                                                      ),
                                                    )
                                                    .then(
                                                      (value) =>
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                        SnackBar(
                                                          elevation: 20,
                                                          backgroundColor: Theme
                                                                  .of(context)
                                                              .colorScheme
                                                              .surfaceVariant,
                                                          behavior:
                                                              SnackBarBehavior
                                                                  .floating,
                                                          clipBehavior:
                                                              Clip.antiAlias,
                                                          dismissDirection:
                                                              DismissDirection
                                                                  .horizontal,
                                                          margin:
                                                              EdgeInsets.only(
                                                            left: 8,
                                                            right: 8,
                                                            bottom: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height -
                                                                180,
                                                          ),
                                                          duration:
                                                              const Duration(
                                                                  seconds: 2),
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        28),
                                                          ),
                                                          content: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              const Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .fromLTRB(
                                                                            0,
                                                                            0,
                                                                            16,
                                                                            0),
                                                                child: Icon(Icons
                                                                    .file_download_done_rounded),
                                                              ),
                                                              Expanded(
                                                                child: Text(
                                                                  'カードをダウンロードしました',
                                                                  style: TextStyle(
                                                                      color: Theme.of(
                                                                              context)
                                                                          .colorScheme
                                                                          .onBackground,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .fade),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          // duration: const Duration(seconds: 12),
                                                          action:
                                                              SnackBarAction(
                                                            label: 'OK',
                                                            onPressed: () {},
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                              },
                                              icon: const Icon(
                                                  Icons.save_alt_rounded),
                                              padding: const EdgeInsets.all(20),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                20, 0, 20, 0),
                                            child: IconButton(
                                              onPressed: () async {
                                                await Clipboard.setData(
                                                  ClipboardData(
                                                      text: thunderCardUrl),
                                                ).then(
                                                  (value) =>
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                    SnackBar(
                                                      elevation: 20,
                                                      backgroundColor:
                                                          Theme.of(context)
                                                              .colorScheme
                                                              .surfaceVariant,
                                                      behavior: SnackBarBehavior
                                                          .floating,
                                                      clipBehavior:
                                                          Clip.antiAlias,
                                                      dismissDirection:
                                                          DismissDirection
                                                              .horizontal,
                                                      margin: EdgeInsets.only(
                                                        left: 8,
                                                        right: 8,
                                                        bottom: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height -
                                                            180,
                                                      ),
                                                      duration: const Duration(
                                                          seconds: 2),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(28),
                                                      ),
                                                      content: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          const Padding(
                                                            padding: EdgeInsets
                                                                .fromLTRB(0, 0,
                                                                    16, 0),
                                                            child: Icon(Icons
                                                                .library_add_check_rounded),
                                                          ),
                                                          Expanded(
                                                            child: Text(
                                                              'クリップボードにコピーしました',
                                                              style: TextStyle(
                                                                  color: Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .onBackground,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .fade),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      action: SnackBarAction(
                                                        label: 'OK',
                                                        onPressed: () {},
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                              icon: const Icon(
                                                  Icons.copy_rounded),
                                              padding: const EdgeInsets.all(20),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }
                            return const CustomProgressIndicator();
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: ElevatedButton.icon(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(
            builder: (context) => Theme(
              data: ThemeData(
                colorSchemeSeed: Theme.of(context).colorScheme.primary,
                brightness: Brightness.dark,
                useMaterial3: true,
              ),
              child: ScanQrCode(myCardId: myCardId),
            ),
          ))
              .then((value) {
            SystemChrome.setSystemUIOverlayStyle(
              SystemUiOverlayStyle(
                systemNavigationBarColor: alphaBlend(
                    Theme.of(context).colorScheme.primary.withOpacity(0.08),
                    Theme.of(context).colorScheme.surface),
              ),
            );
          });
        },
        icon: const Icon(
          Icons.qr_code_scanner_rounded,
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
