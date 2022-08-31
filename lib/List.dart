import 'package:flutter/material.dart';

class List extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Scrollbar(
          child: SingleChildScrollView(
            child: Center(
              child: Text('hello, list!'),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {},
        child: Icon(
          Icons.add_a_photo_rounded,
        ),
      ),
    );
  }
}
