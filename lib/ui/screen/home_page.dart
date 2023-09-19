import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:logger/logger.dart';
import 'package:thundercard/providers/current_card_id_provider.dart';
import 'package:thundercard/providers/firebase_firestore.dart';
import 'package:thundercard/providers/index.dart';
import 'package:thundercard/providers/notifications_count_provider.dart';
import 'package:thundercard/ui/component/avatar.dart';
import 'package:thundercard/ui/component/error_message.dart';
import 'package:thundercard/ui/component/md/about_app.dart';
import 'package:thundercard/ui/component/md/authors.dart';
import 'package:thundercard/ui/component/md/privacy_policy.dart';
import 'package:thundercard/ui/component/md/terms_of_use.dart';
import 'package:thundercard/ui/component/md/version.dart';
import 'package:thundercard/ui/screen/account.dart';
import 'package:thundercard/ui/screen/add_card.dart';
import 'package:thundercard/ui/screen/cards_list_page.dart';
import 'package:thundercard/ui/screen/md_page.dart';
import 'package:thundercard/ui/screen/notifications.dart';
import 'package:thundercard/ui/screen/share_app.dart';
import 'package:thundercard/ui/screen/thundercard.dart';
import 'package:thundercard/utils/colors.dart';
import 'package:thundercard/utils/firebase_auth.dart';

final GlobalKey<ScaffoldState> drawerKey = GlobalKey<ScaffoldState>();

class HomePage extends ConsumerWidget {
  HomePage({Key? key}) : super(key: key);
  final String? uid = getUid();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndexStateController = ref.read(currentIndexProvider.notifier);
    final currentIndex = ref.watch(currentIndexProvider);
    final currentCardAsyncValue = ref.watch(currentCardStream);

    return WillPopScope(
      onWillPop: () async => false,
      child: currentCardAsyncValue.when(
        error: (err, _) => ErrorMessage(err: '$err'),
        loading: () => Scaffold(
          body: Center(
            child: SvgPicture.asset(
              'images/svg/qr/icon_for_qr.svg',
              width: 160,
              color:
                  Theme.of(context).colorScheme.onBackground.withOpacity(0.5),
            ),
          ),
        ),
        data: (currentCard) {
          final cardId = currentCard?['current_card'];
          final c10r20u10d10AsyncValue = ref.watch(c10r20u10d10Stream(cardId));
          final iconColorNum = Theme.of(context)
              .colorScheme
              .onBackground
              .value
              .toRadixString(16)
              .substring(2);
          final notificationsCountAsyncValue =
              ref.watch(notificationStreamProvider(cardId));
          final notificationsCount = notificationsCountAsyncValue.when(
            data: (data) {
              final notificationsData = data.data();
              if (notificationsData != null &&
                  notificationsData.containsKey('notifications_count')) {
                return {
                  'notifications_count':
                      notificationsData['notifications_count']
                              ?['notifications_count'] ??
                          0,
                  'interactions_count': notificationsData['notifications_count']
                          ?['interactions_count'] ??
                      0,
                  'news_count': notificationsData['notifications_count']
                          ?['news_count'] ??
                      0,
                };
              } else {
                return {
                  'notifications_count':
                      notificationsData['notifications_count']
                              ?['notifications_count'] ??
                          0,
                  'interactions_count': notificationsData['notifications_count']
                          ?['interactions_count'] ??
                      0,
                  'news_count': notificationsData['notifications_count']
                          ?['news_count'] ??
                      0,
                };
              }
            },
            loading: () => {
              'notifications_count': 0,
              'interactions_count': 0,
              'news_count': 0,
            },
            error: (err, _) => {
              'notifications_count': 0,
              'interactions_count': 0,
              'news_count': 0,
            },
          );

          FirebaseDynamicLinks.instance.onLink.listen(
            (dynamicLinkData) {
              final deepLink = dynamicLinkData.link;
              final String myCardId = deepLink.queryParameters['card_id'] ?? '';
              ref.watch(currentIndexProvider.notifier).state = 0;
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) =>
                      AddCard(applyingId: cardId, cardId: myCardId),
                ),
                (_) => false,
              );
            },
          ).onError(
            (error) {
              Logger().e('error: $error');
            },
          );

