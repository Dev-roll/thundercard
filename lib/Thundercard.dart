import 'package:flutter/material.dart';
import 'package:thundercard/main.dart';

class Thundercard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'hello, thundercard!',
          style: TextStyle(),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => {},
        icon: Icon(
          Icons.swap_horiz_rounded,
          size: 32,
        ),
        label: Text('EXCHANGE'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
