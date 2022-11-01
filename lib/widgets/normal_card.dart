import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:thundercard/widgets/avatar.dart';
import '../constants.dart';
import '../api/return_url.dart';
import 'card_element.dart';
import 'open_app.dart';

class NormalCard extends StatelessWidget {
  const NormalCard({
    Key? key,
    required this.cardId,
  }) : super(key: key);
  final String cardId;

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var vw = screenSize.width * 0.01;

    return SizedBox(
      width: 91 * vw,
      height: 55 * vw,
      child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('cards')
              .doc(cardId)
              .snapshots(),
          builder: (context, snapshot) {
            dynamic data = snapshot.data;
            final name = data?['account']['profiles']['name'];
            final Map profiles = data?['account']['profiles'] ?? {};
            final List links = data?['account']['links'] ?? [];
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

            return Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3 * vw),
                    color: Theme.of(context).colorScheme.secondaryContainer,
                  ),
                ),
                Align(
                  alignment: const Alignment(1.6, 2.8),
                  child: Icon(
                    Icons.bolt_rounded,
                    color: Theme.of(context)
                        .colorScheme
                        .secondary
                        .withOpacity(0.08),
                    size: 52 * vw,
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(4 * vw, 4 * vw, 4 * vw, 4 * vw),
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
                            const Avatar(),
                            // name etc
                            Flexible(
                              child: name == null
                                  ? Container()
                                  : Container(
                                      padding: EdgeInsets.fromLTRB(
                                          2 * vw, 0 * vw, 0 * vw, 0 * vw),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          CardElement(
                                            txt: name ?? '',
                                            size: 3,
                                            weight: 'bold',
                                            opacity: 0.7,
                                          ),
                                          if (data?['is_user'])
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
                                            vw, 2 * vw, 0, vw),
                                        child: SingleChildScrollView(
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              for (var i = 0;
                                                  i < min(dataTypes.length, 5);
                                                  i++)
                                                if (profiles[dataTypes[i]]
                                                            ['value'] !=
                                                        '' &&
                                                    profiles[dataTypes[i]]
                                                        ['display']['normal'])
                                                  dataTypes[i] == 'address'
                                                      ? Container(
                                                          padding: EdgeInsets
                                                              .fromLTRB(
                                                                  0, vw, 0, vw),
                                                          child: OpenApp(
                                                            url: returnUrl(
                                                              'address',
                                                              profiles[
                                                                      dataTypes[
                                                                          i]]
                                                                  ['value'],
                                                            ),
                                                          ),
                                                        )
                                                      : Container(
                                                          padding: EdgeInsets
                                                              .fromLTRB(
                                                                  0, vw, 0, vw),
                                                          child: CardElement(
                                                            txt: profiles[
                                                                        dataTypes[
                                                                            i]]
                                                                    ['value'] ??
                                                                '',
                                                            type: linkTypeToIconType[
                                                                    dataTypes[
                                                                        i]] ??
                                                                IconType.nl,
                                                            line:
                                                                dataTypes[i] ==
                                                                        'bio'
                                                                    ? 2
                                                                    : 1,
                                                            height:
                                                                dataTypes[i] ==
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
                                            vw, 2 * vw, 0, 0),
                                        child: SingleChildScrollView(
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              for (var i = 0;
                                                  i < min(links.length, 5);
                                                  i++)
                                                if (links[i]['display']
                                                    ['normal'])
                                                  Container(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            0, vw, 0, vw),
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
            );
          }),
    );
  }
}
