import 'constants.dart';

IconType returnIconType(String url) {
  var ret = IconType.url;
  var linkUrlMap = {...linkTypeToBaseUrl};
  linkUrlMap.remove('url');
  linkUrlMap.forEach(
    (key, value) {
      if (url.startsWith(value)) {
        ret = linkTypeToIconType[key] ?? IconType.url;
      }
    },
  );
  return ret;
}
