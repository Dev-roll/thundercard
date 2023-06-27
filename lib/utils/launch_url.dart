// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:thundercard/ui/component/positioned_snack_bar.dart';
import 'package:url_launcher/url_launcher.dart';

Future launchURL(String url, BuildContext context, {String? secondUrl}) async {
  if (await canLaunchUrl(Uri.parse(url))) {
    await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    );
  } else if (secondUrl != null && await canLaunchUrl(Uri.parse(secondUrl))) {
    await launchUrl(
      Uri.parse(secondUrl),
      mode: LaunchMode.externalApplication,
    );
  } else {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      PositionedSnackBar(
        context,
        'アプリを開けません',
        icon: Icons.error_outline_rounded,
        foreground: Theme.of(context).colorScheme.onError,
        bottom: 48,
      ),
    );
  }
}
