import 'package:flutter/material.dart';

class SkeletonCard extends StatelessWidget {
  const SkeletonCard({super.key});

  @override
  Widget build(BuildContext context) {
    // return CircularProgressIndicator();
    var screenSize = MediaQuery.of(context).size;
    var vw = screenSize.width * 0.01;
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxHeight: 400,
      ),
      child: FittedBox(
        child: Container(
          width: 91 * vw,
          height: 55 * vw,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceVariant,
            borderRadius: BorderRadius.circular(3 * vw),
          ),
        ),
      ),
    );
  }
}
