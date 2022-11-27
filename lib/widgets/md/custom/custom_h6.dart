import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class CustomH6 extends StatelessWidget {
  final String text;

  const CustomH6({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SelectableText.rich(
      TextSpan(
        text: text,
        style: Theme.of(context).textTheme.titleSmall,
      ),
    );
  }
}

class CustomH6Builder extends MarkdownElementBuilder {
  @override
  Widget visitText(text, TextStyle? preferredStyle) {
    return CustomH6(text: text.text);
  }
}
