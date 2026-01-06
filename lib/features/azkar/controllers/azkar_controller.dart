import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

import '../../../data/services/azkar_service.dart';
import '../models/azkar_category_model.dart';
import '../models/thikr_model.dart';

/// GetX controller for Azkar feature
class AzkarController extends GetxController {
  // Observable state
  final categories = <AzkarCategory>[].obs;
  final isLoading = true.obs;
  final error = Rxn<String>();
  final selectedCategory = Rxn<AzkarCategory>();

  // Counter state: Map<thikrId, currentCount>
  final counters = <String, int>{}.obs;

  @override
  void onInit() {
    super.onInit();
    loadCategories();
  }

  /// Load all azkar categories from JSON
  Future<void> loadCategories() async {
    try {
      isLoading.value = true;
      error.value = null;

      final loadedCategories = await AzkarService.loadAzkar();
      categories.assignAll(loadedCategories);

      // Initialize counters for all athkar
      for (var category in loadedCategories) {
        for (int i = 0; i < category.athkar.length; i++) {
          final thikrId = _getThikrId(category.name, i);
          counters[thikrId] = 0;
        }
      }
    } catch (e) {
      error.value = 'حدث خطأ في تحميل البيانات';
    } finally {
      isLoading.value = false;
    }
  }

  /// Select a category for detailed view
  void selectCategory(AzkarCategory category) {
    selectedCategory.value = category;
  }

  /// Get unique ID for a thikr
  String _getThikrId(String categoryName, int index) {
    return '${categoryName}_$index';
  }

  /// Get current count for a thikr
  int getCurrentCount(String categoryName, int index) {
    final thikrId = _getThikrId(categoryName, index);
    return counters[thikrId] ?? 0;
  }

  /// Increment counter for a thikr
  void incrementCount(String categoryName, int index, int maxCount) {
    final thikrId = _getThikrId(categoryName, index);
    final current = counters[thikrId] ?? 0;

    if (current < maxCount) {
      counters[thikrId] = current + 1;
      HapticFeedback.lightImpact();

      // Show completion feedback
      if (counters[thikrId] == maxCount) {
        HapticFeedback.mediumImpact();
      }
    }
  }

  /// Reset counter for a thikr
  void resetCount(String categoryName, int index) {
    final thikrId = _getThikrId(categoryName, index);
    counters[thikrId] = 0;
    HapticFeedback.lightImpact();
  }

  /// Check if thikr is completed
  bool isCompleted(String categoryName, int index, int maxCount) {
    return getCurrentCount(categoryName, index) >= maxCount;
  }

  /// Get progress value (0.0 to 1.0)
  double getProgress(String categoryName, int index, int maxCount) {
    if (maxCount <= 0) return 0.0;
    return getCurrentCount(categoryName, index) / maxCount;
  }

  /// Copy thikr content to clipboard
  void copyToClipboard(Thikr thikr) {
    Clipboard.setData(ClipboardData(text: thikr.content));
    Get.snackbar(
      'تم النسخ',
      'تم نسخ الذكر إلى الحافظة',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
      backgroundColor: Get.theme.colorScheme.primary,
      colorText: Get.theme.colorScheme.onPrimary,
    );
  }

  /// Share thikr content
  void shareThikr(Thikr thikr) {
    final text =
        '''${thikr.content}

${thikr.description.isNotEmpty ? thikr.description : ''}
${thikr.reference.isNotEmpty ? '(${thikr.reference})' : ''}

- من تطبيق ضياء القلب''';

    Share.share(text.trim());
  }
}
