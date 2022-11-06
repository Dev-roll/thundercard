import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../api/colors.dart';
import '../home_page.dart';

class Version extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('バージョン情報'),
        backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(14.0, 0, 14.0, 0),
        child: const Markdown(data: '''
- Thundercard 4(1.0.0) 2022/11/07
'''),
      ),
    );
  }
}
