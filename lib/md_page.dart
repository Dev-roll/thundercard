import 'package:flutter/material.dart';

import 'widgets/md/custom/custom_md.dart';

class MdPage extends StatelessWidget {
  const MdPage({
    super.key,
    required this.title,
    required this.data,
  });
  final Widget title;
  final String data;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: title,
        backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
      ),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: SingleChildScrollView(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 800,
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 16, 12, 24),
                  child: CustomMd(data: data),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
