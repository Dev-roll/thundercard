import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../utils/colors.dart';

class CustomPre extends StatelessWidget {
  final String text;

  const CustomPre({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        Stack(
          alignment: Alignment.topRight,
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: alphaBlend(
                  Theme.of(context).colorScheme.primary.withOpacity(0.12),
                  Theme.of(context).colorScheme.surface,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 52, 6),
                  child: SelectableText(
                    text,
                    style: GoogleFonts.robotoMono(
                      textStyle: TextStyle(
                        color: Theme.of(context).colorScheme.onBackground,
                        fontSize: 12,
                      ),
                    ),
                    scrollPhysics: const NeverScrollableScrollPhysics(),
                  ),
                ),
              ),
            ),
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: alphaBlend(
                  Theme.of(context).colorScheme.primary.withOpacity(0.12),
                  Theme.of(context).colorScheme.surface,
                ).withOpacity(0.75),
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            IconButton(
              onPressed: () {
                final data = ClipboardData(text: text);
                Clipboard.setData(data);
              },
              tooltip: 'クリップボードにコピー',
              style: IconButton.styleFrom(
                focusColor: Theme.of(context)
                    .colorScheme
                    .onSurfaceVariant
                    .withOpacity(0.12),
                highlightColor:
                    Theme.of(context).colorScheme.onSurface.withOpacity(0.12),
              ),
              icon: Icon(
                Icons.content_copy_rounded,
                color: Theme.of(context)
                    .colorScheme
                    .onBackground
                    .withOpacity(0.75),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class CustomPreBuilder extends MarkdownElementBuilder {
  @override
  Widget visitText(text, TextStyle? preferredStyle) {
    return CustomPre(text: text.text);
  }
}
