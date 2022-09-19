import 'package:flutter/material.dart';
import 'package:thundercard/widgets/scan_qr_code.dart';
import 'api/firebase_auth.dart';
import 'widgets/my_card.dart';

class Thundercard extends StatefulWidget {
  const Thundercard({Key? key, required this.type, required this.data})
      : super(key: key);
  final String type;
  final String data;

  @override
  State<Thundercard> createState() => _ThundercardState();
}

class _ThundercardState extends State<Thundercard> {
  final String? uid = getUid();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Scrollbar(
          child: SingleChildScrollView(
            child: Center(
              child: Container(
                padding: const EdgeInsets.only(bottom: 60),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: MyCard(uid: uid),
                    ),
                    // MyCards(uid: uid),
                    Text('uid: $uid'),
                    Text('${widget.type}: ${widget.data}'),
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
        icon: const Icon(
          Icons.qr_code_scanner_rounded,
          size: 24,
        ),
        label: const Text('名刺交換'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
