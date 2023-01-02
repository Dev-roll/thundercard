import 'constants.dart';

String returnDisplayId(String url) {
  var ret = url;
  var linkUrlMap = {...linkTypeToBaseUrl};
  linkUrlMap.remove('url');
  linkUrlMap.forEach(
    (key, value) {
      if (url.startsWith(value)) {
        ret = url.substring(value.length);
      }
    },
  );
  return ret;
}
