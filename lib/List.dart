import 'package:flutter/material.dart';

class List extends StatelessWidget {
  const List({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const SafeArea(
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
        child: const Icon(
          Icons.add_a_photo_rounded,
        ),
      ),
    );
  }
}
