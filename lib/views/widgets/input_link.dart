import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:thundercard/providers/dynamic_links_provider.dart';
import 'package:thundercard/utils/dynamic_links.dart';

import '../../providers/firebase_firestore.dart';
import '../../utils/constants.dart';
import '../../utils/setSystemChrome.dart';
import '../pages/add_card.dart';
import 'avatar.dart';
import 'custom_progress_indicator.dart';
import 'error_message.dart';
import 'info_bottom_sheet.dart';
import 'positioned_snack_bar.dart';
import 'unfocus.dart';

class InputLink extends ConsumerWidget {
  const InputLink({super.key});

  static final TextEditingController _controller = TextEditingController();

  static void updateTextFieldValue(String value) {
    _controller.text = value;
    _controller.selection = TextSelection.collapsed(offset: value.length);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    setSystemChrome(context);

    final currentCardAsyncValue = ref.watch(currentCardStream);

    return Unfocus(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: currentCardAsyncValue.when(
            error: (err, _) => ErrorMessage(err: '$err'),
            loading: () => const Scaffold(
              body: SafeArea(
                child: Center(
                  child: CustomProgressIndicator(),
                ),
              ),
            ),
            data: (currentCard) {
              final myCardId = currentCard?['current_card'];
              final dynamicLink = ref.watch(dynamicLinkProvider(myCardId));
              final String dynamicLinksValue = dynamicLink.when(
                data: (data) => data.shortUrl.toString(), // データを表示
                loading: () => '',
                error: (err, stack) => err.toString(),
              );
              final c10r20u10d10AsyncValue =
                  ref.watch(c10r20u10d10Stream(myCardId));
              return c10r20u10d10AsyncValue.when(
                error: (err, _) => ErrorMessage(err: '$err'),
                loading: () => const Scaffold(
                  body: SafeArea(
                    child: Center(
                      child: CustomProgressIndicator(),
                    ),
                  ),
                ),
                data: (c10r20u10d10) {
                  final name = c10r20u10d10?['name'];
                  return Column(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          width: double.infinity,
                          color: Theme.of(context).colorScheme.onSecondary,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(
                                width: 40,
                                height: 40,
                                child: FittedBox(
                                  child: Avatar(
                                    isCurrentUser: true,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width - 100,
                                alignment: Alignment.center,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        '$name',
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onBackground,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 16,
                                      ),
                                      Text(
                                        '@$myCardId',
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onBackground
                                              .withOpacity(0.75),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 24,
                              ),
                              Row(
                                children: [
                                  const SizedBox(
                                    width: 40,
                                  ),
                                  Icon(
                                    Icons.link_rounded,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground
                                        .withOpacity(0.8),
                                  ),
                                  const SizedBox(
                                    width: 16,
                                  ),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width - 120,
                                    height: 60,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .background
                                          .withOpacity(0.5),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            16, 0, 16, 0),
                                        child: Text(
                                          dynamicLinksValue,
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onBackground
                                                .withOpacity(0.8),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: 80,
                        color: Theme.of(context).colorScheme.onSecondary,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              margin: const EdgeInsets.fromLTRB(8, 0, 8, 16),
                              child: Row(
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(4, 0, 4, 0),
                                    child: IconButton(
                                      onPressed: () async {
                                        Share.share(dynamicLinksValue);
                                      },
                                      icon: const Icon(Icons.share_rounded),
                                      padding: const EdgeInsets.all(20),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(4, 0, 4, 0),
                                    child: IconButton(
                                      onPressed: () async {
                                        await Clipboard.setData(
                                          ClipboardData(
                                              text: dynamicLinksValue),
                                        ).then((value) {
                                          ScaffoldMessenger.of(context)
                                              .hideCurrentSnackBar();
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            PositionedSnackBar(
                                              context,
                                              'クリップボードにコピーしました',
                                              icon: Icons
                                                  .library_add_check_rounded,
                                            ),
                                          );
                                        });
                                      },
                                      icon: const Icon(Icons.copy_rounded),
                                      padding: const EdgeInsets.all(20),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(
                              height: 40,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  width: 40,
                                ),
                                const Text(
                                  'リンク・ユーザーIDで交換',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                IconButton(
                                  onPressed: () {
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return InfoBottomSheet(
                                          data:
                                              '${shortBaseUri.toString()} で始まるThundercardのリンク、またはユーザーIDを入力してカードを交換することができます。\nユーザーIDを入力する際、先頭の@は省略できます。',
                                        );
                                      },
                                      backgroundColor: Colors.transparent,
                                    ).then((_) {
                                      setSystemChrome(context);
                                    });
                                  },
                                  icon: const Icon(Icons.info_outline_rounded),
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground
                                      .withOpacity(0.7),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width - 90,
                              child: Form(
                                child: TextFormField(
                                  controller: _controller,
                                  cursorColor:
                                      Theme.of(context).colorScheme.primary,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'リンクまたはID',
                                    hintText: 'https://... または @...',
                                  ),
                                  textInputAction: TextInputAction.done,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'リンクまたはIDを入力してください';
                                    }
                                    return null;
                                  },
                                  onFieldSubmitted: (value) {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => AddCard(
                                          applyingId: myCardId,
                                          cardId: _controller.text
                                                  .startsWith('https://')
                                              ? Uri.parse(_controller.text)
                                                      .queryParameters[
                                                          'card_id']
                                                      ?.trim() ??
                                                  ''
                                              : _controller.text
                                                  .split('@')
                                                  .last
                                                  .trim(),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 32,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton.icon(
                                  onPressed: _controller.text == ''
                                      ? null
                                      : () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) => AddCard(
                                                applyingId: myCardId,
                                                cardId: _controller.text
                                                        .startsWith('https://')
                                                    ? Uri.parse(_controller
                                                                .text)
                                                            .queryParameters[
                                                                'card_id']
                                                            ?.trim() ??
                                                        ''
                                                    : _controller.text
                                                        .split('@')
                                                        .last
                                                        .trim(),
                                              ),
                                            ),
                                          );
                                        },
                                  icon: const Icon(Icons.search_rounded),
                                  label: const Text('検索'),
                                  style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    foregroundColor: Theme.of(context)
                                        .colorScheme
                                        .onSecondaryContainer,
                                    backgroundColor: Theme.of(context)
                                        .colorScheme
                                        .secondaryContainer,
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
          ),
        ),
      ),
    );
  }
}
