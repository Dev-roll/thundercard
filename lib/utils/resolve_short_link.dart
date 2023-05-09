import 'package:http/http.dart' as http;

Future<String> resolveShortLink(String shortLink) async {
  final response = await http.head(Uri.parse(shortLink));
  final redirectLink = response.headers['location'] ?? '';
  return redirectLink;
}
