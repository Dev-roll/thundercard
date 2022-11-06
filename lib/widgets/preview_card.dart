import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:thundercard/widgets/avatar.dart';
import 'card_element.dart';

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
          Align(
            alignment: const Alignment(0.85, 0.3),
            child: SvgPicture.string(
              color: Theme.of(context).colorScheme.secondary.withOpacity(0.08),
              '<svg width="400" height="400" viewBox="0 0 400 400" fill="#ffffff" xmlns="http://www.w3.org/2000/svg"><path d="M193.367 13.2669C197.432 5.13606 205.742 0 214.833 0H260.584C269.504 0 275.306 9.38775 271.317 17.3666L174.633 210.733C170.568 218.864 162.258 224 153.167 224H107.416C98.4958 224 92.6939 214.612 96.6833 206.633L193.367 13.2669Z"/><path d="M225.367 189.267C229.432 181.136 237.742 176 246.833 176H292.584C301.504 176 307.306 185.388 303.317 193.367L206.633 386.733C202.568 394.864 194.258 400 185.167 400H139.416C130.496 400 124.694 390.612 128.683 382.633L225.367 189.267Z"/></svg>',
              width: 16 * vw,
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(6 * vw, 4 * vw, 4 * vw, 4 * vw),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3 * vw),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // avatar
                const Avatar(),
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
