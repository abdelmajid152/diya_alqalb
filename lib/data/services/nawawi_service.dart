import 'dart:convert';
import 'package:flutter/services.dart';
import '../../features/nawawi/models/nawawi_model.dart';

/// Service for loading Nawawi hadith data from JSON
class NawawiService {
  static const String _assetPath = 'assets/json/nawawi.json';

  /// Load all Nawawi hadiths from JSON asset
  static Future<List<Nawawi>> loadNawawi() async {
    try {
      final String jsonString = await rootBundle.loadString(_assetPath);
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((json) => Nawawi.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load Nawawi data: $e');
    }
  }
}
