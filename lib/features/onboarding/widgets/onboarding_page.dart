import 'package:flutter/material.dart';
import '../models/onboarding_page_model.dart';
import '../../../core/constants/app_colors.dart';

/// Widget for a single onboarding page
class OnboardingPageWidget extends StatelessWidget {
  final OnboardingPageModel data;
  final bool isDarkMode;

  const OnboardingPageWidget({
    super.key,
    required this.data,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon with animated container
          Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDarkMode
                    ? AppColors.gradientDark
                    : AppColors.gradientLight,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color:
                      (isDarkMode
                              ? AppColors.primaryDark
                              : AppColors.primaryLight)
                          .withAlpha(77),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Center(
              child: Text(data.icon, style: const TextStyle(fontSize: 80)),
            ),
          ),
          const SizedBox(height: 60),

          // Title
          Text(
            data.title,
            style: Theme.of(
              context,
            ).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),

          // Subtitle
          Text(
            data.subtitle,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: isDarkMode
                  ? AppColors.primaryDark
                  : AppColors.primaryLight,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),

          // Description
          Text(
            data.description,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.6),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
