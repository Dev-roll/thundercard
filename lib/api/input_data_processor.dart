import '../constants.dart';

String? inputToId(String inputData) {
  if (inputData.startsWith(initStr)) {
    return Uri.parse(inputData).queryParameters['card_id']?.trim();
  }
  return null;
}
