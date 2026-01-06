import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

/// Service for making HTTP requests to APIs
class ApiService {
  /// Makes a GET request and returns decoded JSON
  static Future<Map<String, dynamic>?> get(String url) async {
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        debugPrint('API Error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      debugPrint('Network Error: $e');
      return null;
    }
  }
}
