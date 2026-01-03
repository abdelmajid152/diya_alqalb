import 'package:diya_alqalb/features/home/screens/widgets/feature_cards.dart';
import 'package:diya_alqalb/features/home/screens/widgets/prayer_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/theme/theme_controller.dart';

/// Home screen
class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = ThemeController.to;

    return Scaffold(
      appBar: AppBar(
        title: const Text('ضياء القلب'),
        actions: [
          Obx(
            () => IconButton(
              onPressed: controller.toggleTheme,
              icon: Icon(
                themeController.isDarkMode
                    ? Icons.light_mode_rounded
                    : Icons.dark_mode_rounded,
              ),
              tooltip: themeController.isDarkMode
                  ? 'Switch to Light Mode'
                  : 'Switch to Dark Mode',
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWelcomeCard(context, themeController.isDarkMode),
              PrayerCard(),

              // Welcome card
              const SizedBox(height: 24),

              // Features section
              Text(
                'الاقسام',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 16),

              // Feature cards grid
              const FeatureCards(),
              const SizedBox(height: 32),

              // Theme toggle section
              _buildThemeSection(context, themeController),
            ],
          ),
        ),
      ),
    );
  }

  /// Build welcome card with gradient
  Widget _buildWelcomeCard(BuildContext context, bool isDarkMode) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 16),
          Text(
            'القرآن جَنّةٌ في صدر حافظه',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: isDarkMode
                  ? AppColors.primaryDark
                  : AppColors.primaryLight,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'تجربة فريدة ومُلهمة لحفظ ومراجعة القرآن الكريم عبر الاستماع، مع أدوات ذكية تُعينك على التركيز، وتُسهّل عليك متابعة الحفظ والمراجعة.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color:
                  (isDarkMode
                          ? AppColors.textPrimaryDark
                          : AppColors.textPrimaryLight)
                      .withAlpha(204),
            ),
          ),
        ],
      ),
    );
  }

  /// Build theme toggle section
  Widget _buildThemeSection(
    BuildContext context,
    ThemeController themeController,
  ) {
    final isDarkMode = themeController.isDarkMode;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDarkMode
                    ? AppColors.gradientDark
                    : AppColors.gradientLight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isDarkMode ? Icons.dark_mode : Icons.light_mode,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isDarkMode ? 'Dark Mode' : 'Light Mode',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isDarkMode
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight,
                  ),
                ),
                Text(
                  isDarkMode ? 'الوضع الداكن' : 'الوضع الفاتح',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDarkMode
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
                  ),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: isDarkMode,
            onChanged: (_) => themeController.toggleTheme(),
            activeTrackColor: AppColors.primaryDark,
          ),
        ],
      ),
    );
  }
}
