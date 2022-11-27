import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

import 'custom_h1.dart';
import 'custom_h2.dart';
import 'custom_h3.dart';
import 'custom_h4.dart';
import 'custom_h5.dart';
import 'custom_h6.dart';
import 'custom_pre.dart';

class CustomMd extends StatelessWidget {
  const CustomMd({super.key, required this.data});
  final String data;

  @override
  Widget build(BuildContext context) {
    return Markdown(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      builders: {
        'h1': CustomH1Builder(),
        'h2': CustomH2Builder(),
        'h3': CustomH3Builder(),
        'h4': CustomH4Builder(),
        'h5': CustomH5Builder(),
        'h6': CustomH6Builder(),
        'pre': CustomPreBuilder(),
      },
      imageBuilder: (uri, title, alt) {
        return Center(
          child: Image.network(
            uri.toString(),
          ),
        );
      },
      onTapLink: (text, href, title) {
        // 追加
        if (href != null) {
          launchUrl(
            Uri.parse(href),
            mode: LaunchMode.externalApplication,
          );
        }
      },
      data: data,
    );
  }
}
