import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../account_editor.dart';
import '../custom_progress_indicator.dart';

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
          children: [
            editable
                ? OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            AccountEditor(data: account, cardId: cardId),
                      ));
                    },
                    child: const Text('プロフィールを編集'))
                : Container(),
            Text('id（変更不可）: @$cardId'),
            Text('name: ${account['profiles']['name']}'),
            Text('bio: ${account['profiles']['bio']['value']}'),
            Text('company: ${account['profiles']['company']['value']}'),
            Text('position: ${account['profiles']['position']['value']}'),
            Text('address: ${account['profiles']['address']['value']}'),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: account['links'].length ?? 0,
              itemBuilder: (context, index) {
                return Text(
                    '${account['links'][index]['key']}: ${account['links'][index]['value']}');
              },
            ),
          ],
        );
      },
    );
  }
}
