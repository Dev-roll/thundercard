import 'package:flutter/material.dart';
import 'package:thundercard/api/return_display_id.dart';
import 'package:thundercard/api/return_icon_type.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants.dart';
import 'card_element.dart';

class OpenApp extends StatefulWidget {
  OpenApp({Key? key, required this.url, this.secondUrl}) : super(key: key);
  final String url;
  String? secondUrl = '';

  @override
  State<OpenApp> createState() => _OpenAppState();
}

class _OpenAppState extends State<OpenApp> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: CardElement(
        txt: returnDisplayId(widget.url),
        type: returnIconType(widget.url),
      ),
      onTap: () {
        _launchURL(
          widget.url,
          secondUrl: widget.secondUrl,
        );
      },
    );
  }

  Future _launchURL(String url, {String? secondUrl}) async {
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
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
        behavior: SnackBarBehavior.floating,
        clipBehavior: Clip.antiAlias,
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 16, 0),
              child: Icon(
                Icons.error_outline_rounded,
                color: Theme.of(context).colorScheme.error,
              ),
            ),
            Expanded(
              child: Text(
                'アプリを開けません',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onError,
                ),
              ),
            ),
          ],
        ),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'OK',
          onPressed: () {},
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
      ));
    }
  }
}
