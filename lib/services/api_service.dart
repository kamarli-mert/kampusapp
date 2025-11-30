import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/job.dart';
import '../models/company.dart';

class ApiService {
  static const String _baseUrl = 'https://muratyl2k4.pythonanywhere.com';

  Future<List<Job>> fetchInternships() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    if (token == null) {
      throw Exception('No access token found');
    }

    final url = Uri.parse('$_baseUrl/api/intern-announcements/');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      print('Internships API Response: ${response.body}');
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List<dynamic> results = data['results'] ?? [];
      return results.map((json) => Job.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load internships: ${response.statusCode}');
    }
  }

  Future<List<Map<String, dynamic>>> fetchInternshipCategories() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    if (token == null) {
      throw Exception('No access token found');
    }

    final url = Uri.parse('$_baseUrl/api/intern-categories/');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final dynamic decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));
      List<dynamic> data;
      
      if (decodedResponse is Map<String, dynamic> && decodedResponse.containsKey('results')) {
        data = decodedResponse['results'];
      } else if (decodedResponse is List) {
        data = decodedResponse;
      } else {
        data = [];
      }

      return data.map<Map<String, dynamic>>((json) {
        return {
          'id': json['id'].toString(),
          'name': (json['category_name'] ?? json['name'] ?? 'Unknown').toString(),
        };
      }).toList();
    } else {
      throw Exception('Failed to load categories: ${response.statusCode}');
    }
  }

  Future<List<Job>> fetchInternshipsByCategory(String categoryId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    if (token == null) {
      throw Exception('No access token found');
    }

    final url = Uri.parse('$_baseUrl/api/intern-categories/$categoryId/get_internships/');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      print('Internships by Category Response: ${response.body}');
      final dynamic decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));
      List<dynamic> results;

      if (decodedResponse is Map<String, dynamic> && decodedResponse.containsKey('results')) {
        results = decodedResponse['results'];
      } else if (decodedResponse is List) {
        results = decodedResponse;
      } else {
        results = [];
      }
      
      return results.map((json) => Job.fromJson(json)).toList();
    } else {
      print('Failed to load internships by category: ${response.statusCode} ${response.body}');
      throw Exception('Failed to load internships for category $categoryId: ${response.statusCode}');
    }
  }

  // Cache to store fetched company details
  static final Map<String, Company> _companyCache = {};

  Future<Company> fetchCompanyDetails(String id) async {
    // Check cache first
    if (_companyCache.containsKey(id)) {
      return _companyCache[id]!;
    }

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    if (token == null) {
      throw Exception('No access token found');
    }

    final url = Uri.parse('$_baseUrl/api/intern/$id/');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final company = Company.fromJson(data);
      // Store in cache
      _companyCache[id] = company;
      return company;
    } else {
      throw Exception('Failed to load company details: ${response.statusCode}');
    }
  }

  Future<List<Job>> fetchCompanyInternships(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    if (token == null) {
      throw Exception('No access token found');
    }

    final url = Uri.parse('$_baseUrl/api/intern/$id/get_internships/');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> results = jsonDecode(response.body);
      return results.map((json) => Job.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load company internships: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> fetchUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    if (token == null) {
      throw Exception('No access token found');
    }

    final url = Uri.parse('$_baseUrl/api/accounts/me/');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      throw Exception('Failed to load user profile: ${response.statusCode}');
    }
  }
}

