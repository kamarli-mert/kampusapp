import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  final baseUrl = 'https://muratyl2k4.pythonanywhere.com';
  final loginUrl = Uri.parse('$baseUrl/api/token/');
  
  print('Logging in...');
  String token = '';
  try {
    final loginResponse = await http.post(
      loginUrl,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'Username': 'salata',
        'password': 'domates321',
      }),
    );

    if (loginResponse.statusCode != 200) {
      print('Login failed: ${loginResponse.statusCode}');
      return;
    }
    token = jsonDecode(loginResponse.body)['access'];
    print('Login successful.');
  } catch (e) {
    print('Login error: $e');
    return;
  }

  final endpoints = [
    '/api/intern_announcements/',
    '/api/internannouncements/',
    '/intern_announcements/',
    '/internannouncements/',
  ];

  for (final endpoint in endpoints) {
    final url = Uri.parse('$baseUrl$endpoint');
    print('Checking $url...');
    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      
      if (response.statusCode == 200) {
        print('!!! FOUND IT !!!');
        print('CORRECT URL: $url');
        print('JSON_START');
        print(const JsonEncoder.withIndent('  ').convert(jsonDecode(response.body)));
        print('JSON_END');
        break; 
      } else {
        print('Failed ($endpoint): ${response.statusCode}');
      }
    } catch (e) {
      print('Error ($endpoint): $e');
    }
    print('---');
  }
}
