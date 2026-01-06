import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/theme/theme_controller.dart';
import '../models/tafsir_model.dart';

/// Item widget for tafsir surah in list
class TafsirItem extends StatelessWidget {
  final TafsirModel tafsir;
  final VoidCallback onTap;

  const TafsirItem({super.key, required this.tafsir, required this.onTap});

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
                    '${tafsir.suraId}',
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
                  tafsir.name,
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
