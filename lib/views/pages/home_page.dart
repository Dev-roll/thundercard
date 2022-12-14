import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import '../../providers/current_card_id_provider.dart';
import '../../providers/firebase_firestore.dart';
import '../../providers/index.dart';
import '../../utils/colors.dart';
import '../../utils/firebase_auth.dart';
import '../../utils/setSystemChrome.dart';
import '../widgets/avatar.dart';
import '../widgets/error_message.dart';
import '../widgets/md/about_app.dart';
import '../widgets/md/authors.dart';
import '../widgets/md/privacy_policy.dart';
import '../widgets/md/terms_of_use.dart';
import '../widgets/md/version.dart';
import 'account.dart';
import 'add_card.dart';
import 'cards_list_page.dart';
import 'md_page.dart';
import 'notifications.dart';
import 'share_app.dart';
import 'thundercard.dart';

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
          body: SafeArea(
            child: Center(
              child: SvgPicture.asset(
                'images/svg/qr/icon_for_qr.svg',
                width: 160,
                color:
                    Theme.of(context).colorScheme.onBackground.withOpacity(0.5),
              ),
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
              debugPrint('error: $error');
            },
          );

          setSystemChrome(context);

          return ProviderScope(
            overrides: [
              currentCardIdProvider.overrideWithValue(cardId),
            ],
            child: Scaffold(
              key: drawerKey,
              onDrawerChanged: (isOpened) {
                isOpened
                    ? setSystemChrome(
                        context,
                        navColor: alphaBlend(
                          const Color(0x80000000),
                          alphaBlend(
                            Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.08),
                            Theme.of(context).colorScheme.surface,
                          ),
                        ),
                      )
                    : setSystemChrome(context);
              },
              drawerScrimColor: const Color(0x80000000),
              drawerEdgeDragWidth: currentIndex == 0
                  ? MediaQuery.of(context).size.width * 0.5
                  : 0,
              drawer: c10r20u10d10AsyncValue.when(
                error: (err, _) => ErrorMessage(err: '$err'),
                loading: () => Scaffold(
                  body: SafeArea(
                    child: Center(
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
                ),
                data: (c10r20u10d10) {
                  final name = c10r20u10d10?['name'];
                  return Drawer(
                    backgroundColor: alphaBlend(
                        Theme.of(context).colorScheme.primary.withOpacity(0.05),
                        Theme.of(context).colorScheme.surface),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: alphaBlend(
                                Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.05),
                                Theme.of(context).colorScheme.surface),
                            borderRadius: const BorderRadius.only(
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
                                      minHeight: constrains.maxHeight),
                                  child: IntrinsicHeight(
                                    child: Column(
                                      children: [
                                        const SizedBox(
                                          height: 16,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 12),
                                          child: ListTile(
                                            leading: const SizedBox(
                                              width: 32,
                                              child: Center(
                                                  child: FittedBox(
                                                      child: Avatar())),
                                            ),
                                            title: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      0, 10, 10, 10),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    name,
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
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
                                                            .withOpacity(0.8)),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            selected: true,
                                            selectedTileColor: Theme.of(context)
                                                .colorScheme
                                                .primary
                                                .withOpacity(0.1),
                                            shape: const RoundedRectangleBorder(
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
                                            padding:
                                                const EdgeInsets.only(left: 12),
                                            child: Icon(
                                              Icons.description_outlined,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onBackground
                                                  .withOpacity(0.5),
                                            ),
                                          ),
                                          title: const Text('Thundercard????????????'),
                                          dense: true,
                                          onTap: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) {
                                                return MdPage(
                                                  title: const Text(
                                                      'Thundercard????????????'),
                                                  data:
                                                      '$aboutAppData$authorsData## ?????????????????????\n${versionData.split('\n')[0]}',
                                                );
                                              }),
                                            );
                                          },
                                        ),
                                        ListTile(
                                          leading: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 12),
                                            child: Icon(
                                              Icons.share_rounded,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onBackground
                                                  .withOpacity(0.5),
                                            ),
                                          ),
                                          title: const Text('??????????????????'),
                                          dense: true,
                                          onTap: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) {
                                                return const ShareApp();
                                              }),
                                            );
                                          },
                                        ),
                                        ListTile(
                                          leading: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 12),
                                            child: Icon(
                                              Icons.policy_outlined,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onBackground
                                                  .withOpacity(0.5),
                                            ),
                                          ),
                                          title: const Text('??????????????????????????????'),
                                          dense: true,
                                          onTap: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) {
                                                return const MdPage(
                                                  title: Text('??????????????????????????????'),
                                                  data: privacyPolicyData,
                                                );
                                              }),
                                            );
                                          },
                                        ),
                                        ListTile(
                                          leading: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 12),
                                            child: Icon(
                                              Icons.gavel_rounded,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onBackground
                                                  .withOpacity(0.5),
                                            ),
                                          ),
                                          title: const Text('????????????'),
                                          dense: true,
                                          onTap: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) {
                                                return const MdPage(
                                                  title: Text('????????????'),
                                                  data: termsOfUseData,
                                                );
                                              }),
                                            );
                                          },
                                        ),
                                        const SizedBox(height: 16),
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
                destinations: const <Widget>[
                  NavigationDestination(
                    selectedIcon: Icon(
                      Icons.contact_mail,
                      size: 26,
                    ),
                    icon: Icon(
                      Icons.contact_mail_outlined,
                    ),
                    label: '?????????',
                  ),
                  NavigationDestination(
                    selectedIcon: Icon(
                      Icons.ballot_rounded,
                      size: 26,
                    ),
                    icon: Icon(
                      Icons.ballot_outlined,
                    ),
                    label: '?????????',
                  ),
                  NavigationDestination(
                    selectedIcon: Icon(
                      Icons.notifications_rounded,
                      size: 26,
                    ),
                    icon: Icon(
                      Icons.notifications_none_rounded,
                    ),
                    label: '??????',
                  ),
                  NavigationDestination(
                    selectedIcon: Icon(
                      Icons.account_circle_rounded,
                      size: 26,
                    ),
                    icon: Icon(
                      Icons.account_circle_outlined,
                    ),
                    label: '???????????????',
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
          );
        },
      ),
    );
  }
}
