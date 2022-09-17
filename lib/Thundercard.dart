import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:thundercard/constants.dart';
import 'package:thundercard/widgets/scan_qr_code.dart';
import 'widgets/my_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Thundercard extends StatefulWidget {
  const Thundercard(
      {Key? key, required this.uid, required this.type, required this.data})
      : super(key: key);
  final String? uid;

  final String type;
  final String data;

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
                // color: white,
                padding: EdgeInsets.only(bottom: 60),
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: MyCard(),
                    ),
                    Text(
                      'uid: ${widget.uid}',
                    ),
                    Text(
                      '${widget.type}: ${widget.data}',
                    ),
                    // const MyQrCode(name: 'cardseditor'),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const QRViewExample(),
          ));
        },
        // onPressed: () async {
        //   FirebaseFirestore.instance
        //       .collection('users')
        //       .doc('${widget.uid}')
        //       .set({'username': widget.uid});

        // FirebaseFirestore.instance
        //     .collection('autoCollection1')
        //     .doc('autoDocument1')
        //     .get()
        //     .then((ref) {
        //   returnVal = ref.get("userName");
        //   print(returnVal);
        // });
        // },
        icon: const Icon(
          Icons.qr_code_scanner_rounded,
          size: 24,
        ),
        label: Text(
          '名刺交換',
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
