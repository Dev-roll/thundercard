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
- 11(1.0.4) 2022/11/18 画面遷移，Singin with Googleの不具合を修正
- 10(1.0.3) 2022/11/17 App Store提出
- 9(1.0.3) 2022/11/17 App Storeリリース／アカウント機能を更新
- 8(1.0.2) 2022/11/15 App Store提出
- 7(1.0.2) 2022/11/12 利用規約を追加
- 6(1.0.1) 2022/11/09 交換に関する不具合を修正
- 5(1.0.0) 2022/11/08 Google Playリリース
- 4(1.0.0) 2022/11/07 Google Play提出
'''),
      ),
    );
  }
}