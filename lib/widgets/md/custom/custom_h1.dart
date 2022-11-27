import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class CustomH1 extends StatelessWidget {
  final String text;

  const CustomH1({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SelectableText.rich(
      TextSpan(
        text: text,
        style: Theme.of(context).textTheme.headlineLarge,
      ),
    );
  }
}

class CustomH1Builder extends MarkdownElementBuilder {
  @override
  Widget visitText(text, TextStyle? preferredStyle) {
    return CustomH1(text: text.text);
  }
}
