import 'package:flutter/material.dart';

class SkeletonCard extends StatelessWidget {
  const SkeletonCard({super.key});

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var vw = screenSize.width * 0.01;
    return Container(
      width: 91 * vw,
      height: 55 * vw,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(3 * vw),
      ),
    );
  }
}
