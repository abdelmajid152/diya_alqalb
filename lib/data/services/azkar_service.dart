import 'dart:convert';
import 'package:flutter/services.dart';
import '../../features/azkar/models/azkar_category_model.dart';
import '../../features/azkar/models/thikr_model.dart';

class AzkarService {
  static Future<List<AzkarCategory>> loadAzkar() async {
    try {
      // Load JSON file from assets
      final String jsonString = await rootBundle.loadString('assets/json/azkar.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      
      // Convert to AzkarCategory list
      List<AzkarCategory> categories = [];
      
      jsonData.forEach((categoryName, athkarList) {
        if (athkarList is List) {
          categories.add(AzkarCategory.fromJson(categoryName, athkarList));
        }
      });
      
      return categories;
    } catch (e) {
      print('Error loading azkar: $e');
      return [];
    }
  }

  // Get specific category by name
  static Future<AzkarCategory?> getCategoryByName(String categoryName) async {
    final categories = await loadAzkar();
    try {
      return categories.firstWhere((cat) => cat.name == categoryName);
    } catch (e) {
      return null;
    }
  }

  // Search athkar by content
  static Future<List<Thikr>> searchAthkar(String query) async {
    final categories = await loadAzkar();
    List<Thikr> results = [];
    
    for (var category in categories) {
      for (var thikr in category.athkar) {
        if (thikr.content.contains(query) || 
            thikr.description.contains(query)) {
          results.add(thikr);
        }
      }
    }
    
    return results;
  }
}
