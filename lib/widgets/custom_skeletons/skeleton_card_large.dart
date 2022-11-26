import 'package:flutter/material.dart';

class SkeletonCardLarge extends StatelessWidget {
  const SkeletonCardLarge({
    super.key,
    required this.pd,
  });
  final double pd;

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var vw = screenSize.width * 0.01;
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height - pd,
      ),
      child: FittedBox(
        child: Container(
          width: 91 * vw,
          height: 91 * 91 * vw / 55,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceVariant,
            borderRadius: BorderRadius.circular(3 * vw),
          ),
        ),
      ),
    );
  }
}
