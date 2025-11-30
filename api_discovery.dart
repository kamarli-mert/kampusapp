import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

void main() async {
  final baseUrl = 'https://muratyl2k4.pythonanywhere.com';
  final loginUrl = Uri.parse('$baseUrl/api/token/');
  final outputFile = File('api_discovery.txt');
  
  final sb = StringBuffer();
  sb.writeln('Discovery Log:');

  try {
    // Login
    final loginResponse = await http.post(
      loginUrl,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'Username': 'salata',
        'password': 'domates321',
      }),
    );
    final token = jsonDecode(loginResponse.body)['access'];
    sb.writeln('Login successful.');

    // Try discovery endpoints
    final endpoints = [
      '/api/',
      '/api/intern/',
      '/api/announcements/',
    ];

    for (final endpoint in endpoints) {
      final url = Uri.parse('$baseUrl$endpoint');
      sb.writeln('Checking $url...');
      
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      sb.writeln('Status: ${response.statusCode}');
      sb.writeln('Body:');
      try {
        final json = jsonDecode(response.body);
        final pretty = const JsonEncoder.withIndent('  ').convert(json);
        sb.writeln(pretty);
      } catch (e) {
        sb.writeln(response.body);
      }
      sb.writeln('---');
    }

  } catch (e) {
    sb.writeln('Error: $e');
  }

  await outputFile.writeAsString(sb.toString());
  print('Done. Check api_discovery.txt');
}
