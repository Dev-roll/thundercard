import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class CustomH4 extends StatelessWidget {
  final String text;

  const CustomH4({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SelectableText.rich(
      TextSpan(
        text: text,
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }
}

class CustomH4Builder extends MarkdownElementBuilder {
  @override
  Widget visitText(text, TextStyle? preferredStyle) {
    return CustomH4(text: text.text);
  }
}
