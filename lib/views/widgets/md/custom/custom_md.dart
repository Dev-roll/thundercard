import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../image_with_url.dart';
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
        'pre': CustomPreBuilder(),
      },
      imageBuilder: (uri, title, alt) {
        return Center(
          child: ImageWithUrl(url: uri.toString()),
        );
      },
      onTapLink: (text, href, title) {
        if (href != null) {
          launchUrl(
            Uri.parse(href),
            mode: LaunchMode.externalApplication,
          );
        }
      },
      data: data,
      styleSheet: MarkdownStyleSheet(
        h1: Theme.of(context).textTheme.headlineLarge,
        h2: Theme.of(context)
            .textTheme
            .headlineMedium
            ?.copyWith(fontWeight: FontWeight.w700),
        h3: Theme.of(context).textTheme.headlineSmall,
        h4: Theme.of(context).textTheme.titleLarge,
        h5: Theme.of(context).textTheme.titleMedium,
        h6: Theme.of(context).textTheme.titleSmall,
        a: TextStyle(color: Theme.of(context).colorScheme.primary),
      ),
    );
  }
}
