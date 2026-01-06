import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/services/nawawi_service.dart';
import '../models/nawawi_model.dart';

/// GetX controller for Nawawi (40 Hadiths) feature
class NawawiController extends GetxController {
  // Observable state
  final nawawiList = <Nawawi>[].obs;
  final isLoading = true.obs;
  final error = Rxn<String>();
  final currentPage = 0.obs;

  // Page controller for PageView
  late PageController pageController;

  @override
  void onInit() {
    super.onInit();
    pageController = PageController();
    loadData();
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  /// Load all Nawawi hadiths from JSON
  Future<void> loadData() async {
    try {
      isLoading.value = true;
      error.value = null;

      final data = await NawawiService.loadNawawi();
      nawawiList.assignAll(data);
    } catch (e) {
      error.value = 'حدث خطأ في تحميل البيانات';
      debugPrint('Error loading Nawawi: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Navigate to next hadith
  void nextPage() {
    if (currentPage.value < nawawiList.length - 1) {
      pageController.animateToPage(
        currentPage.value + 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  /// Navigate to previous hadith
  void previousPage() {
    if (currentPage.value > 0) {
      pageController.animateToPage(
        currentPage.value - 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  /// Update current page index
  void onPageChanged(int index) {
    currentPage.value = index;
  }

  /// Go to specific page
  void goToPage(int index) {
    if (index >= 0 && index < nawawiList.length) {
      pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  /// Check if on first page
  bool get isFirstPage => currentPage.value == 0;

  /// Check if on last page
  bool get isLastPage => currentPage.value == nawawiList.length - 1;
}
