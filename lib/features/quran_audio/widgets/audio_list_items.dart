import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/theme/theme_controller.dart';
import '../models/reciter_model.dart';

/// Item widget for reciter in list
class ReciterItem extends StatelessWidget {
  final ReciterModel reciter;
  final VoidCallback onTap;

  const ReciterItem({super.key, required this.reciter, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final isDark = themeController.isDarkMode;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Reciter icon
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color:
                      (isDark ? AppColors.primaryDark : AppColors.primaryLight)
                          .withAlpha(26),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  FlutterIslamicIcons.quran2,
                  size: 28,
                  color: isDark
                      ? AppColors.primaryDark
                      : AppColors.primaryLight,
                ),
              ),
              const SizedBox(width: 16),
              // Reciter info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reciter.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimaryLight,
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                    if (reciter.firstMoshaf != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        reciter.firstMoshaf!.name,
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondaryLight,
                        ),
                        textDirection: TextDirection.rtl,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Arrow
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Item widget for surah in audio list
class SurahAudioItem extends StatelessWidget {
  final int surahId;
  final String surahName;
  final VoidCallback onTap;

  const SurahAudioItem({
    super.key,
    required this.surahId,
    required this.surahName,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final isDark = themeController.isDarkMode;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Surah number
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color:
                      (isDark ? AppColors.primaryDark : AppColors.primaryLight)
                          .withAlpha(26),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    '$surahId',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? AppColors.primaryDark
                          : AppColors.primaryLight,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Surah name
              Expanded(
                child: Text(
                  surahName,
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'UthmanicHafs',
                    fontWeight: FontWeight.w500,
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight,
                  ),
                  textDirection: TextDirection.rtl,
                ),
              ),
              // Play icon
              Icon(
                Icons.play_circle_outline,
                color: isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight,
                size: 28,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
