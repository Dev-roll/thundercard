import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:thundercard/widgets/avatar.dart';
import '../constants.dart';
import '../api/return_url.dart';
import 'card_element.dart';
import 'open_app.dart';

class PreviewCard extends StatelessWidget {
  const PreviewCard({
    Key? key,
    required this.cardId,
  }) : super(key: key);
  final String cardId;

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var vw = screenSize.width * 0.01;

    return SizedBox(
      width: 60 * vw,
      height: 40 * vw,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3 * vw),
              color: Theme.of(context).colorScheme.secondaryContainer,
            ),
          ),
          // Align(
          //   alignment: const Alignment(1.6, 2.8),
          //   child: Icon(
          //     Icons.bolt_rounded,
          //     color: Theme.of(context).colorScheme.secondary.withOpacity(0.08),
          //     size: 52 * vw,
          //   ),
          // ),
          Container(
            padding: EdgeInsets.fromLTRB(8 * vw, 4 * vw, 4 * vw, 4 * vw),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3 * vw),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // avatar
                Avatar(),
                // name etc
                Flexible(
                  child: Container(
                    padding:
                        EdgeInsets.fromLTRB(4 * vw, 0 * vw, 0 * vw, 0 * vw),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CardElement(
                          txt: cardId,
                          size: 3,
                          weight: 'bold',
                          opacity: 0.7,
                        ),
                        CardElement(
                          txt: '@$cardId',
                          size: 1.5,
                          opacity: 0.5,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
