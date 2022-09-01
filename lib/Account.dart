import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Account extends StatefulWidget {
  const Account({
    Key? key,
  }) : super(key: key);
  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  String _inputVal = '';
  String _returnVal = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Scrollbar(
          child: SingleChildScrollView(
              child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        _inputVal = value;
                      });
                    },
                    // obscureText: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Your Name',
                      hintText: 'Enter your name',
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        FirebaseFirestore.instance
                            .doc('autoCollection1/autoDocument1')
                            .set({'userName': _inputVal});

                        FirebaseFirestore.instance
                            .collection('autoCollection1')
                            .doc('autoDocument1')
                            .get()
                            .then((ref) {
                          _returnVal = ref.get("userName");
                          print(_returnVal);
                        });
                      },
                      child: const Text('Submit')),
                  Text(_returnVal),
                ],
              ),
            ),
          )),
        ),
      ),
    );
  }
}
