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
- Thundercard 7(1.0.2) 2022/11/12
- Thundercard 6(1.0.1) 2022/11/09
- Thundercard 5(1.0.0) 2022/11/08
- Thundercard 4(1.0.0) 2022/11/07
'''),
      ),
    );
  }
}
