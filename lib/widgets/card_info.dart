import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:thundercard/custom_progress_indicator.dart';
import '../account_editor.dart';

class CardInfo extends StatelessWidget {
  const CardInfo({Key? key, required this.cardId, required this.editable})
      : super(key: key);
  final String cardId;
  final bool editable;

  @override
  Widget build(BuildContext context) {
    CollectionReference cards = FirebaseFirestore.instance.collection('cards');

    return StreamBuilder<DocumentSnapshot<Object?>>(
      stream: cards.doc(cardId).snapshots(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CustomProgressIndicator();
        }
        dynamic data = snapshot.data;
        return Column(
          children: [
            editable
                ? OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            AccountEditor(data: data, cardId: cardId),
                      ));
                    },
                    child: const Text('プロフィールを編集'))
                : Container(),
            Text('username: ${data?['name']}'),
            data?['bio'] != '' ? Text('bio: ${data?['bio']}') : Container(),
            data?['url'] != '' ? Text('URL: ${data?['url']}') : Container(),
            data?['twitter'] != ''
                ? Text('Twitter: ${data?['twitter']}')
                : Container(),
            data?['github'] != ''
                ? Text('GitHub: ${data?['github']}')
                : Container(),
            data?['company'] != ''
                ? Text('company: ${data?['company']}')
                : Container(),
            data?['email'] != ''
                ? Text('email: ${data?['email']}')
                : Container(),
          ],
        );
      },
    );
  }
}
