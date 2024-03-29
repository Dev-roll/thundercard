import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thundercard/ui/component/my_qr_code.dart';

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
        body: Center(
          child: Stack(
            children: [
              SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: MediaQuery.of(context).size.width * 0.8,
                      child: FittedBox(
                        child: MyQrCode(myCardId: name),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      '@$name',
                      style: GoogleFonts.quicksand(
                        fontSize: 32,
                        color: const Color(0xFFCCCCCC),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    8,
                    8 + MediaQuery.of(context).padding.top,
                    0,
                    0,
                  ),
                  child: Hero(
                    tag: 'back_button',
                    child: IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: Icon(
                        Icons.arrow_back_rounded,
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                      padding: const EdgeInsets.all(16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
