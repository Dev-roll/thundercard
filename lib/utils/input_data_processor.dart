import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:logger/logger.dart';
import 'package:thundercard/utils/constants.dart';

Future<String?> inputToId(String inputData) async {
  final Uri shortUri = Uri.parse(inputData);
  final PendingDynamicLinkData? data =
      await FirebaseDynamicLinks.instance.getDynamicLink(shortUri);
  final Uri? longUri = data?.link;
  Logger().d(data?.link.toString());
  if (shortUri.host == shortBaseUri.host &&
      longUri?.host == originalBaseUri.host) {
    return data?.link.queryParameters['card_id']?.trim();
  }
  return null;
}
