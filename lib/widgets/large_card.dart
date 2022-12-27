// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:thundercard/api/provider/firebase_firestore.dart';
import 'package:thundercard/widgets/avatar.dart';
import '../constants.dart';
import '../api/return_url.dart';
import 'card_element.dart';
import 'open_app.dart';

class LargeCard extends ConsumerWidget {
  const LargeCard({
    Key? key,
    required this.cardId,
  }) : super(key: key);
  final String cardId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var screenSize = MediaQuery.of(context).size;
    var vw = screenSize.width * 0.01;
    final double paddingX = 3 * vw;

    final c10r20u10d10AsyncValue = ref.watch(c10r20u10d10Stream(cardId));
    return c10r20u10d10AsyncValue.when(
      error: (err, _) => Text(err.toString()), //エラー時
      loading: () => const CircularProgressIndicator(), //読み込み時
      data: (c10r20u10d10) {
        final c10r21u10d10AsyncValue = ref.watch(c10r21u10d10Stream(cardId));
        return c10r21u10d10AsyncValue.when(
          error: (err, _) => Text(err.toString()), //エラー時
          loading: () => const CircularProgressIndicator(), //読み込み時
          data: (c10r21u10d10) {
            final c21r20u00d11AsyncValue =
                ref.watch(c21r20u00d11Stream(cardId));
            return c21r20u00d11AsyncValue.when(
              error: (err, _) => Text(err.toString()), //エラー時
              loading: () => const CircularProgressIndicator(), //読み込み時
              data: (c21r20u00d11) {
                final profiles = c10r21u10d10?['profiles'];
                final links = c10r21u10d10?['account']['links'];
                const dataTypeList = dataTypes;
                final name = c10r20u10d10?['name'];

                return SizedBox(
                  width: 91 * vw,
                  height: 91 * 91 * vw / 55,
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
                        alignment: const Alignment(0.75, 0.75),
                        child: SvgPicture.string(
                          color: Theme.of(context)
                              .colorScheme
                              .secondary
                              .withOpacity(0.08),
                          '<svg width="400" height="400" viewBox="0 0 400 400" fill="#ffffff" xmlns="http://www.w3.org/2000/svg"><path d="M193.367 13.2669C197.432 5.13606 205.742 0 214.833 0H260.584C269.504 0 275.306 9.38775 271.317 17.3666L174.633 210.733C170.568 218.864 162.258 224 153.167 224H107.416C98.4958 224 92.6939 214.612 96.6833 206.633L193.367 13.2669Z"/><path d="M225.367 189.267C229.432 181.136 237.742 176 246.833 176H292.584C301.504 176 307.306 185.388 303.317 193.367L206.633 386.733C202.568 394.864 194.258 400 185.167 400H139.416C130.496 400 124.694 390.612 128.683 382.633L225.367 189.267Z"/></svg>',
                          width: 40 * vw,
                        ),
                      ),
                      Container(
                        padding:
                            EdgeInsets.fromLTRB(5 * vw, 6 * vw, 6 * vw, 5 * vw),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3 * vw),
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 36 * vw,
                              child: Column(
                                children: [
                                  const Avatar(),
                                  Flexible(
                                      child: name == null
                                          ? Container()
                                          : Container(
                                              padding: EdgeInsets.fromLTRB(
                                                  2 * vw,
                                                  0 * vw,
                                                  2 * vw,
                                                  0 * vw),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    name,
                                                    style: TextStyle(
                                                      fontSize: 2 * vw * 3,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .onSecondaryContainer
                                                          .withOpacity(0.7),
                                                      height: 1.2,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      letterSpacing: 1.5,
                                                    ),
                                                    maxLines: 1,
                                                    overflow: TextOverflow.fade,
                                                    softWrap: false,
                                                  ),
                                                  if (c21r20u00d11?['is_user'])
                                                    Text(
                                                      '@$cardId',
                                                      style: TextStyle(
                                                        fontSize: 2 * vw * 1.5,
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .onSecondaryContainer
                                                            .withOpacity(0.5),
                                                        height: 1.2,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        letterSpacing: 0.2,
                                                      ),
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.fade,
                                                      softWrap: false,
                                                    ),
                                                ],
                                              ),
                                            )),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            Divider(
                              height: 1,
                              thickness: 1,
                              indent: 1 * vw,
                              endIndent: 1 * vw,
                              color: Theme.of(context)
                                  .colorScheme
                                  .outline
                                  .withOpacity(0.5),
                            ),
                            Flexible(
                              child: profiles == null
                                  ? Container()
                                  : SingleChildScrollView(
                                      child: Container(
                                        padding: EdgeInsets.fromLTRB(
                                            4 * vw, 0 * vw, 4 * vw, 0 * vw),
                                        child: Column(
                                          children: [
                                            const SizedBox(height: 16),
                                            for (var i = 0;
                                                i < dataTypeList.length;
                                                i++)
                                              if (profiles[dataTypeList[i]]
                                                          ['value'] !=
                                                      '' &&
                                                  profiles[dataTypeList[i]]
                                                      ['display']['normal'])
                                                dataTypeList[i] == 'address'
                                                    ? Container(
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                                0,
                                                                paddingX,
                                                                0,
                                                                paddingX),
                                                        alignment:
                                                            Alignment.center,
                                                        child: OpenApp(
                                                          url: returnUrl(
                                                              'address',
                                                              profiles[
                                                                      dataTypeList[
                                                                          i]]
                                                                  ['value']),
                                                          large: true,
                                                        ),
                                                      )
                                                    : Container(
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                                0,
                                                                paddingX,
                                                                0,
                                                                paddingX),
                                                        alignment:
                                                            Alignment.center,
                                                        child: CardElement(
                                                          txt: profiles[
                                                                      dataTypeList[
                                                                          i]]
                                                                  ['value'] ??
                                                              '',
                                                          type: linkTypeToIconType[
                                                                  dataTypeList[
                                                                      i]] ??
                                                              IconType.nl,
                                                          line:
                                                              dataTypeList[i] ==
                                                                      'bio'
                                                                  ? 300
                                                                  : 1,
                                                          height:
                                                              dataTypeList[i] ==
                                                                      'bio'
                                                                  ? 1.4
                                                                  : 1.2,
                                                          size: 1.4,
                                                          large: true,
                                                        ),
                                                      ),
                                            for (var i = 0;
                                                i < links.length;
                                                i++)
                                              if (links[i]['display']['normal'])
                                                Container(
                                                  padding: EdgeInsets.fromLTRB(
                                                      0, paddingX, 0, paddingX),
                                                  alignment: Alignment.center,
                                                  child: OpenApp(
                                                    url: returnUrl(
                                                        links[i]['key'],
                                                        links[i]['value']),
                                                    large: true,
                                                  ),
                                                ),
                                            const SizedBox(height: 16),
                                          ],
                                        ),
                                      ),
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
