import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thundercard/widgets/preview_img.dart';

import '../api/provider/firebase_firestore.dart';
import 'custom_progress_indicator.dart';
import 'custom_skeletons/skeleton_card.dart';
import 'error_message.dart';

class CardImg extends ConsumerWidget {
  const CardImg({Key? key, required this.cardId}) : super(key: key);
  final String cardId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c20r11u11d11AsyncValue = ref.watch(c20r11u11d11Stream(cardId));
    return c20r11u11d11AsyncValue.when(
      error: (err, _) => Text(
        '$err',
        style: TextStyle(color: Theme.of(context).colorScheme.error),
      ),
      loading: () => const Center(
        child: SkeletonCard(),
      ),
      data: (c20r11u11d11) {
        return Stack(
          children: [
            const CustomProgressIndicator(),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) {
                    return PreviewImg(
                      image: Image.network(
                        c20r11u11d11?['card_url'],
                      ),
                    );
                  }),
                );
              },
              child: Hero(
                tag: 'card_image',
                child: Image.network(
                  c20r11u11d11?['card_url'],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
