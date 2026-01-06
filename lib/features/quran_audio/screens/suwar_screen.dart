import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/theme/theme_controller.dart';
import '../controllers/suwar_controller.dart';
import '../widgets/audio_list_items.dart';

/// Screen displaying list of surahs for selected reciter
class SuwarScreen extends StatelessWidget {
  const SuwarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SuwarController());
    final themeController = Get.find<ThemeController>();
    final isDark = themeController.isDarkMode;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.backgroundDark
          : AppColors.backgroundLight,
      appBar: AppBar(
        title: Obx(
          () => Text(
            controller.reciterName.value,
            style: const TextStyle(fontSize: 18),
          ),
        ),
        centerTitle: true,
        backgroundColor: isDark
            ? AppColors.surfaceDark
            : AppColors.surfaceLight,
        foregroundColor: isDark
            ? AppColors.textPrimaryDark
            : AppColors.textPrimaryLight,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: controller.goBack,
        ),
      ),
      body: Column(
        children: [
          // Moshaf name
          Obx(
            () => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                controller.moshafName.value,
                style: TextStyle(
                  fontSize: 14,
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight,
                ),
                textDirection: TextDirection.rtl,
              ),
            ),
          ),
          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              onChanged: controller.search,
              textDirection: TextDirection.rtl,
              decoration: InputDecoration(
                hintText: 'ابحث عن سورة...',
                hintTextDirection: TextDirection.rtl,
                hintStyle: TextStyle(
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight,
                ),
                filled: true,
                fillColor: isDark
                    ? AppColors.surfaceDark
                    : AppColors.surfaceLight,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              style: TextStyle(
                color: isDark
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimaryLight,
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Suwar list
          Expanded(
            child: Obx(() {
              // Loading state
              if (controller.isLoading.value) {
                return Center(
                  child: CircularProgressIndicator(
                    color: isDark
                        ? AppColors.primaryDark
                        : AppColors.primaryLight,
                  ),
                );
              }

              // Error state
              if (controller.error.value != null) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        controller.error.value!,
                        style: TextStyle(
                          fontSize: 16,
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondaryLight,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: controller.loadSuwarNames,
                        child: const Text('إعادة المحاولة'),
                      ),
                    ],
                  ),
                );
              }

              // Content
              final list = controller.isSearching.value
                  ? controller.searchResults
                  : controller.suwarList;

              if (list.isEmpty) {
                return Center(
                  child: Text(
                    'لا توجد سور',
                    style: TextStyle(
                      fontSize: 16,
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                    ),
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.only(bottom: 16),
                itemCount: list.length,
                itemBuilder: (context, index) {
                  final surah = list[index];
                  return SurahAudioItem(
                    surahId: surah.id,
                    surahName: surah.name,
                    onTap: () => controller.goToPlayer(index),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
