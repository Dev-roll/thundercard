import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class Authors extends StatelessWidget {
  const Authors({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('開発者'),
        backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
      ),
      body: const Padding(
        padding: EdgeInsets.fromLTRB(14.0, 0, 14.0, 0),
        child: Markdown(data: '''
このアプリケーションは以下のメンバーによって開発されました。

- [@notchcoder](https://github.com/notchcoder)
- [@cardseditor](https://github.com/cardseditor)
- [@keigomichi](https://github.com/keigomichi)
'''),
      ),
    );
  }
}
