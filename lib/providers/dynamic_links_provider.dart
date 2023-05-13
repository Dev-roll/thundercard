import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thundercard/utils/dynamic_links.dart';

final dynamicLinkProvider =
    FutureProvider.family<dynamic, String>((ref, myCardId) {
  return dynamicLinks(myCardId);
});
