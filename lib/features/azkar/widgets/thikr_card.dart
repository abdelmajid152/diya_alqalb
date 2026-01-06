import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/theme/theme_controller.dart';
import '../controllers/azkar_controller.dart';
import '../models/thikr_model.dart';


class ZekrCard extends GetView<AzkarController> {
  final Thikr azkar;
  final String categoryName;
  final int index;

  const ZekrCard({
    super.key,
    required this.azkar,
    required this.categoryName,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final maxCount = azkar.countAsInt;
    final themeController = ThemeController.to;

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thikr content container with image background
          Container(
            decoration: BoxDecoration(
              image: const DecorationImage(
                opacity: 0.3,
                fit: BoxFit.fill,
                image: AssetImage('assets/images/backagarawen.jpg'),
              ),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: colorScheme.primary, width: 3),
            ),
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SelectableText(
                    azkar.content,

                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: themeController.isDarkMode
                          ? AppColors.textPrimaryDark
                          : AppColors.textPrimaryLight,
                      fontFamily: "UthmanicHafs",
                      height: 1.8,
                    ),
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10,),
                  if(azkar.description.isNotEmpty)
                  SelectableText(
                    azkar.description,

                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: themeController.isDarkMode
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                      fontFamily: "UthmanicHafs",
                      height: 1.8,
                    ),
                  // textAlign: TextAlign.center,
                    textDirection: TextDirection.rtl,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Count label
          Text(
            "عدد مرات التكرار : ${azkar.count}",
            style: TextStyle(
              color: colorScheme.primary,
              fontSize: 17,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 8),

          // Action bar with share, copy, and counter
          Container(
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: colorScheme.outline, width: 3),
            ),
            width: double.infinity,
            child: Obx(() {
              final currentCount = controller.getCurrentCount(
                categoryName,
                index,
              );
              final isCompleted = controller.isCompleted(
                categoryName,
                index,
                maxCount,
              );

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Share button
                  IconButton(
                    onPressed: () {
                      Share.share(azkar.content);
                    },
                    icon: Icon(Icons.share, color: colorScheme.primary),
                    tooltip: 'مشاركة',
                  ),

                  // Copy button
                  IconButton(
                    onPressed: () {
                      Clipboard.setData(
                        ClipboardData(text: azkar.content),
                      ).then((_) {
                        Get.snackbar(
                          'تم النسخ',
                          'تم نسخ الذكر إلى الحافظة',
                          snackPosition: SnackPosition.BOTTOM,
                          duration: const Duration(milliseconds: 1500),
                          backgroundColor: colorScheme.primary,
                          colorText: colorScheme.onPrimary,
                          margin: const EdgeInsets.all(16),
                          borderRadius: 8,
                        );
                      });
                    },
                    icon: Icon(Icons.copy, color: colorScheme.primary),
                    tooltip: 'نسخ',
                  ),

                  // Counter button
                  InkWell(
                    onTap: () {
                      if (currentCount < maxCount) {
                        controller.incrementCount(
                          categoryName,
                          index,
                          maxCount,
                        );

                        // Vibrate on completion
                        if (currentCount + 1 == maxCount) {
                          HapticFeedback.heavyImpact();
                        }
                      }
                    },
                    onLongPress: () {
                      // Reset on long press
                      if (currentCount > 0) {
                        controller.resetCount(categoryName, index);
                        HapticFeedback.lightImpact();
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isCompleted ? Colors.green : colorScheme.primary,
                        border: Border.all(color: Colors.white, width: 2),
                        boxShadow: const [
                          BoxShadow(
                            offset: Offset(0, 2),
                            blurRadius: 4,
                            color: Colors.black26,
                          ),
                        ],
                      ),
                      width: 50,
                      height: 50,
                      child: Center(
                        child: Text(
                          currentCount.toString(),
                          textAlign: TextAlign.center,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }),
          ),

          // Show completion indicator
          Obx(() {
            final isCompleted = controller.isCompleted(
              categoryName,
              index,
              maxCount,
            );
            if (isCompleted) {
              return Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle, color: Colors.green, size: 20),
                    const SizedBox(width: 4),
                    Text(
                      'تم إكمال هذا الذكر اضغط مطولا للبدء من جديد  ',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
    );
  }
}
