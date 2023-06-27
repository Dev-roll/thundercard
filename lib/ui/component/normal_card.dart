import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:thundercard/providers/firebase_firestore.dart';
import 'package:thundercard/ui/component/avatar.dart';
import 'package:thundercard/ui/component/card_element.dart';
import 'package:thundercard/ui/component/custom_skeletons/skeleton_card.dart';
import 'package:thundercard/ui/component/error_message.dart';
import 'package:thundercard/ui/component/open_app.dart';
import 'package:thundercard/utils/constants.dart';
import 'package:thundercard/utils/return_url.dart';

class NormalCard extends ConsumerWidget {
  const NormalCard({
    Key? key,
    required this.cardId,
  }) : super(key: key);
  final String cardId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var screenSize = MediaQuery.of(context).size;
    var vw = screenSize.width * 0.01;

    final c10r20u10d10AsyncValue = ref.watch(c10r20u10d10Stream(cardId));
    return c10r20u10d10AsyncValue.when(
      error: (err, _) => ErrorMessage(err: '$err'),
      loading: () => const SkeletonCard(),
      data: (c10r20u10d10) {
        final c10r21u10d10AsyncValue = ref.watch(c10r21u10d10Stream(cardId));
        return c10r21u10d10AsyncValue.when(
          error: (err, _) => ErrorMessage(err: '$err'),
          loading: () => const SkeletonCard(),
          data: (c10r21u10d10) {
            final c21r20u00d11AsyncValue =
                ref.watch(c21r20u00d11Stream(cardId));
            return c21r20u00d11AsyncValue.when(
              error: (err, _) => ErrorMessage(err: '$err'),
              loading: () => const SkeletonCard(),
              data: (c21r20u00d11) {
                final String name = c10r20u10d10?['name'];
                final Map profiles = c10r21u10d10?['profiles'];
                final List links = c10r21u10d10?['account']['links'];
                final String iconUrl = c10r20u10d10?['icon_url'] ?? '';

                int profileLen = 0;
                if (profiles.isNotEmpty) {
                  for (var i = 0; i < dataTypes.length; i++) {
                    if (profiles[dataTypes[i]]['value'] != '' &&
                        profiles[dataTypes[i]]['display']['normal']) {
                      profileLen += 1;
                    }
                  }
                }
                bool existProfile = profileLen > 0;
                bool existLink = links.isNotEmpty;
                int dataLen = (existProfile ? 1 : 0) + (existLink ? 1 : 0);

                return SizedBox(
                  width: 91 * vw,
                  height: 55 * vw,
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3 * vw),
                          color:
                              Theme.of(context).colorScheme.secondaryContainer,
                        ),
                      ),
                      Align(
                        alignment: const Alignment(1.1, 0.4),
                        child: SvgPicture.string(
                          color: Theme.of(context)
                              .colorScheme
                              .secondary
                              .withOpacity(0.08),
                          '<svg width="400" height="400" viewBox="0 0 400 400" fill="#ffffff" xmlns="http://www.w3.org/2000/svg"><path d="M193.367 13.2669C197.432 5.13606 205.742 0 214.833 0H260.584C269.504 0 275.306 9.38775 271.317 17.3666L174.633 210.733C170.568 218.864 162.258 224 153.167 224H107.416C98.4958 224 92.6939 214.612 96.6833 206.633L193.367 13.2669Z"/><path d="M225.367 189.267C229.432 181.136 237.742 176 246.833 176H292.584C301.504 176 307.306 185.388 303.317 193.367L206.633 386.733C202.568 394.864 194.258 400 185.167 400H139.416C130.496 400 124.694 390.612 128.683 382.633L225.367 189.267Z"/></svg>',
                          width: 36 * vw,
                        ),
                      ),
                      Container(
                        padding:
                            EdgeInsets.fromLTRB(4 * vw, 4 * vw, 4 * vw, 4 * vw),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3 * vw),
                        ),
                        child: Column(
                          children: [
                            // top
                            SizedBox(
                              height: 16 * vw,
                              child: Row(
                                children: [
                                  // avatar
                                  Avatar(iconUrl: iconUrl),
                                  // name etc
                                  Flexible(
                                    child:
                                        // name == null
                                        //     ? Container()
                                        //     :
                                        Container(
                                      padding: EdgeInsets.fromLTRB(
                                        2 * vw,
                                        0 * vw,
                                        0 * vw,
                                        0 * vw,
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          CardElement(
                                            txt: name,
                                            size: 3,
                                            weight: 'bold',
                                            opacity: 0.7,
                                          ),
                                          if (c21r20u00d11?['is_user'])
                                            CardElement(
                                              txt: '@$cardId',
                                              size: 1.5,
                                              opacity: 0.5,
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // bottom
                            SizedBox(
                              height: 31 * vw,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // spacer
                                  if (dataLen == 1) SizedBox(width: vw),
                                  // bottom_left
                                  if (existProfile)
                                    SizedBox(
                                      width: dataLen != 1 ? 41 * vw : 80 * vw,
                                      child: profiles.isEmpty
                                          ? Container()
                                          : Container(
                                              padding: EdgeInsets.fromLTRB(
                                                vw,
                                                2 * vw,
                                                0,
                                                vw,
                                              ),
                                              child: SingleChildScrollView(
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    for (var i = 0;
                                                        i <
                                                            min(
                                                              dataTypes.length,
                                                              5,
                                                            );
                                                        i++)
                                                      if (profiles[dataTypes[i]]
                                                                  ['value'] !=
                                                              '' &&
                                                          profiles[dataTypes[i]]
                                                                  ['display']
                                                              ['normal'])
                                                        dataTypes[i] ==
                                                                'address'
                                                            ? Container(
                                                                padding:
                                                                    EdgeInsets
                                                                        .fromLTRB(
                                                                  0,
                                                                  vw,
                                                                  0,
                                                                  vw,
                                                                ),
                                                                child: OpenApp(
                                                                  url:
                                                                      returnUrl(
                                                                    'address',
                                                                    profiles[dataTypes[
                                                                            i]][
                                                                        'value'],
                                                                  ),
                                                                ),
                                                              )
                                                            : Container(
                                                                padding:
                                                                    EdgeInsets
                                                                        .fromLTRB(
                                                                  0,
                                                                  vw,
                                                                  0,
                                                                  vw,
                                                                ),
                                                                child:
                                                                    CardElement(
                                                                  txt: profiles[
                                                                              dataTypes[i]]
                                                                          [
                                                                          'value'] ??
                                                                      '',
                                                                  type: linkTypeToIconType[
                                                                          dataTypes[
                                                                              i]] ??
                                                                      IconType
                                                                          .nl,
                                                                  line: dataTypes[
                                                                              i] ==
                                                                          'bio'
                                                                      ? 2
                                                                      : 1,
                                                                  height: dataTypes[
                                                                              i] ==
                                                                          'bio'
                                                                      ? 1.4
                                                                      : 1.2,
                                                                  size: 1.3,
                                                                ),
                                                              ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                    ),
                                  // bottom_center
                                  if (dataLen != 1) SizedBox(width: vw),
                                  // bottom_right
                                  if (existLink)
                                    SizedBox(
                                      width: dataLen != 1 ? 41 * vw : 80 * vw,
                                      child: links.isEmpty
                                          ? Container()
                                          : Container(
                                              padding: EdgeInsets.fromLTRB(
                                                vw,
                                                2 * vw,
                                                0,
                                                0,
                                              ),
                                              child: SingleChildScrollView(
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    for (var i = 0;
                                                        i <
                                                            min(
                                                              links.length,
                                                              5,
                                                            );
                                                        i++)
                                                      if (links[i]['display']
                                                          ['normal'])
                                                        Container(
                                                          padding: EdgeInsets
                                                              .fromLTRB(
                                                            0,
                                                            vw,
                                                            0,
                                                            vw,
                                                          ),
                                                          child: OpenApp(
                                                            url: returnUrl(
                                                              links[i]['key'],
                                                              links[i]['value'],
                                                            ),
                                                          ),
                                                        ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
