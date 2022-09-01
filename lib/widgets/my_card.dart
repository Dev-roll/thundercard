import 'package:flutter/material.dart';
import 'package:thundercard/constants.dart';

class MyCard extends StatelessWidget {
  const MyCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _screenSize = MediaQuery.of(context).size;
    return SizedBox(
        width: _screenSize.width * 0.91,
        height: _screenSize.width * 0.55,
        child: const Card(
          elevation: 10,
          color: gray,
        ));
  }
}
