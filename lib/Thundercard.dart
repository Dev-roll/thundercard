import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:thundercard/constants.dart';
import 'package:thundercard/widgets/my_qr_code.dart';
import 'widgets/my_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Thundercard extends StatefulWidget {
  Thundercard({Key? key, required this.name}) : super(key: key);

  final String name;

  @override
  State<Thundercard> createState() => _ThundercardState();
}

class _ThundercardState extends State<Thundercard> {
  String _returnVal = '';

  void fetch_name() async {
    FirebaseFirestore.instance
        .collection('autoCollection1')
        .doc('autoDocument1')
        .get()
        .then((ref) {
      _returnVal = ref.get("userName");
      print(_returnVal);
    });
  }

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
                      'hello, ${widget.name}',
                    ),
                    const MyQrCode(name: 'cardseditor')
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          // FirebaseFirestore.instance
          //     .doc('autoCollection1/autoDocument1')
          //     .set({'userName': widget.name});

          // FirebaseFirestore.instance
          //     .collection('autoCollection1')
          //     .doc('autoDocument1')
          //     .get()
          //     .then((ref) {
          //   returnVal = ref.get("userName");
          //   print(returnVal);
          // });
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
