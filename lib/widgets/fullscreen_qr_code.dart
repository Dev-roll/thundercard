import 'package:flutter/material.dart';
import 'package:thundercard/constants.dart';
import 'package:thundercard/widgets/my_qr_code.dart';

class FullscreenQrCode extends StatelessWidget {
  const FullscreenQrCode({Key? key, required this.name}) : super(key: key);
  final String name;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.onSecondary,
        body: SafeArea(
          child: Center(
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: MediaQuery.of(context).size.width * 0.8,
                        child: FittedBox(
                          child: MyQrCode(name: name),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        '@$name',
                        style:
                            TextStyle(fontSize: 32, color: Color(0xFFCCCCCC)),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(4, 8, 0, 0),
                    child: Hero(
                      tag: 'close_button',
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Icon(
                          Icons.close_rounded,
                          size: 32,
                          color: white,
                        ),
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          primary: Theme.of(context).colorScheme.onSecondary,
                          padding: EdgeInsets.all(16),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
