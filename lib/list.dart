import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:thundercard/widgets/scan_qr_code.dart';

import 'api/colors.dart';
import 'api/current_brightness.dart';
import 'api/current_brightness_reverse.dart';
import 'api/firebase_auth.dart';
import 'widgets/custom_progress_indicator.dart';
import 'widgets/my_card.dart';
import 'card_details.dart';
import 'constants.dart';
import 'search.dart';
import 'upload_image_page.dart';

class List extends StatefulWidget {
  const List({
    Key? key,
  }) : super(key: key);

  @override
  State<List> createState() => _ListState();
}

class _ListState extends State<List> {
  final String? uid = getUid();
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  CollectionReference cards = FirebaseFirestore.instance.collection('cards');
  Map<String, dynamic>? data;
  var isDialOpen = ValueNotifier<bool>(false);
  var customDialRoot = false;
  var buttonSize = const Size(56.0, 56.0);
  var childrenButtonSize = const Size(56.0, 56.0);
  var extend = false;
  var visible = true;
  var rmicons = false;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor: alphaBlend(
            Theme.of(context).colorScheme.primary.withOpacity(0.08),
            Theme.of(context).colorScheme.surface),
        statusBarIconBrightness:
            currentBrightnessReverse(Theme.of(context).colorScheme),
        statusBarBrightness: currentBrightness(Theme.of(context).colorScheme),
        statusBarColor: Colors.transparent,
      ),
    );
    return FutureBuilder<DocumentSnapshot>(
        future: users.doc(uid).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text("問題が発生しました");
          }

          if (snapshot.hasData && !snapshot.data!.exists) {
            return const Text("ユーザー情報の取得に失敗しました");
          }

          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> user =
                snapshot.data!.data() as Map<String, dynamic>;
            return Scaffold(
              // appBar: AppBar(),
              body: SafeArea(
                child: Center(
                  child: StreamBuilder<DocumentSnapshot<Object?>>(
                    stream: cards.doc(user['my_cards'][0]).snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return const Text('問題が発生しました');
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CustomProgressIndicator();
                      }
                      dynamic data = snapshot.data;
                      final exchangedCards = data?['exchanged_cards'];
                      final exchangedCardsLength = exchangedCards?.length ?? 0;

                      return Container(
                        // padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Container(
                              height: 52,
                              margin: EdgeInsets.fromLTRB(24, 16, 24, 8),
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .surfaceVariant
                                    .withOpacity(0.5),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                    PageRouteBuilder(
                                      pageBuilder: (context, animation,
                                              secondaryAnimation) =>
                                          Search(
                                              exchangedCardIds: exchangedCards),
                                      transitionDuration: Duration(seconds: 0),
                                    ),
                                  );
                                },
                                child: Row(
                                  children: [
                                    Container(
                                      padding:
                                          EdgeInsets.fromLTRB(20, 12, 0, 12),
                                      child: Icon(
                                        Icons.search_rounded,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurfaceVariant,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 4,
                                    ),
                                    Expanded(
                                      child: Container(
                                        padding: EdgeInsets.only(top: 16),
                                        child: TextField(
                                          enabled: false,
                                          decoration: InputDecoration(
                                            hintText: '名刺を検索',
                                            filled: true,
                                            fillColor: Colors.transparent,
                                            disabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.transparent,
                                                width: 0,
                                              ),
                                            ),
                                          ),
                                          onChanged: ((value) {}),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            (exchangedCardsLength != 0)
                                ? Expanded(
                                    child: ListView.builder(
                                      // shrinkWrap: true,
                                      // physics:
                                      //     const NeverScrollableScrollPhysics(),
                                      itemCount: exchangedCards.length + 2,
                                      itemBuilder: (context, index) {
                                        if (index == 0) {
                                          return SizedBox(
                                            height: 16,
                                          );
                                        }
                                        if (index ==
                                            exchangedCards.length + 1) {
                                          return SizedBox(
                                            height: 80,
                                          );
                                        }
                                        return StreamBuilder<
                                            DocumentSnapshot<Object?>>(
                                          stream: cards
                                              .doc(exchangedCards[index - 1])
                                              .snapshots(),
                                          builder: (BuildContext context,
                                              AsyncSnapshot<DocumentSnapshot>
                                                  snapshot) {
                                            if (snapshot.hasError) {
                                              return const Text('問題が発生しました');
                                            }
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return const CustomProgressIndicator();
                                            }
                                            dynamic card = snapshot.data;
                                            if (!snapshot.hasData) {
                                              return Text('名刺の情報の取得に失敗しました');
                                            }
                                            return Column(
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.of(context)
                                                        .push(MaterialPageRoute(
                                                      builder: (context) =>
                                                          CardDetails(
                                                        cardId: exchangedCards[
                                                            index - 1],
                                                        card: card,
                                                      ),
                                                    ));
                                                  },
                                                  child: MyCard(
                                                    cardId: exchangedCards[
                                                        index - 1],
                                                    cardType: CardType.normal,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 24,
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  )
                                : Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.priority_high_rounded,
                                          size: 120,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onBackground
                                              .withOpacity(0.3),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                          'まだ名刺がありません',
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurfaceVariant),
                                        ),
                                      ],
                                    ),
                                  ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.endFloat,
              floatingActionButton: SpeedDial(
                // animatedIcon: AnimatedIcons.menu_close,
                animatedIconTheme: IconThemeData(size: 24.0),
                // / This is ignored if animatedIcon is non null
                // child: Text("open"),
                // activeChild: Text("close"),
                icon: Icons.add_rounded,
                activeIcon: Icons.close_rounded,
                backgroundColor:
                    Theme.of(context).colorScheme.secondaryContainer,
                foregroundColor:
                    Theme.of(context).colorScheme.onSecondaryContainer,
                spacing: 16,
                openCloseDial: isDialOpen,
                activeBackgroundColor:
                    Theme.of(context).colorScheme.secondaryContainer,
                childPadding: const EdgeInsets.all(0),
                spaceBetweenChildren: 0,
                dialRoot: customDialRoot
                    ? (ctx, open, toggleChildren) {
                        return ElevatedButton(
                          onPressed: toggleChildren,
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Theme.of(context)
                                .colorScheme
                                .secondaryContainer,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 22, vertical: 18),
                          ),
                          child: const Text(
                            "Custom Dial Root",
                            style: TextStyle(fontSize: 17),
                          ),
                        );
                      }
                    : null,
                buttonSize:
                    buttonSize, // it's the SpeedDial size which defaults to 56 itself
                iconTheme: IconThemeData(size: 24),
                label: extend
                    ? const Text("Open")
                    : null, // The label of the main button.
                /// The active label of the main button, Defaults to label if not specified.
                activeLabel: extend ? const Text("Close") : null,

                /// Transition Builder between label and activeLabel, defaults to FadeTransition.
                // labelTransitionBuilder: (widget, animation) => ScaleTransition(scale: animation,child: widget),
                /// The below button size defaults to 56 itself, its the SpeedDial childrens size
                childrenButtonSize: childrenButtonSize,
                visible: visible,
                direction: SpeedDialDirection.up,
                switchLabelPosition: false,

                /// If true user is forced to close dial manually
                closeManually: false,

                /// If false, backgroundOverlay will not be rendered.
                renderOverlay: true,
                // overlayColor: Colors.black,
                overlayOpacity: 0.9,
                // onOpen: () => debugPrint('OPENING DIAL'),
                // onClose: () => debugPrint('DIAL CLOSED'),
                useRotationAnimation: true,
                tooltip: '',
                heroTag: 'speed-dial-hero-tag',
                // foregroundColor: Colors.black,
                // backgroundColor: Colors.white,
                // activeForegroundColor: Colors.red,
                // activeBackgroundColor: Colors.blue,
                elevation: 8.0,
                animationCurve: Curves.easeInOut,
                isOpenOnStart: false,
                animationDuration: const Duration(milliseconds: 200),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                // childMargin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                childMargin: EdgeInsets.fromLTRB(0, 0, 8, 0),
                children: [
                  SpeedDialChild(
                    child: !rmicons
                        ? Container(
                            padding: EdgeInsets.all(8),
                            margin: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xaa000000),
                                  blurRadius: 8,
                                  offset: Offset(0, 4),
                                  spreadRadius: -2,
                                )
                              ],
                            ),
                            child: Icon(
                              Icons.add_a_photo_rounded,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          )
                        : null,
                    backgroundColor: Colors.transparent,
                    foregroundColor:
                        Theme.of(context).colorScheme.onSecondaryContainer,
                    label: '画像をもとに追加',
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => UploadImagePage(
                                cardId: user['my_cards'][0],
                              ),
                          fullscreenDialog: true));
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    labelBackgroundColor: Colors.transparent,
                    labelShadow: [],
                    elevation: 0,
                  ),
                  SpeedDialChild(
                    child: !rmicons
                        ? Container(
                            padding: EdgeInsets.all(8),
                            margin: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xaa000000),
                                  blurRadius: 8,
                                  offset: Offset(0, 4),
                                  spreadRadius: -2,
                                )
                              ],
                            ),
                            child: Icon(
                              Icons.qr_code_scanner_rounded,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          )
                        : null,
                    backgroundColor: Colors.transparent,
                    foregroundColor:
                        Theme.of(context).colorScheme.onSecondaryContainer,
                    label: '名刺を交換',
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => Theme(
                          data: ThemeData(
                            colorSchemeSeed: Theme.of(context)
                                .colorScheme
                                .secondaryContainer,
                            brightness: Brightness.dark,
                            useMaterial3: true,
                          ),
                          child: const QRViewExample(),
                        ),
                      ));
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    labelBackgroundColor: Colors.transparent,
                    labelShadow: [],
                    elevation: 0,
                  ),
                ],
              ), // floatingActionButton: FloatingActionButton.extended(
            );
          }
          return const Scaffold(
            body: Center(child: CustomProgressIndicator()),
          );
        });
  }
}
