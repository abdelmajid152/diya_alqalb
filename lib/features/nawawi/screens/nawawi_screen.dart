import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/theme/theme_controller.dart';
import '../controllers/nawawi_controller.dart';
import '../widgets/nawawi_item.dart';

/// Nawawi (40 Hadiths) screen
class NawawiScreen extends GetView<NawawiController> {
  const NawawiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure controller is initialized
    Get.put(NawawiController());

    final themeController = ThemeController.to;

    return Scaffold(
      backgroundColor: themeController.isDarkMode
          ? AppColors.backgroundDark
          : AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('الأربعون النووية'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        // Show loading state
        if (controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(
              color: themeController.isDarkMode
                  ? AppColors.primaryDark
                  : AppColors.primaryLight,
            ),
          );
        }

        // Show error state
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor: themeController.isDarkMode
                        ? AppColors.primaryDark
                        : AppColors.primaryLight,
                  ),
                  child: const Text('إعادة المحاولة'),
                ),
              ],
            ),
          );
        }

        // Show hadith content
        return SafeArea(
          child: Column(
            children: [
              // Navigation bar
              _buildNavigationBar(themeController.isDarkMode),

              // Page indicator
              _buildPageIndicator(themeController.isDarkMode),

              // PageView with hadiths
              Expanded(
                child: PageView.builder(
                  controller: controller.pageController,
                  itemCount: controller.nawawiList.length,
                  onPageChanged: controller.onPageChanged,
                  itemBuilder: (context, index) {
                    return NawawiItem(nawawi: controller.nawawiList[index]);
                  },
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  /// Build navigation arrows
  Widget _buildNavigationBar(bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Previous (Right arrow in RTL)
          Obx(
            () => IconButton(
              onPressed: controller.isFirstPage
                  ? null
                  : controller.previousPage,
              icon: Icon(
                Icons.arrow_back_ios_rounded,
                color: controller.isFirstPage
                    ? (isDarkMode
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondaryLight)
                          .withOpacity(0.3)
                    : (isDarkMode
                          ? AppColors.primaryDark
                          : AppColors.primaryLight),
              ),
            ),
          ),

          // Page number
          Obx(
            () => Text(
              '${controller.currentPage.value + 1} / ${controller.nawawiList.length}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDarkMode
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimaryLight,
              ),
            ),
          ),

          // Next (Left arrow in RTL)
          Obx(
            () => IconButton(
              onPressed: controller.isLastPage ? null : controller.nextPage,
              icon: Icon(
                Icons.arrow_forward_ios_rounded,
                color: controller.isLastPage
                    ? (isDarkMode
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondaryLight)
                          .withOpacity(0.3)
                    : (isDarkMode
                          ? AppColors.primaryDark
                          : AppColors.primaryLight),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build page indicator dots
  Widget _buildPageIndicator(bool isDarkMode) {
    return Obx(
      () => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            controller.nawawiList.length,
            (index) => GestureDetector(
              onTap: () => controller.goToPage(index),
              child: Container(
                width: controller.currentPage.value == index ? 24 : 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  color: controller.currentPage.value == index
                      ? (isDarkMode
                            ? AppColors.primaryDark
                            : AppColors.primaryLight)
                      : (isDarkMode
                                ? AppColors.textSecondaryDark
                                : AppColors.textSecondaryLight)
                            .withOpacity(0.3),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
