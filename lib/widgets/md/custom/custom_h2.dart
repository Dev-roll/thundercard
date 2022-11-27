import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class CustomH2 extends StatelessWidget {
  final String text;

  const CustomH2({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SelectableText.rich(
      TextSpan(
        text: text,
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    );
  }
}

class CustomH2Builder extends MarkdownElementBuilder {
  @override
  Widget visitText(text, TextStyle? preferredStyle) {
    return CustomH2(text: text.text);
  }
}
