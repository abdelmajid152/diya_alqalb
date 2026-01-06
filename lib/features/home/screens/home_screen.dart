import 'package:diya_alqalb/features/prayer/screens/qibla_compass_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:get/get.dart';
import '../../azkar/screens/azkar_screen.dart';
import '../../nawawi/screens/nawawi_screen.dart';
import '../../tafsir/screens/tafsir_screen.dart';
import '../../quran_audio/screens/reciters_screen.dart';
import '../controllers/home_controller.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/theme/theme_controller.dart';
import '../widgets/prayer_card.dart';

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
          child: Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome card
                _buildWelcomeCard(context, themeController.isDarkMode),
                const SizedBox(height: 24),

                PrayerCard(),

                // Features section
                Text(
                  'الاقسام',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 16),

                // Feature cards grid
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.1,
                  children: [
                    _buildFeatureCard(
                      context,
                      icon: FlutterIslamicIcons.quran2,
                      title: 'القران الكريم',
                      subtitle: ' القران الكريم صوتي ',
                      isDarkMode: themeController.isDarkMode,
                      onPressed: () => Get.to(() => const RecitersScreen()),
                    ),
                    _buildFeatureCard(
                      context,
                      icon: FlutterIslamicIcons.solidTasbihHand,
                      title: 'الاذكار ',
                      subtitle: 'الاذكار ',
                      isDarkMode: themeController.isDarkMode,
                      onPressed: () => Get.to((AzkarScreen())),
                    ),
                    _buildFeatureCard(
                      context,
                      icon: FlutterIslamicIcons.quran,
                      title: 'تفسير',
                      subtitle: 'تفسير الطبري',
                      isDarkMode: themeController.isDarkMode,
                      onPressed: () => Get.to(() => const TafsirScreen()),
                    ),
                    _buildFeatureCard(
                      context,
                      icon: FlutterIslamicIcons.qibla2,
                      title: 'القبلة',
                      subtitle: 'القبلة',
                      isDarkMode: themeController.isDarkMode,
                      onPressed: () => Get.to(() => QiblaCompassScreen()),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Theme toggle section
                _buildThemeSection2(context, themeController),
              ],
            ),
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
            'تجربة فريدة ومُلهمة لحفظ ومراجعة القرآن الكريم عبر الاستماع.',
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

  /// Build feature card
  Widget _buildFeatureCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isDarkMode,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color:
                    (isDarkMode
                            ? AppColors.primaryDark
                            : AppColors.primaryLight)
                        .withAlpha(26),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: isDarkMode
                    ? AppColors.primaryDark
                    : AppColors.primaryLight,
                size: 28,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isDarkMode
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimaryLight,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
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

  Widget _buildThemeSection2(
    BuildContext context,
    ThemeController themeController,
  ) {
    final isDarkMode = themeController.isDarkMode;

    return GestureDetector(
      onTap: () => Get.to(() => const NawawiScreen()),
      child: Container(
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color:
                    (isDarkMode
                            ? AppColors.primaryDark
                            : AppColors.primaryLight)
                        .withAlpha(26),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                FlutterIslamicIcons.solidMohammad,
                color: isDarkMode
                    ? AppColors.primaryDark
                    : AppColors.primaryLight,
                size: 28,
              ),
            ),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'الاربعون النووية',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isDarkMode
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight,
                  ),
                ),
                Text(
                  "الاربعون النووية مكتوبة ",
                  style: TextStyle(
                    fontSize: 12,
                    color: isDarkMode
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
