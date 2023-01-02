import 'package:flutter/material.dart';

class SkeletonCardInfo extends StatelessWidget {
  const SkeletonCardInfo({super.key});

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var vw = screenSize.width * 0.01;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Stack(
              children: [
                Align(
                  alignment: const Alignment(0, 0),
                  child: Container(
                    width: 68,
                    height: 68,
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .onBackground
                          .withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 120,
                        height: 26,
                        margin: const EdgeInsets.fromLTRB(0, 0, 0, 4),
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .onBackground
                              .withOpacity(0.3),
                          borderRadius: BorderRadius.circular(13),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        width: 80,
                        height: 16,
                        margin: const EdgeInsets.fromLTRB(0, 4, 0, 0),
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .onBackground
                              .withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 8),
              child: ElevatedButton(
                onPressed: null,
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  padding: const EdgeInsets.all(8),
                ),
                child: const Icon(Icons.edit_rounded),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Container(
          margin: const EdgeInsets.all(12),
          height: 16,
          width: 60 * vw,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onBackground.withOpacity(0.3),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        Container(
          margin: const EdgeInsets.all(12),
          height: 16,
          width: 32 * vw,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onBackground.withOpacity(0.3),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        Container(
          margin: const EdgeInsets.all(12),
          height: 16,
          width: 40 * vw,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onBackground.withOpacity(0.3),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
