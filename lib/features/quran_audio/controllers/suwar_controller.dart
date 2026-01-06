import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../../core/constants/api_endpoints.dart';
import '../../../core/services/api_service.dart';
import '../../../core/routes/app_routes.dart';
import '../models/reciter_model.dart';

/// Controller for Quran suwar (chapters) list screen
class SuwarController extends GetxController {
  // Data from arguments
  final reciterName = ''.obs;
  final moshafName = ''.obs;
  final serverLink = ''.obs;

  // State variables
  final isLoading = true.obs;
  final error = Rxn<String>();
  final suwarList = <SurahAudioModel>[].obs;
  final searchResults = <SurahAudioModel>[].obs;
  final isSearching = false.obs;

  // Available surah IDs for this reciter
  List<int> availableSurahIds = [];

  @override
  void onInit() {
    super.onInit();
    _initFromArguments();
    loadSuwarNames();
  }

  void _initFromArguments() {
    final args = Get.arguments as Map<String, dynamic>;
    reciterName.value = args['reciterName'] ?? '';
    moshafName.value = args['moshafName'] ?? '';
    serverLink.value = args['serverLink'] ?? '';

    // Parse surah list string (e.g., "1,2,3,5,7")
    final surahListStr = args['surahList'] as String? ?? '';
    availableSurahIds = surahListStr
        .split(',')
        .where((s) => s.isNotEmpty)
        .map((s) => int.tryParse(s.trim()) ?? 0)
        .where((id) => id > 0)
        .toList();
  }

  /// Load suwar names from API
  Future<void> loadSuwarNames() async {
    try {
      isLoading.value = true;
      error.value = null;

      final response = await ApiService.get(ApiEndpoints.suwar);

      if (response != null && response['suwar'] != null) {
        final allSuwar = response['suwar'] as List;

        // Filter only available surahs and build audio URLs
        for (final surahJson in allSuwar) {
          final id = surahJson['id'] ?? 0;
          if (availableSurahIds.contains(id)) {
            // Build audio URL: serverLink + surahNumber.mp3
            final surahNum = id.toString().padLeft(3, '0');
            final url = '${serverLink.value}$surahNum.mp3';

            suwarList.add(
              SurahAudioModel(id: id, name: surahJson['name'] ?? '', url: url),
            );
          }
        }
      } else {
        error.value = 'فشل في تحميل السور';
      }
    } catch (e) {
      error.value = 'حدث خطأ في الاتصال';
      debugPrint('Error loading suwar: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Search suwar by name
  void search(String query) {
    if (query.isEmpty) {
      isSearching.value = false;
      searchResults.clear();
      return;
    }

    isSearching.value = true;
    searchResults.value = suwarList
        .where((s) => s.name.contains(query))
        .toList();
  }

  /// Navigate to player screen
  void goToPlayer(int index) {
    final list = isSearching.value ? searchResults : suwarList;
    final surah = list[index];

    Get.toNamed(
      AppRoutes.quranAudioPlayer,
      arguments: {
        'index': isSearching.value ? suwarList.indexOf(surah) : index,
        'reciterName': reciterName.value,
        'suwarList': suwarList
            .map((s) => {'id': s.id, 'name': s.name, 'url': s.url})
            .toList(),
      },
    );
  }

  /// Navigate back
  void goBack() {
    Get.back();
  }
}
