import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../../core/constants/api_endpoints.dart';
import '../../../core/services/api_service.dart';
import '../../../core/routes/app_routes.dart';
import '../models/reciter_model.dart';

/// Controller for Quran reciters list screen
class RecitersController extends GetxController {
  // State variables
  final isLoading = true.obs;
  final error = Rxn<String>();
  final recitersList = <ReciterModel>[].obs;
  final searchResults = <ReciterModel>[].obs;
  final isSearching = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  /// Load reciters data from API
  Future<void> loadData() async {
    try {
      isLoading.value = true;
      error.value = null;

      final response = await ApiService.get(ApiEndpoints.reciters);

      if (response != null && response['reciters'] != null) {
        final reciters = response['reciters'] as List;
        recitersList.value = reciters
            .map((e) => ReciterModel.fromJson(e))
            .toList();
      } else {
        error.value = 'فشل في تحميل البيانات';
      }
    } catch (e) {
      error.value = 'حدث خطأ في الاتصال';
      debugPrint('Error loading reciters: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Search reciters by name
  void search(String query) {
    if (query.isEmpty) {
      isSearching.value = false;
      searchResults.clear();
      return;
    }

    isSearching.value = true;
    searchResults.value = recitersList
        .where((r) => r.name.contains(query))
        .toList();
  }

  /// Navigate to suwar screen for selected reciter
  void goToSuwar(int index) {
    final list = isSearching.value ? searchResults : recitersList;
    final reciter = list[index];

    if (reciter.firstMoshaf == null) return;

    Get.toNamed(
      AppRoutes.quranAudioSuwar,
      arguments: {
        'reciterName': reciter.name,
        'surahList': reciter.firstMoshaf!.surahList,
        'serverLink': reciter.firstMoshaf!.server,
        'moshafName': reciter.firstMoshaf!.name,
      },
    );
  }

  /// Navigate back
  void goBack() {
    Get.back();
  }
}
