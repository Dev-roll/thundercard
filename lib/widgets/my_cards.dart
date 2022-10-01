import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../widgets/custom_progress_indicator.dart';

class MyCards extends StatefulWidget {
  const MyCards({Key? key, required this.uid}) : super(key: key);
  final String? uid;

  @override
  State<MyCards> createState() => _MyCardsState();
}

class _MyCardsState extends State<MyCards> {
  Future<String> getThumbnail(String cardId) async {
    final storageRef = FirebaseStorage.instance.ref();
    final imageUrl =
        await storageRef.child("cards/$cardId/card.jpg").getDownloadURL();
    return imageUrl;
  }

  late final Stream<DocumentSnapshot<Map<String, dynamic>>> _myCardsStream =
      FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: _myCardsStream,
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('問題が発生しました');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CustomProgressIndicator();
        }
        dynamic data = snapshot.data;
        // Map<String, dynamic> data = snapshot.data as Map<String, dynamic>;
        return data['my_cards'] == null
            ? const Text('名刺の情報の取得に失敗しました')
            : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: data['my_cards'].length,
                itemBuilder: (context, index) {
                  final cardId = data['my_cards'][index];
                  return ListTile(
                    leading: FutureBuilder<String>(
                      future: getThumbnail(cardId),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Image.network(snapshot.data!);
                        } else {
                          return const CustomProgressIndicator();
                        }
                      },
                    ),
                    title: Text(cardId),
                  );
                },
              );
      },
    );
  }
}
