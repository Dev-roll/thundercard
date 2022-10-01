import 'dart:ffi';

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
          return const Text('Something went wrong');
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Theme(
                      data: ThemeData(
                        colorSchemeSeed: Color(returnOriginalColor(cardId)),
                        brightness: Brightness.light,
                      ),
                      child: Avatar(),
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${account['profiles']['name']}',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (data?['is_user'])
                          Text(
                            '@$cardId',
                            style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onBackground
                                    .withOpacity(0.7)),
                          ),
                      ],
                    ),
                  ],
                ),
                if (editable)
                  ElevatedButton(
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
                      child: const Icon(Icons.edit_rounded)),
              ],
            ),
            SizedBox(
              height: 12,
            ),
            if (account['profiles']['bio']['value'] != '')
              Container(
                padding: EdgeInsets.all(16),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Theme.of(context)
                      .colorScheme
                      .onBackground
                      .withOpacity(0.08),
                ),
                child: Flexible(
                  child: Text(
                    '${account['profiles']['bio']['value']}',
                  ),
                ),
              ),
            // icons
            Container(
              padding: EdgeInsets.fromLTRB(8, 32, 8, 0),
              child: Column(
                children: [
                  account['profiles']['company']['value'] != ''
                      ? Row(
                          children: [
                            Icon(
                              iconTypeToIconData[linkTypeToIconType['company']],
                              size: 16,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onBackground
                                  .withOpacity(0.7),
                            ),
                            SizedBox(width: 8),
                            Text('${account['profiles']['company']['value']}'),
                          ],
                        )
                      : Container(),
                  SizedBox(
                    height: 20,
                  ),
                  account['profiles']['position']['value'] != ''
                      ? Row(
                          children: [
                            Icon(
                              iconTypeToIconData[linkTypeToIconType['company']],
                              size: 16,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onBackground
                                  .withOpacity(0.7),
                            ),
                            SizedBox(width: 8),
                            Text('${account['profiles']['position']['value']}'),
                          ],
                        )
                      : Container(),
                  account['profiles']['address']['value'] != ''
                      ? Row(
                          children: [
                            Icon(
                              iconTypeToIconData[linkTypeToIconType['company']],
                              size: 16,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onBackground
                                  .withOpacity(0.7),
                            ),
                            SizedBox(width: 8),
                            Text('${account['profiles']['address']['value']}'),
                          ],
                        )
                      : Container(),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      for (var i = 0; i < account['links'].length; i++)
                        Column(
                          children: [
                            Row(
                              children: [
                                Icon(
                                  iconTypeToIconData[linkTypeToIconType[
                                      account['links'][i]['key']]],
                                  size: 16,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground
                                      .withOpacity(0.7),
                                ),
                                SizedBox(width: 8),
                                Text('${account['links'][i]['value']}'),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            )
                          ],
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
