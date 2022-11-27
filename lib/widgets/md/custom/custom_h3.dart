import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class CustomH3 extends StatelessWidget {
  final String text;

  const CustomH3({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SelectableText.rich(
      TextSpan(
        text: text,
        style: Theme.of(context).textTheme.headlineSmall,
      ),
    );
  }
}

class CustomH3Builder extends MarkdownElementBuilder {
  @override
  Widget visitText(text, TextStyle? preferredStyle) {
    return CustomH3(text: text.text);
  }
}
