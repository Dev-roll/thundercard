import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../constants.dart';

class CardElement extends StatelessWidget {
  CardElement({
    Key? key,
    required this.txt,
    this.type = IconType.nl,
    this.line = 1,
    this.size = 1,
    this.weight = 'regular',
    this.height = 1,
    this.opacity = 1,
  }) : super(key: key);
  String? txt;
  IconType type;
  int line;
  double size;
  String weight;
  double height;
  double opacity;

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var vw = screenSize.width * 0.01;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        type != IconType.nl
            ? Row(
                children: [
                  Icon(
                    iconTypeToIconData[type],
                    size: 4 * vw,
                    color: type != IconType.company
                        ? Theme.of(context).colorScheme.tertiary
                        : Theme.of(context).colorScheme.secondary,
                  ),
                  SizedBox(
                    width: 1.5 * vw,
                  )
                ],
              )
            : const Text(''),
        Flexible(
          child: Container(
            child: Text(
              '$txt',
              style: TextStyle(
                fontSize: 2 * vw * size,
                color: type == IconType.nl &&
                        line == 1 //アイコンなし1行: onSecondaryContainer
                    ? Theme.of(context)
                        .colorScheme
                        .onSecondaryContainer
                        .withOpacity(opacity)
                    : type == IconType.nl //アイコンなし複数行: onSecondaryContainer(0.8)
                        ? Theme.of(context)
                            .colorScheme
                            .onSecondaryContainer
                            .withOpacity(0.8 * opacity)
                        : type !=
                                IconType
                                    .company //アイコンcompany以外（リンク）: onTertiaryContainer
                            ? Theme.of(context)
                                .colorScheme
                                .onTertiaryContainer
                                // .tertiary
                                .withOpacity(opacity)
                            : Theme.of(context) //company: onSecondaryContainer
                                .colorScheme
                                .onSecondaryContainer
                                .withOpacity(opacity),
                height: height,
                fontWeight:
                    weight == 'bold' ? FontWeight.bold : FontWeight.normal,
                letterSpacing:
                    weight == 'bold' ? 1.5 : 0.2,
              ),
              maxLines: line,
              overflow: line == 1 ? TextOverflow.fade : TextOverflow.ellipsis,
              softWrap: line == 1 ? false : true,
            ),
          ),
        ),
      ],
    );
  }
}
