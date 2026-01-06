import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/theme/theme_controller.dart';
import '../controllers/tafsir_controller.dart';
import '../widgets/tafsir_item.dart';

/// Screen displaying list of tafsir surahs
class TafsirScreen extends StatelessWidget {
  const TafsirScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TafsirController());
    final themeController = Get.find<ThemeController>();

    return Scaffold(
      backgroundColor: themeController.isDarkMode
          ? AppColors.backgroundDark
          : AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text(
          'تفسير الطبري',
          style: TextStyle(fontFamily: 'UthmanicHafs', fontSize: 22),
        ),
        centerTitle: true,
        backgroundColor: themeController.isDarkMode
            ? AppColors.surfaceDark
            : AppColors.surfaceLight,
        foregroundColor: themeController.isDarkMode
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
                hintText: 'ابحث عن سورة...',
                hintTextDirection: TextDirection.rtl,
                hintStyle: TextStyle(
                  color: themeController.isDarkMode
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: themeController.isDarkMode
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight,
                ),
                filled: true,
                fillColor: themeController.isDarkMode
                    ? AppColors.surfaceDark
                    : AppColors.surfaceLight,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              style: TextStyle(
                color: themeController.isDarkMode
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimaryLight,
              ),
            ),
          ),
          // Tafsir list
          Expanded(
            child: Obx(() {
              // Loading state
              if (controller.isLoading.value) {
                return Center(
                  child: CircularProgressIndicator(
                    color: themeController.isDarkMode
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
                        color: themeController.isDarkMode
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        controller.error.value!,
                        style: TextStyle(
                          fontSize: 16,
                          color: themeController.isDarkMode
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
                  : controller.tafsirList;

              if (list.isEmpty) {
                return Center(
                  child: Text(
                    'لا توجد نتائج',
                    style: TextStyle(
                      fontSize: 16,
                      color: themeController.isDarkMode
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
                  return TafsirItem(
                    tafsir: list[index],
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
