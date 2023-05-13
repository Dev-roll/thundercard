import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:thundercard/providers/dynamic_links_provider.dart';

import '../../utils/constants.dart';
import '../widgets/positioned_snack_bar.dart';

class ShareApp extends ConsumerWidget {
  const ShareApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dynamicLink = ref.watch(dynamicLinkProvider('Devroll'));
    final String dynamicLinksValue = dynamicLink.when(
      data: (data) => data.shortUrl.toString(), // データを表示
      loading: () => '',
      error: (err, stack) => err.toString(),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Thundercard をシェア'),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 40),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 140,
                        height: 240,
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.1),
                      ),
                      SvgPicture.asset(
                        'images/svg/qr/icon_for_qr.svg',
                        width: 200,
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.1),
                      ),
                      SvgPicture.asset(
                        'images/svg/qr/icon_for_qr.svg',
                        width: 200,
                        color: Theme.of(context)
                            .colorScheme
                            .onBackground
                            .withOpacity(0.1),
                      ),
                      BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: 20,
                          sigmaY: 20,
                        ),
                        child: Container(
                          color: Colors.transparent.withOpacity(0),
                        ),
                      ),
                      SvgPicture.asset(
                        'images/svg/qr/icon_for_qr.svg',
                        width: 200,
                        color: Theme.of(context).colorScheme.background,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Column(
              children: [
                SizedBox(
                  height: min(320, MediaQuery.of(context).size.height * 0.4),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(40, 20, 40, 20),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.android_rounded,
                            size: 32,
                            color: Theme.of(context)
                                .colorScheme
                                .onBackground
                                .withOpacity(0.75),
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          Text(
                            'Android',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Text(
                            'Google Play',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground
                                      .withOpacity(0.5),
                                  fontWeight: FontWeight.w300,
                                  fontSize: 16,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {
                              Share.share(playStoreUrl);
                            },
                            icon: const Icon(Icons.share_outlined),
                            label: const Text('共有'),
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
                          const SizedBox(
                            width: 8,
                          ),
                          ElevatedButton.icon(
                            onPressed: () {
                              Clipboard.setData(
                                const ClipboardData(text: playStoreUrl),
                              ).then(
                                (value) =>
                                    ScaffoldMessenger.of(context).showSnackBar(
                                  PositionedSnackBar(
                                    context,
                                    'クリップボードにコピーしました',
                                    icon: Icons.library_add_check_rounded,
                                    bottom: 20,
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.copy_rounded),
                            label: const Text('リンクをコピー'),
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
                const SizedBox(
                  height: 20,
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(40, 20, 40, 20),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            FontAwesomeIcons.apple,
                            size: 32,
                            color: Theme.of(context)
                                .colorScheme
                                .onBackground
                                .withOpacity(0.75),
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          Text(
                            'iOS',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Text(
                            'App Store',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground
                                      .withOpacity(0.5),
                                  fontWeight: FontWeight.w300,
                                  fontSize: 16,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {
                              Share.share(appStoreUrl);
                            },
                            icon: const Icon(CupertinoIcons.share),
                            label: const Text('共有'),
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
                          const SizedBox(
                            width: 8,
                          ),
                          ElevatedButton.icon(
                            onPressed: () {
                              Clipboard.setData(
                                const ClipboardData(text: appStoreUrl),
                              ).then(
                                (value) =>
                                    ScaffoldMessenger.of(context).showSnackBar(
                                  PositionedSnackBar(
                                    context,
                                    'クリップボードにコピーしました',
                                    icon: Icons.library_add_check_rounded,
                                    bottom: 20,
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(CupertinoIcons.link),
                            label: const Text('リンクをコピー'),
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
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton.icon(
            onPressed: () {
              Share.share(dynamicLinksValue);
            },
            icon: const Icon(
              Icons.share_rounded,
              size: 26,
            ),
            label: const Text(
              '共有',
              style: TextStyle(fontSize: 16),
            ),
            style: ElevatedButton.styleFrom(
              fixedSize: const Size(160, 56),
              foregroundColor:
                  Theme.of(context).colorScheme.onSecondaryContainer,
              backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
            ),
          ),
          const SizedBox(
            width: 16,
          ),
          IconButton(
            onPressed: () {
              Clipboard.setData(
                ClipboardData(text: dynamicLinksValue),
              ).then(
                (value) => ScaffoldMessenger.of(context).showSnackBar(
                  PositionedSnackBar(
                    context,
                    'クリップボードにコピーしました',
                    icon: Icons.library_add_check_rounded,
                    bottom: 20,
                  ),
                ),
              );
            },
            icon: const Icon(
              Icons.copy_rounded,
              size: 26,
            ),
            padding: const EdgeInsets.all(16),
            style: IconButton.styleFrom(
              foregroundColor:
                  Theme.of(context).colorScheme.onSecondaryContainer,
              backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
            ),
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
