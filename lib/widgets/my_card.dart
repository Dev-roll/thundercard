import 'package:flutter/material.dart';
import 'package:thundercard/constants.dart';

class MyCard extends StatelessWidget {
  const MyCard({Key? key, required this.cardId}) : super(key: key);
  final String? cardId;

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return SizedBox(
        width: screenSize.width * 0.91,
        height: screenSize.width * 0.55,
        child: Card(
          elevation: 10,
          color: gray,
          child: Column(children: [Text('$cardId')]),
        ));
  }
}
