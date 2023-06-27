import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thundercard/providers/firebase_firestore.dart';
import 'package:thundercard/ui/component/custom_skeletons/skeleton_card.dart';
import 'package:thundercard/ui/component/image_with_url.dart';

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
        return ImageWithUrl(url: c20r11u11d11?['card_url']);
      },
    );
  }
}
