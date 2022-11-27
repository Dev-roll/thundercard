import 'package:flutter/material.dart';
import 'package:thundercard/api/return_display_id.dart';
import 'package:thundercard/api/return_icon_type.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants.dart';
import 'card_element.dart';

class OpenApp extends StatefulWidget {
  const OpenApp({
    Key? key,
    required this.url,
    this.secondUrl = '',
    this.child,
    this.large = false,
  }) : super(key: key);
  final String url;
  final String secondUrl;
  final Widget? child;
  final bool large;

  @override
  State<OpenApp> createState() => _OpenAppState();
}

class _OpenAppState extends State<OpenApp> {
  @override
  Widget build(BuildContext context) {
    double size;
    if (widget.large == true) {
      size = 1.4;
    } else {
      size = returnIconType(widget.url) == IconType.address ? 1.3 : 1;
    }
    return widget.child ??
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          child: CardElement(
            txt: returnDisplayId(widget.url),
            type: returnIconType(widget.url),
            size: size,
            large: widget.large,
          ),
          onTap: () {
            _launchURL(
              widget.url.trim(),
              secondUrl: widget.secondUrl.trim(),
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
        elevation: 20,
        backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
        behavior: SnackBarBehavior.floating,
        clipBehavior: Clip.antiAlias,
        dismissDirection: DismissDirection.horizontal,
        margin: EdgeInsets.only(
          left: 8,
          right: 8,
          bottom: MediaQuery.of(context).size.height - 180,
        ),
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
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
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
        action: SnackBarAction(
          label: 'OK',
          onPressed: () {},
        ),
      ));
    }
  }
}
