import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/theme/theme_controller.dart';
import '../controllers/reciters_controller.dart';
import '../widgets/audio_list_items.dart';

/// Screen displaying list of Quran reciters
class RecitersScreen extends StatelessWidget {
  const RecitersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RecitersController());
    final themeController = Get.find<ThemeController>();
    final isDark = themeController.isDarkMode;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.backgroundDark
          : AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text(
          'القرآن الكريم صوتي',
          style: TextStyle(fontFamily: 'UthmanicHafs', fontSize: 22),
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
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: controller.search,
              textDirection: TextDirection.rtl,
              decoration: InputDecoration(
                hintText: 'ابحث عن قارئ...',
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
          // Reciters list
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
                        onPressed: controller.loadData,
                        child: const Text('إعادة المحاولة'),
                      ),
                    ],
                  ),
                );
              }

              // Content
              final list = controller.isSearching.value
                  ? controller.searchResults
                  : controller.recitersList;

              if (list.isEmpty) {
                return Center(
                  child: Text(
                    'لا توجد نتائج',
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
                  return ReciterItem(
                    reciter: list[index],
                    onTap: () => controller.goToSuwar(index),
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
