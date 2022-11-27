import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class TermsOfUse extends StatelessWidget {
  const TermsOfUse({super.key});

  @override
  Widget build(BuildContext context) {
    return const Markdown(
        shrinkWrap: true, physics: NeverScrollableScrollPhysics(), data: '''
2022/11/11

Thundercardサービス（以下、本サービスという）は、現時点において「Enginner Driven Day エンジニアフレンドリーシティ福岡 開発コンテスト」（以下、当該コンテストという）における審査のみを目的として公開しております。したがって、当該コンテストにおいて本サービスを審査する目的を逸脱して本サービスを使用することは禁止いたします。
''');
  }
}
