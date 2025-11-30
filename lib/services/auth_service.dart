import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _baseUrl = 'https://muratyl2k4.pythonanywhere.com';
  static const String _tokenEndpoint = '/api/token/';

  Future<bool> login(String username, String password) async {
    try {
      final url = Uri.parse("$_baseUrl$_tokenEndpoint");
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'Username': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        print(1111111);
        final data = jsonDecode(response.body);
        print(data);
        final accessToken = data['access'];
        
        if (accessToken != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('access_token', accessToken);
          return true;
        }
      }
      return false;
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('access_token');
  }
}

