import 'package:flutter/material.dart';
import 'package:thundercard/constants.dart';
import 'widgets/my_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Thundercard extends StatelessWidget {
  Thundercard({Key? key, required this.name}) : super(key: key);

  final String name;
  String returnVal = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Scrollbar(
          child: SingleChildScrollView(
            child: Center(
              child: Container(
                color: white,
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: MyCard(),
                    ),
                    Text(
                      'hello, $name',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          FirebaseFirestore.instance
              .doc('autoCollection1/autoDocument1')
              .set({'userName': name});

          FirebaseFirestore.instance
              .collection('autoCollection1')
              .doc('autoDocument1')
              .get()
              .then((ref) {
            returnVal = ref.get("userName");
            print(returnVal);
          });
        },
        icon: const Icon(
          Icons.swap_horiz_rounded,
          size: 32,
        ),
        label: Text(
          'EXCHANGE',
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
