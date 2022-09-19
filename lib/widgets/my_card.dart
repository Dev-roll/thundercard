import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:thundercard/constants.dart';

class MyCard extends StatelessWidget {
  const MyCard({Key? key, required this.uid}) : super(key: key);
  final String? uid;

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    CollectionReference cards = FirebaseFirestore.instance.collection('cards');

    return FutureBuilder(
        future: users.doc(uid).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }

          if (snapshot.hasData && !snapshot.data!.exists) {
            return Text("Document does not exist");
          }

          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> user =
                snapshot.data!.data() as Map<String, dynamic>;
            // return StreamBuilder<DocumentSnapshot<Object?>>(
            //   stream: cards.doc(user['my_cards'][0]).snapshots(),
            //   builder: (BuildContext context,
            //       AsyncSnapshot<DocumentSnapshot> snapshot) {
            //     if (snapshot.hasError) {
            //       return const Text('Something went wrong');
            //     }
            //     if (snapshot.connectionState == ConnectionState.waiting) {
            //       return const Text("Loading");
            //     }
            //     dynamic data = snapshot.data;
            return SizedBox(
                width: screenSize.width * 0.91,
                height: screenSize.width * 0.55,
                child: Card(
                  elevation: 10,
                  color: gray,
                  child: Column(children: [Text(user['my_cards'][0])]),
                ));
            //   },
            // );
          }
          return const Text('loading');
        });
  }
}
