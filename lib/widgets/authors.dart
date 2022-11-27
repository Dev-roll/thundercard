import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class Authors extends StatelessWidget {
  const Authors({super.key});

  @override
  Widget build(BuildContext context) {
    return const Markdown(
        shrinkWrap: true, physics: NeverScrollableScrollPhysics(), data: '''
このアプリケーションは以下のメンバーによって開発されました。

- [@notchcoder](https://github.com/notchcoder)
- [@cardseditor](https://github.com/cardseditor)
- [@keigomichi](https://github.com/keigomichi)
''');
  }
}
