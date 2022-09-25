import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:thundercard/custom_progress_indicator.dart';
import '../account_editor.dart';

class CardInfo extends StatelessWidget {
  const CardInfo({
    Key? key,
    required this.cardId,
    required this.display,
    required this.editable,
  }) : super(key: key);
  final String cardId;
  final String display;
  final bool editable;

  @override
  Widget build(BuildContext context) {
    CollectionReference cards = FirebaseFirestore.instance.collection('cards');

    return StreamBuilder(
      stream: cards
          .doc(cardId)
          .collection('account')
          .where('display.$display', isEqualTo: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CustomProgressIndicator();
        }

        dynamic data = snapshot.data;
        final profiles = data?.docs;

        return Column(
          children: [
            editable
                ? OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            AccountEditor(data: profiles, cardId: cardId),
                      ));
                    },
                    child: const Text('プロフィールを編集'))
                : Container(),
            ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: profiles.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      profiles[index]['display'][display]
                          ? Text('${profiles[index]['key']}: ${profiles[index]['value']}')
                          : Container(),
                    ],
                  );
                }),
          ],
        );
      },
    );
  }
}
