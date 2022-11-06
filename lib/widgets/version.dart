import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class Version extends StatelessWidget {
  const Version({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('バージョン情報'),
        backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
      ),
      body: const Padding(
        padding: EdgeInsets.fromLTRB(14.0, 0, 14.0, 0),
        child: Markdown(data: '''
- Thundercard 4(1.0.0) 2022/11/07
'''),
      ),
    );
  }
}
