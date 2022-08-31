import 'package:flutter/material.dart';
import 'package:thundercard/variable.dart';
import 'widgets/card.dart';

class Thundercard extends StatelessWidget {
  const Thundercard({Key? key, required this.name}) : super(key: key);

  final String name;

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
        onPressed: () => {},
        icon: Icon(
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
