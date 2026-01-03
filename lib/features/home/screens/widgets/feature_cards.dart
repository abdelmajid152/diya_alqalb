import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/theme_controller.dart';

class FeatureCards extends GetView<ThemeController> {
  const FeatureCards({super.key});

  @override
  Widget build(BuildContext context) {
    return  Obx(
      ()=> GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.1,
        children: [
          _buildFeatureCard(
            context,
            icon: Icons.auto_awesome,
            title: 'القران الكريم',
            subtitle: ' القران الكريم ',
            isDarkMode: controller.isDarkMode,
          ),
          _buildFeatureCard(
            context,
            icon: Icons.palette_outlined,
            title: 'الاذكار ',
            subtitle: 'الاذكار ',
            isDarkMode: controller.isDarkMode,
          ),
          _buildFeatureCard(
            context,
            icon: Icons.speed,
            title: 'ادعية',
            subtitle: 'ادعية',
            isDarkMode: controller.isDarkMode,
          ),
          _buildFeatureCard(
            context,
            icon: Icons.security,
            title: 'القبلة',
            subtitle: 'القبلة',
            isDarkMode: controller.isDarkMode,
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
      }) {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color:
              (isDarkMode ? AppColors.primaryDark : AppColors.primaryLight)
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
    );
  }
}
