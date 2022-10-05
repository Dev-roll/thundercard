import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:thundercard/api/current_brightness.dart';
import 'package:thundercard/widgets/avatar.dart';

import '../api/return_original_color.dart';
import '../widgets/custom_progress_indicator.dart';
import '../account_editor.dart';
import '../constants.dart';

class CardInfo extends StatelessWidget {
  const CardInfo({
    Key? key,
    required this.cardId,
    required this.editable,
  }) : super(key: key);
  final String cardId;
  final bool editable;

  @override
  Widget build(BuildContext context) {
    CollectionReference cards = FirebaseFirestore.instance.collection('cards');
    var screenSize = MediaQuery.of(context).size;
    var vw = screenSize.width * 0.01;

    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('cards')
          .doc(cardId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('問題が発生しました');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CustomProgressIndicator();
        }

        dynamic data = snapshot.data;
        final account = data?['account'];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Theme(
                  data: ThemeData(
                    colorSchemeSeed: Color(returnOriginalColor(cardId)),
                    brightness:
                        currentBrightness(Theme.of(context).colorScheme) ==
                                Brightness.light
                            ? Brightness.light
                            : Brightness.dark,
                  ),
                  child: Avatar(),
                ),
                SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${account['profiles']['name']}',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                              softWrap: false,
                              overflow: TextOverflow.fade,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              '@$cardId',
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground
                                      .withOpacity(0.7)),
                              softWrap: false,
                              overflow: TextOverflow.fade,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (editable)
                  Container(
                    margin: EdgeInsets.only(left: 8),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              AccountEditor(data: data, cardId: cardId),
                        ));
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        primary:
                            Theme.of(context).colorScheme.secondaryContainer,
                        onPrimary: Theme.of(context).colorScheme.onBackground,
                        padding: EdgeInsets.all(8),
                      ),
                      child: const Icon(Icons.edit_rounded),
                    ),
                  ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: Column(
                children: [
                  SizedBox(
                    height: 8,
                  ),
                  if (account['profiles']['company']['value'] != '')
                    Container(
                      margin: EdgeInsets.only(bottom: 20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            iconTypeToIconData[linkTypeToIconType['company']],
                            size: 18,
                            color: Theme.of(context)
                                .colorScheme
                                .onBackground
                                .withOpacity(0.7),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                                '${account['profiles']['company']['value']}'),
                          ),
                        ],
                      ),
                    ),
                  if (account['profiles']['position']['value'] != '')
                    Container(
                      margin: EdgeInsets.only(bottom: 20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            iconTypeToIconData[linkTypeToIconType['position']],
                            // iconTypeToIconData[linkTypeToIconType['company']],
                            size: 18,
                            color: Theme.of(context)
                                .colorScheme
                                .onBackground
                                .withOpacity(0.7),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                                '${account['profiles']['position']['value']}'),
                          ),
                        ],
                      ),
                    ),
                  if (account['profiles']['address']['value'] != '')
                    Container(
                      margin: EdgeInsets.only(bottom: 20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            iconTypeToIconData[linkTypeToIconType['address']],
                            size: 18,
                            color: Theme.of(context)
                                .colorScheme
                                .onBackground
                                .withOpacity(0.7),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                                '${account['profiles']['address']['value']}'),
                          ),
                        ],
                      ),
                    ),
                  if (account['profiles']['bio']['value'] != '')
                    Container(
                      margin: EdgeInsets.only(bottom: 20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            iconTypeToIconData[linkTypeToIconType['bio']],
                            size: 18,
                            color: Theme.of(context)
                                .colorScheme
                                .onBackground
                                .withOpacity(0.7),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                              child: Text(
                                  '${account['profiles']['bio']['value']}')),
                        ],
                      ),
                    ),
                  // if (account['profiles']['bio']['value'] != '')
                  //   Container(
                  //     // padding: EdgeInsets.all(16),
                  //     width: double.infinity,
                  //     decoration: BoxDecoration(
                  //         // borderRadius: BorderRadius.circular(8),
                  //         // color: Theme.of(context)
                  //         //     .colorScheme
                  //         //     .primary
                  //         //     .withOpacity(0.08),
                  //         ),
                  //     child: Flexible(
                  //       child: Text(
                  //         '${account['profiles']['bio']['value']}',
                  //       ),
                  //     ),
                  //   ),
                  // icons
                  // SizedBox(
                  //   height: 32,
                  // ),
                  Column(
                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      for (var i = 0; i < account['links'].length; i++)
                        Container(
                          margin: EdgeInsets.only(bottom: 20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                iconTypeToIconData[linkTypeToIconType[
                                    account['links'][i]['key']]],
                                size: 18,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onBackground
                                    .withOpacity(0.7),
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                  child:
                                      Text('${account['links'][i]['value']}')),
                            ],
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
  }
}
