import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/theme/theme_controller.dart';
import '../models/nawawi_model.dart';
import 'nawawi_dialog.dart';

/// Individual Nawawi hadith card widget
class NawawiItem extends StatelessWidget {
  final Nawawi nawawi;

  const NawawiItem({super.key, required this.nawawi});

  @override
  Widget build(BuildContext context) {
    final themeController = ThemeController.to;
    final isDarkMode = themeController.isDarkMode;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // Title
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(
              nawawi.title,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? AppColors.primaryDark : AppColors.primaryLight,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          // Hadith content
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: isDarkMode ? AppColors.surfaceDark : AppColors.surfaceLight,
                border: Border.all(
                  color: isDarkMode ? AppColors.primaryDark.withOpacity(0.3) : AppColors.primaryLight.withOpacity(0.3),
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: SelectableText(
                  nawawi.hadith,
                  style: TextStyle(
                    fontFamily: "UthmanicHafs",
                    fontSize: 18,
                    height: 1.8,
                    color: isDarkMode ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
            ),
          ),

          // Explanation button
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => NawawiDialog.show(nawawi.description),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDarkMode ? AppColors.primaryDark : AppColors.primaryLight,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('شرح الحديث', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
