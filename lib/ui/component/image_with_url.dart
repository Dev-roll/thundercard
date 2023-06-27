import 'package:flutter/material.dart';
import 'package:thundercard/ui/component/preview_img.dart';

class ImageWithUrl extends StatelessWidget {
  const ImageWithUrl({Key? key, required this.url}) : super(key: key);
  final String url;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return PreviewImg(
                image: Image.network(
                  url.toString(),
                  frameBuilder:
                      (context, child, frame, wasSynchronouslyLoaded) {
                    return child;
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    }
                    int loaded = loadingProgress.cumulativeBytesLoaded;
                    int expected = loadingProgress.expectedTotalBytes ?? 1;
                    double? value = loaded / expected;
                    return Center(
                      child: SizedBox(
                        width: 40,
                        height: 40,
                        child: CircularProgressIndicator(
                          value: value,
                          color: Theme.of(context).colorScheme.primary,
                          backgroundColor: Theme.of(context)
                              .colorScheme
                              .onPrimary
                              .withOpacity(0.5),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        );
      },
      child: Hero(
        tag: 'card_image',
        child: Image.network(
          url.toString(),
          frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
            return child;
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) {
              return child;
            }
            int loaded = loadingProgress.cumulativeBytesLoaded;
            int expected = loadingProgress.expectedTotalBytes ?? 1;
            double? value = loaded / expected;
            return AspectRatio(
              aspectRatio: 16 / 9,
              child: Center(
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(
                    value: value,
                    color: Theme.of(context).colorScheme.primary,
                    backgroundColor: Theme.of(context)
                        .colorScheme
                        .onPrimary
                        .withOpacity(0.5),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
