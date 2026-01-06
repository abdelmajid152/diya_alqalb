import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/theme/theme_controller.dart';
import '../controllers/prayer_controller.dart';

/// Qibla compass screen with reactive compass heading
class QiblaCompassScreen extends GetView<PrayerController> {
  const QiblaCompassScreen({super.key});

  /// Alignment threshold in degrees - must be very precise
  static const double alignmentThreshold = 2.0;

  @override
  Widget build(BuildContext context) {
    // Start compass when screen opens
    controller.startCompass();

    final themeController = ThemeController.to;

    return Scaffold(
      appBar: AppBar(title: Text('القبلة'),),
      body: Center(
        child: Container(

          decoration: BoxDecoration(
            color: themeController.isDarkMode
                ? AppColors.surfaceDark
                : AppColors.surfaceLight,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(

            children: [
              // Handle bar
              const SizedBox(height: 300),


              // Content
              Expanded(child: Obx(() => _buildCompassContent(context))),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompassContent(BuildContext context) {
    final themeController = ThemeController.to;
    final isDarkMode = themeController.isDarkMode;
    final colorScheme = Theme.of(context).colorScheme;

    final heading = controller.heading.value;
    final qiblaDirection = controller.qiblaDirection.value;

    // No compass support
    if (heading == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.compass_calibration, size: 60, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              'جهازك لا يدعم البوصلة',
              style: TextStyle(
                fontSize: 18,
                color: isDarkMode
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimaryLight,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'تأكد من معايرة البوصلة بتحريك الهاتف بشكل دائري',
              style: TextStyle(
                fontSize: 14,
                color: isDarkMode
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    // Calculate rotation angle for the arrow
    final double qibla = qiblaDirection ?? 0;
    double angleRadians = (qibla - heading) * (math.pi / 180);

    // Calculate the accurate difference
    double diff = qibla - heading;
    // Normalize to -180 to 180 range
    while (diff > 180) diff -= 360;
    while (diff < -180) diff += 360;
    double absDiff = diff.abs();

    // Strict alignment check
    bool isAligned = absDiff <= alignmentThreshold;

    // Trigger haptic on alignment
    if (isAligned) {
      controller.checkQiblaAlignment();
    }

    // Determine status color and text based on deviation
    Color statusColor;
    String statusText;
    if (isAligned) {
      statusColor = Colors.green;
      statusText = 'القبلة صحيحة ';
    } else if (absDiff <= 10) {
      statusColor = Colors.orange;
      statusText = 'قريب جداً - ${diff > 0 ? "أدر يميناً" : "أدر يساراً"}';
    } else if (absDiff <= 30) {
      statusColor = Colors.orange.shade700;
      statusText = diff > 0 ? 'أدر يميناً ←' : 'أدر يساراً →';
    } else {
      statusColor = Colors.red.shade400;
      statusText = 'ابحث عن القبلة...';
    }

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Status text
          Text(
            statusText,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: statusColor,
            ),
          ),

          // Deviation indicator
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: statusColor.withValues(alpha: 0.3)),
            ),
            child: Text(
              'الانحراف: ${absDiff.toStringAsFixed(1)}°',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: statusColor,
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Compass
          Stack(
            alignment: Alignment.center,
            children: [
              // Compass background circle
              Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDarkMode
                      ? Colors.grey.shade800.withValues(alpha: 0.3)
                      : Colors.grey.shade100,
                  border: Border.all(
                    color: isAligned
                        ? Colors.green
                        : statusColor.withValues(alpha: 0.5),
                    width: isAligned ? 4 : 2,
                  ),
                  boxShadow: isAligned
                      ? [
                          BoxShadow(
                            color: Colors.green.withValues(alpha: 0.3),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ]
                      : [],
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    // North indicator (phone direction)
                    Icon(
                      Icons.arrow_drop_up,
                      color: isAligned ? Colors.green : Colors.grey,
                      size: 30,
                    ),

                  ],
                ),
              ),

              // Qibla arrow - rotates to show direction
              Transform.rotate(
                angle: -angleRadians,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.navigation,
                      size: 100,
                      color: isAligned ? Colors.green : colorScheme.primary,
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: isAligned ? Colors.green : colorScheme.primary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        'القبلة',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Kaaba icon when aligned
              if (isAligned)
                const Positioned(
                  top: 50,
                  child: Icon(Icons.mosque, size: 40, color: Colors.green),
                ),
            ],
          ),

          const Spacer(),

          // Direction info
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDarkMode
                  ? Colors.grey.shade800.withValues(alpha: 0.3)
                  : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'زاوية القبلة:',
                      style: TextStyle(
                        fontSize: 14,
                        color: isDarkMode
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                      ),
                    ),
                    Text(
                      '${qiblaDirection?.toStringAsFixed(1) ?? '--'}°',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimaryLight,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'اتجاه هاتفك:',
                      style: TextStyle(
                        fontSize: 14,
                        color: isDarkMode
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                      ),
                    ),
                    Text(
                      '${heading.toStringAsFixed(1)}°',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimaryLight,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
