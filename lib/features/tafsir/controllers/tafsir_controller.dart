import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../../core/constants/api_endpoints.dart';
import '../../../core/services/api_service.dart';
import '../models/tafsir_model.dart';
import '../../../core/routes/app_routes.dart';

/// Controller for Tafsir (Al-Tabari explanation) list screen
class TafsirController extends GetxController {
  // State variables
  final isLoading = true.obs;
  final error = Rxn<String>();
  final tafsirList = <TafsirModel>[].obs;
  final searchResults = <TafsirModel>[].obs;
  final isSearching = false.obs;
  final allUrls = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  /// Load tafsir data from API
  Future<void> loadData() async {
    try {
      isLoading.value = true;
      error.value = null;

      final response = await ApiService.get(ApiEndpoints.tafsir);

      if (response != null && response['tafasir'] != null) {
        final soar = response['tafasir']['soar'] as List;
        tafsirList.value = soar.map((e) => TafsirModel.fromJson(e)).toList();

        // Collect all URLs for playlist
        allUrls.value = tafsirList.map((e) => e.url).toList();
      } else {
        error.value = 'فشل في تحميل البيانات';
      }
    } catch (e) {
      error.value = 'حدث خطأ في الاتصال';
      debugPrint('Error loading Tafsir: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Search tafsir by surah name
  void search(String query) {
    if (query.isEmpty) {
      isSearching.value = false;
      searchResults.clear();
      return;
    }

    isSearching.value = true;
    searchResults.value = tafsirList
        .where((t) => t.name.contains(query))
        .toList();
  }

  /// Navigate to player screen
  void goToPlayer(int index) {
    final list = isSearching.value ? searchResults : tafsirList;
    final tafsir = list[index];

    Get.toNamed(
      AppRoutes.tafsirPlayer,
      arguments: {
        'index': isSearching.value ? tafsirList.indexOf(tafsir) : index,
        'tafsirList': tafsirList
            .map(
              (e) => {
                'id': e.id,
                'sura_id': e.suraId,
                'name': e.name,
                'url': e.url,
              },
            )
            .toList(),
        'allUrls': allUrls,
      },
    );
  }

  /// Navigate back to home
  void goBack() {
    Get.back();
  }
}
