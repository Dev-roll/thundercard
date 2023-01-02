import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:thundercard/exchange_card.dart';

import 'api/colors.dart';
import 'api/current_brightness.dart';
import 'api/current_brightness_reverse.dart';
import 'api/firebase_auth.dart';
import 'cards/views/widgets/search.dart';
import 'widgets/custom_progress_indicator.dart';
import 'widgets/error_message.dart';
import 'widgets/my_card.dart';
import 'card_details.dart';
import 'constants.dart';
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
  CollectionReference cards = FirebaseFirestore.instance
      .collection('version')
      .doc('2')
      .collection('cards');
  Map<String, dynamic>? data;
  var isDialOpen = ValueNotifier<bool>(false);
  var customDialRoot = false;
  var buttonSize = const Size(56.0, 56.0);
  var childrenButtonSize = const Size(56.0, 56.0);
  var extend = false;
  var visible = true;
  var rmicons = false;
  var myCardId = '';

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
      future: users.doc(uid).collection('card').doc('current_card').get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const ErrorMessage(err: '問題が発生しました');
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Scaffold(
            body: SafeArea(
              child: Center(
                child: Text(
                  'ユーザー情報の取得に失敗しました',
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> currentCard =
              snapshot.data!.data() as Map<String, dynamic>;
          return Scaffold(
            body: SafeArea(
              child: Center(
                child: StreamBuilder<DocumentSnapshot<Object?>>(
                  stream: cards
                      .doc(currentCard['current_card'])
                      .collection('visibility')
                      .doc('c10r10u11d10')
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return const ErrorMessage(err: '問題が発生しました');
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CustomProgressIndicator();
                    }
                    dynamic data = snapshot.data;
                    final exchangedCards = data?['exchanged_cards'];
                    final exchangedCardsLength = exchangedCards?.length ?? 0;

                    return Column(
                      children: [
                        ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxWidth: 720,
                          ),
                          child: Container(
                            height: 52,
                            margin: const EdgeInsets.fromLTRB(24, 16, 24, 8),
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .surfaceVariant
                                  .withOpacity(0.5),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                Navigator.of(context)
                                    .push(
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation,
                                            secondaryAnimation) =>
                                        Search(
                                            exchangedCardIds: exchangedCards),
                                    transitionDuration:
                                        const Duration(seconds: 0),
                                  ),
                                )
                                    .then((value) {
                                  SystemChrome.setSystemUIOverlayStyle(
                                    SystemUiOverlayStyle(
                                      systemNavigationBarColor: alphaBlend(
                                          Theme.of(context)
                                              .colorScheme
                                              .primary
                                              .withOpacity(0.08),
                                          Theme.of(context)
                                              .colorScheme
                                              .surface),
                                    ),
                                  );
                                });
                              },
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.fromLTRB(
                                        20, 12, 0, 12),
                                    child: Icon(
                                      Icons.search_rounded,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Container(
                                      margin: const EdgeInsets.only(right: 16),
                                      child: TextField(
                                        enabled: false,
                                        decoration: const InputDecoration(
                                          hintText: 'カードを検索',
                                          filled: true,
                                          fillColor: Colors.transparent,
                                          disabledBorder: UnderlineInputBorder(
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
                        ),
                        (exchangedCardsLength != 0)
                            ? Expanded(
                                child: ListView.builder(
                                  itemCount: exchangedCards.length + 2,
                                  itemBuilder: (context, index) {
                                    if (index == 0) {
                                      return const SizedBox(height: 16);
                                    }
                                    if (index == exchangedCards.length + 1) {
                                      return const SizedBox(height: 80);
                                    }
                                    return Column(
                                      children: [
                                        GestureDetector(
                                          behavior: HitTestBehavior.opaque,
                                          onTap: () {
                                            Navigator.of(context)
                                                .push(MaterialPageRoute(
                                              builder: (context) => CardDetails(
                                                cardId:
                                                    exchangedCards[index - 1],
                                              ),
                                            ));
                                          },
                                          child: ConstrainedBox(
                                            constraints: const BoxConstraints(
                                              maxHeight: 400,
                                            ),
                                            child: FittedBox(
                                              child: MyCard(
                                                cardId:
                                                    exchangedCards[index - 1],
                                                cardType: CardType.normal,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 24),
                                      ],
                                    );
                                  },
                                ),
                              )
                            : Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.priority_high_rounded,
                                      size: 120,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground
                                          .withOpacity(0.3),
                                    ),
                                    const SizedBox(height: 20),
                                    Text(
                                      'まだカードがありません',
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurfaceVariant),
                                    ),
                                  ],
                                ),
                              ),
                      ],
                    );
                  },
                ),
              ),
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            floatingActionButton: SpeedDial(
              animatedIconTheme: const IconThemeData(size: 24.0),
              icon: Icons.add_rounded,
              activeIcon: Icons.close_rounded,
              foregroundColor:
                  Theme.of(context).colorScheme.onSecondaryContainer,
              backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
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
                          foregroundColor:
                              Theme.of(context).colorScheme.secondaryContainer,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 22, vertical: 18),
                        ),
                        child: const Text(
                          'Custom Dial Root',
                          style: TextStyle(fontSize: 17),
                        ),
                      );
                    }
                  : null,
              buttonSize:
                  buttonSize, // it's the SpeedDial size which defaults to 56 itself
              iconTheme: const IconThemeData(size: 24),
              label: extend
                  ? const Text('Open')
                  : null, // The label of the main button.
              /// The active label of the main button, Defaults to label if not specified.
              activeLabel: extend ? const Text('Close') : null,

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
              // onOpen: () {debugPrint('OPENING DIAL');},
              // onClose: () {debugPrint('DIAL CLOSED');},
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
                borderRadius: BorderRadius.circular(16),
              ),
              // childMargin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              childMargin: const EdgeInsets.fromLTRB(0, 0, 8, 0),
              children: [
                SpeedDialChild(
                  child: !rmicons
                      ? Container(
                          padding: const EdgeInsets.all(8),
                          margin: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: const [
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
                        cardId: currentCard['current_card'],
                      ),
                      fullscreenDialog: true,
                    ));
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  labelBackgroundColor: Colors.transparent,
                  labelShadow: [],
                  elevation: 0,
                ),
                SpeedDialChild(
                  child: !rmicons
                      ? Container(
                          padding: const EdgeInsets.all(8),
                          margin: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0xaa000000),
                                blurRadius: 8,
                                offset: Offset(0, 4),
                                spreadRadius: -2,
                              )
                            ],
                          ),
                          child: Icon(
                            Icons.swap_horiz_rounded,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        )
                      : null,
                  backgroundColor: Colors.transparent,
                  foregroundColor:
                      Theme.of(context).colorScheme.onSecondaryContainer,
                  label: 'カードを交換',
                  onTap: () {
                    Navigator.of(context)
                        .push(
                      MaterialPageRoute(
                        builder: (context) => Theme(
                          data: ThemeData(
                            colorSchemeSeed: Theme.of(context)
                                .colorScheme
                                .secondaryContainer,
                            brightness: Brightness.dark,
                            useMaterial3: true,
                          ),
                          child: const ExchangeCard(),
                        ),
                      ),
                    )
                        .then((value) {
                      SystemChrome.setSystemUIOverlayStyle(
                        SystemUiOverlayStyle(
                          systemNavigationBarColor: alphaBlend(
                              Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.08),
                              Theme.of(context).colorScheme.surface),
                          statusBarIconBrightness: Theme.of(context)
                                      .colorScheme
                                      .background
                                      .computeLuminance() <
                                  0.5
                              ? Brightness.light
                              : Brightness.dark,
                          statusBarBrightness: Theme.of(context)
                                      .colorScheme
                                      .background
                                      .computeLuminance() <
                                  0.5
                              ? Brightness.dark
                              : Brightness.light,
                          statusBarColor: Colors.transparent,
                        ),
                      );
                    });
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  labelBackgroundColor: Colors.transparent,
                  labelShadow: [],
                  elevation: 0,
                ),
              ],
            ),
          );
        }
        return const Scaffold(
          body: Center(child: CustomProgressIndicator()),
        );
      },
    );
  }
}
