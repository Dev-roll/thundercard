import 'constants.dart';

String returnUrl(String platform, String id) {
  final url = '${linkTypeToBaseUrl[platform]}$id';
  return url;
}
