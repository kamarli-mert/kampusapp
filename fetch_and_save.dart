import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

void main() async {
  final baseUrl = 'https://muratyl2k4.pythonanywhere.com';
  final loginUrl = Uri.parse('$baseUrl/api/token/');
  final outputFile = File('api_response.txt');
  
  final sb = StringBuffer();
  sb.writeln('Debug Log:');

  try {
    // Login
    sb.writeln('Logging in...');
    final loginResponse = await http.post(
      loginUrl,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'Username': 'salata',
        'password': 'domates321',
      }),
    );

    if (loginResponse.statusCode != 200) {
      sb.writeln('Login Failed: ${loginResponse.statusCode}');
      sb.writeln('Body: ${loginResponse.body}');
      await outputFile.writeAsString(sb.toString());
      return;
    }

    final token = jsonDecode(loginResponse.body)['access'];
    sb.writeln('Login successful.');

    // Try endpoints
    final endpoints = [
      '/api/intern-announcements/',
      '/api/jobs/',
      '/api/intern/',
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
      if (response.statusCode == 200) {
        sb.writeln('!!! SUCCESS !!!');
        sb.writeln('Body:');
        try {
          final json = jsonDecode(response.body);
          final pretty = const JsonEncoder.withIndent('  ').convert(json);
          sb.writeln(pretty);
        } catch (e) {
          sb.writeln(response.body);
        }
        break; // Stop after first success
      } else {
        sb.writeln('Body: ${response.body}');
      }
      sb.writeln('---');
    }

  } catch (e) {
    sb.writeln('Error: $e');
  }

  await outputFile.writeAsString(sb.toString());
  print('Done. Check api_response.txt');
}
