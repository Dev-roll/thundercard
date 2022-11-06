import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../api/colors.dart';
import '../home_page.dart';

class Authors extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('開発者'),
        backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(14.0, 0, 14.0, 0),
        child: const Markdown(data: '''
このアプリケーションは以下のメンバーによって開発されました。

- [@notchcoder](https://github.com/notchcoder)
- [@cardseditor](https://github.com/cardseditor)
- [@keigomichi](https://github.com/keigomichi)
'''),
      ),
    );
  }
}
