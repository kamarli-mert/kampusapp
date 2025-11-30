import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  print('Testing API connection...');
  final url = Uri.parse('https://muratyl2k4.pythonanywhere.com/api/token/');
  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'Username': 'test',
        'password': 'test',
      }),
    );
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
  } catch (e) {
    print('Error: $e');
  }
}
