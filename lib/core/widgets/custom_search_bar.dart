import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants/app_colors.dart';
import '../theme/theme_controller.dart';

/// Custom search bar with back button for feature screens
class CustomSearchBar extends StatelessWidget {
  final VoidCallback onBack;
  final Function(String) onSearch;
  final String hintText;

  const CustomSearchBar({
    super.key,
    required this.onBack,
    required this.onSearch,
    this.hintText = 'بحث...',
  });

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // Back button
          IconButton(
            onPressed: onBack,
            icon: Icon(
              Icons.arrow_forward_ios,
              color: themeController.isDarkMode
                  ? AppColors.textPrimaryDark
                  : AppColors.textPrimaryLight,
            ),
          ),
          // Search field
          Expanded(
            child: TextField(
              onChanged: onSearch,
              textDirection: TextDirection.rtl,
              decoration: InputDecoration(
                hintText: hintText,
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
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              style: TextStyle(
                color: themeController.isDarkMode
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimaryLight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
