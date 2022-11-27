import 'package:flutter/material.dart';

class MdPage extends StatelessWidget {
  const MdPage({
    super.key,
    required this.title,
    required this.content,
  });
  final Widget title;
  final Widget content;

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
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                  child: content,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
