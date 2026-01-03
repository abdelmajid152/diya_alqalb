import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/onboarding_controller.dart';
import '../widgets/onboarding_page.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/theme/theme_controller.dart';

/// Main onboarding screen with page slider
class OnboardingScreen extends GetView<OnboardingController> {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = ThemeController.to;
    final pageController = PageController();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Top bar with skip button and theme toggle
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Theme toggle
                  Obx(
                    () => IconButton(
                      onPressed: themeController.toggleTheme,
                      icon: Icon(
                        themeController.isDarkMode
                            ? Icons.light_mode_rounded
                            : Icons.dark_mode_rounded,
                        color: themeController.isDarkMode
                            ? AppColors.primaryDark
                            : AppColors.primaryLight,
                      ),
                    ),
                  ),
                  // Skip button
                  Obx(
                    () => controller.isLastPage
                        ? const SizedBox.shrink()
                        : TextButton(
                            onPressed: controller.skipOnboarding,
                            child: Text(
                              'Skip',
                              style: TextStyle(
                                color: themeController.isDarkMode
                                    ? AppColors.textSecondaryDark
                                    : AppColors.textSecondaryLight,
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            ),

            // Page content
            Expanded(
              child: PageView.builder(
                controller: pageController,
                onPageChanged: controller.updatePage,
                itemCount: controller.pages.length,
                itemBuilder: (context, index) {
                  return Obx(
                    () => OnboardingPageWidget(
                      data: controller.pages[index],
                      isDarkMode: themeController.isDarkMode,
                    ),
                  );
                },
              ),
            ),

            // Bottom section with indicators and buttons
            Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                children: [
                  // Page indicators
                  Obx(
                    () => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        controller.pages.length,
                        (index) => _buildIndicator(
                          index,
                          controller.currentPage,
                          themeController.isDarkMode,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Navigation buttons
                  Obx(
                    () => Row(
                      children: [
                        // Back button
                        if (controller.currentPage > 0)
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                controller.previousPage();
                                pageController.previousPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              },
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                side: BorderSide(
                                  color: themeController.isDarkMode
                                      ? AppColors.primaryDark
                                      : AppColors.primaryLight,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                'Back',
                                style: TextStyle(
                                  color: themeController.isDarkMode
                                      ? AppColors.primaryDark
                                      : AppColors.primaryLight,
                                ),
                              ),
                            ),
                          ),
                        if (controller.currentPage > 0)
                          const SizedBox(width: 16),

                        // Next/Get Started button
                        Expanded(
                          flex: controller.currentPage > 0 ? 1 : 1,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: themeController.isDarkMode
                                    ? AppColors.gradientDark
                                    : AppColors.gradientLight,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      (themeController.isDarkMode
                                              ? AppColors.primaryDark
                                              : AppColors.primaryLight)
                                          .withAlpha(77),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              onPressed: () {
                                if (controller.isLastPage) {
                                  controller.completeOnboarding();
                                } else {
                                  controller.nextPage();
                                  pageController.nextPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                              ),
                              child: Text(
                                controller.isLastPage ? 'Get Started' : 'Next',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build page indicator dot
  Widget _buildIndicator(int index, int currentPage, bool isDarkMode) {
    final isActive = index == currentPage;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 8,
      width: isActive ? 32 : 8,
      decoration: BoxDecoration(
        color: isActive
            ? (isDarkMode ? AppColors.primaryDark : AppColors.primaryLight)
            : (isDarkMode
                  ? AppColors.textSecondaryDark.withAlpha(77)
                  : AppColors.textSecondaryLight.withAlpha(77)),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
