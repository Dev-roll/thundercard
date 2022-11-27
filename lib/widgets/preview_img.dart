import 'package:flutter/material.dart';

class PreviewImg extends StatelessWidget {
  const PreviewImg({
    super.key,
    required this.image,
  });
  final Widget image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: InteractiveViewer(
                    minScale: 0.1,
                    maxScale: 4,
                    child: Hero(
                      tag: 'card_image',
                      child: image,
                    ),
                  ),
                ),
              ],
            ),
            IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(
                Icons.close_rounded,
                size: 32,
              ),
              padding: const EdgeInsets.all(12),
            ),
          ],
        ),
      ),
    );
  }
}
