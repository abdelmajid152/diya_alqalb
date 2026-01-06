import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/theme/theme_controller.dart';

/// Dialog widget showing Nawawi hadith explanation
class NawawiDialog extends StatelessWidget {
  final String description;

  const NawawiDialog({super.key, required this.description});

  @override
  Widget build(BuildContext context) {
    final themeController = ThemeController.to;
    final isDarkMode = themeController.isDarkMode;

    return AlertDialog(
      scrollable: true,
      backgroundColor: isDarkMode
          ? AppColors.surfaceDark
          : AppColors.surfaceLight,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        'شرح الحديث',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: isDarkMode
              ? AppColors.textPrimaryDark
              : AppColors.textPrimaryLight,
        ),
        textAlign: TextAlign.center,
      ),
      content: SelectableText(
        description,
        style: TextStyle(
          fontSize: 16,
          height: 1.8,
          fontFamily: "UthmanicHafs",
          color: isDarkMode
              ? AppColors.textPrimaryDark
              : AppColors.textPrimaryLight,
        ),
        textAlign: TextAlign.right,
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: Text(
            'إغلاق',
            style: TextStyle(
              color: isDarkMode
                  ? AppColors.primaryDark
                  : AppColors.primaryLight,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  /// Show the dialog
  static void show(String description) {
    Get.dialog(
      NawawiDialog(description: description),
      barrierDismissible: false,
    );
  }
}
