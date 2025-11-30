import 'package:http/http.dart' as http;

void main() async {
  final baseUrl = 'https://muratyl2k4.pythonanywhere.com';
  final endpoints = [
    '/api/intern/announcements/',
    '/intern/announcements/',
  ];

  for (final endpoint in endpoints) {
    final url = Uri.parse('$baseUrl$endpoint');
    print('Checking $url...');
    try {
      final response = await http.get(url);
      print('Status: ${response.statusCode}');
      if (response.statusCode != 404) {
        print('Body preview: ${response.body.substring(0, 100)}...');
      }
    } catch (e) {
      print('Error: $e');
    }
    print('---');
  }
}