          return ProviderScope(
            overrides: [
              currentCardIdProvider.overrideWithValue(cardId),
            ],
            child: ProviderScope(
              overrides: [
                notificationsCountProvider.overrideWithValue(notificationsCount),
              ],
              child: Scaffold(
                key: drawerKey,
                drawerScrimColor: const Color(0x80000000),
                drawerEdgeDragWidth: currentIndex == 0
                    ? MediaQuery.of(context).size.width * 0.5
                    : 0,
                drawer: c10r20u10d10AsyncValue.when(
                  error: (err, _) => ErrorMessage(err: '$err'),
                  loading: () => Scaffold(
                    body: Center(
                      child: SvgPicture.asset(
                        'images/svg/qr/icon_for_qr.svg',
                        width: 160,
                        color: Theme.of(context)
                            .colorScheme
                            .onBackground
                            .withOpacity(0.5),
                      ),
                    ),
                  ),
                  data: (c10r20u10d10) {
                    final name = c10r20u10d10?['name'];
                    final String iconUrl = c10r20u10d10?['icon_url'] ?? '';
                    return Drawer(
                      backgroundColor: alphaBlend(
                        Theme.of(context).colorScheme.primary.withOpacity(0.05),
                        Theme.of(context).colorScheme.surface,
                      ),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(16),
                          bottomRight: Radius.circular(16),
                        ),
                      ),
                      child: Column(
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(16),
                              ),
                            ),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: MediaQuery.of(context).padding.top,
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      padding: const EdgeInsets.all(18),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      icon: const Icon(Icons.menu_open_rounded),
                                    ),
                                    const SizedBox(width: 16),
                                    SvgPicture.string(
                                      '<svg width="400" height="400" viewBox="0 0 400 400" fill="#$iconColorNum" xmlns="http://www.w3.org/2000/svg"><path d="M193.367 13.2669C197.432 5.13606 205.742 0 214.833 0H260.584C269.504 0 275.306 9.38775 271.317 17.3666L174.633 210.733C170.568 218.864 162.258 224 153.167 224H107.416C98.4958 224 92.6939 214.612 96.6833 206.633L193.367 13.2669Z"/><path d="M225.367 189.267C229.432 181.136 237.742 176 246.833 176H292.584C301.504 176 307.306 185.388 303.317 193.367L206.633 386.733C202.568 394.864 194.258 400 185.167 400H139.416C130.496 400 124.694 390.612 128.683 382.633L225.367 189.267Z"/></svg>',
                                      width: 18,
                                    ),
                                    const SizedBox(width: 4),
                                    const Text(
                                      'Thundercard',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ],
                                ),
                                Divider(
                                  height: 2,
                                  thickness: 2,
                                  indent: 0,
                                  endIndent: 0,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .outline
                                      .withOpacity(0.5),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: LayoutBuilder(
                              builder: (context, constrains) {
                                return SingleChildScrollView(
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(
                                      minHeight: constrains.maxHeight,
                                    ),
                                    child: IntrinsicHeight(
                                      child: Column(
                                        children: [
                                          const SizedBox(
                                            height: 16,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              right: 12,
                                            ),
                                            child: ListTile(
                                              leading: SizedBox(
                                                width: 32,
                                                child: Center(
                                                  child: FittedBox(
                                                    child: Avatar(
                                                      iconUrl: iconUrl,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              title: Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                  0,
                                                  10,
                                                  10,
                                                  10,
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      name,
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 4,
                                                    ),
                                                    Text(
                                                      '@$cardId',
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .primary
                                                            .withOpacity(
                                                              0.8,
                                                            ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              selected: true,
                                              selectedTileColor:
                                                  Theme.of(context)
                                                      .colorScheme
                                                      .primary
                                                      .withOpacity(0.1),
                                              shape:
                                                  const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(40),
                                                  bottomRight:
                                                      Radius.circular(40),
                                                ),
                                              ),
                                              onTap: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ),
                                          const Spacer(),
                                          Divider(
                                            height: 32,
                                            thickness: 1,
                                            indent: 20,
                                            endIndent: 20,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .outline
                                                .withOpacity(0.25),
                                          ),
                                          ListTile(
                                            leading: Padding(
                                              padding: const EdgeInsets.only(
                                                left: 12,
                                              ),
                                              child: Icon(
                                                Icons.description_outlined,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onBackground
                                                    .withOpacity(0.5),
                                              ),
                                            ),
                                            title:
                                                const Text('Thundercardについて'),
                                            dense: true,
                                            onTap: () {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) {
                                                    return MdPage(
                                                      title: const Text(
                                                        'Thundercardについて',
                                                      ),
                                                      data:
                                                          '$aboutAppData$authorsData## バージョン情報\n${versionData.split('\n')[0]}',
                                                    );
                                                  },
                                                ),
                                              );
                                            },
                                          ),
                                          ListTile(
                                            leading: Padding(
                                              padding: const EdgeInsets.only(
                                                left: 12,
                                              ),
                                              child: Icon(
                                                Icons.share_rounded,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onBackground
                                                    .withOpacity(0.5),
                                              ),
                                            ),
                                            title: const Text('アプリの共有'),
                                            dense: true,
                                            onTap: () {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) {
                                                    return const ShareApp();
                                                  },
                                                ),
                                              );
                                            },
                                          ),
                                          ListTile(
                                            leading: Padding(
                                              padding: const EdgeInsets.only(
                                                left: 12,
                                              ),
                                              child: Icon(
                                                Icons.policy_outlined,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onBackground
                                                    .withOpacity(0.5),
                                              ),
                                            ),
                                            title: const Text('プライバシーポリシー'),
                                            dense: true,
                                            onTap: () {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) {
                                                    return const MdPage(
                                                      title: Text('プライバシーポリシー'),
                                                      data: privacyPolicyData,
                                                    );
                                                  },
                                                ),
                                              );
                                            },
                                          ),
                                          ListTile(
                                            leading: Padding(
                                              padding: const EdgeInsets.only(
                                                left: 12,
                                              ),
                                              child: Icon(
                                                Icons.gavel_rounded,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onBackground
                                                    .withOpacity(0.5),
                                              ),
                                            ),
                                            title: const Text('利用規約'),
                                            dense: true,
                                            onTap: () {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) {
                                                    return const MdPage(
                                                      title: Text('利用規約'),
                                                      data: termsOfUseData,
                                                    );
                                                  },
                                                ),
                                              );
                                            },
                                          ),
                                          SizedBox(
                                            height: 16 +
                                                MediaQuery.of(context)
                                                    .padding
                                                    .bottom,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                bottomNavigationBar: NavigationBar(
                  onDestinationSelected: (int newIndex) {
                    currentIndexStateController.state = newIndex;
                  },
                  selectedIndex: currentIndex,
                  destinations: <Widget>[
                    const NavigationDestination(
                      selectedIcon: Icon(
                        Icons.contact_mail,
                        size: 26,
                      ),
                      icon: Icon(
                        Icons.contact_mail_outlined,
                      ),
                      label: 'ホーム',
                    ),
                    const NavigationDestination(
                      selectedIcon: Icon(
                        Icons.ballot_rounded,
                        size: 26,
                      ),
                      icon: Icon(
                        Icons.ballot_outlined,
                      ),
                      label: 'カード',
                    ),
                    NavigationDestination(
                      selectedIcon: notificationsCount['notifications_count'] !=
                              0
                          ? Badge(
                              label: Text(
                                '${notificationsCount['notifications_count']}',
                              ),
                              backgroundColor:
                                  Theme.of(context).colorScheme.tertiary,
                              child: const Icon(Icons.notifications_rounded),
                            )
                          : const Icon(
                              Icons.notifications_rounded,
                              size: 26,
                            ),
                      icon: notificationsCount['notifications_count'] != 0
                          ? Badge(
                              label: Text(
                                '${notificationsCount['notifications_count']}',
                              ),
                              backgroundColor:
                                  Theme.of(context).colorScheme.tertiary,
                              child:
                                  const Icon(Icons.notifications_none_rounded),
                            )
                          : const Icon(
                              Icons.notifications_none_rounded,
                              size: 26,
                            ),
                      label: '通知',
                    ),
                    const NavigationDestination(
                      selectedIcon: Icon(
                        Icons.account_circle_rounded,
                        size: 26,
                      ),
                      icon: Icon(
                        Icons.account_circle_outlined,
                      ),
                      label: 'アカウント',
                    ),
                  ],
                ),
                body: <Widget>[
                  const Thundercard(),
                  const CardsListPage(),
                  const Notifications(),
                  const Account(),
                ][currentIndex],
              ),
            ),
          );
        },
      ),
    );
  }
}
