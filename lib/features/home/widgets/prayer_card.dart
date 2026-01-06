import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/theme/theme_controller.dart';
import '../../prayer/controllers/prayer_controller.dart';
import '../../prayer/screens/prayer_times_screen.dart';

/// Prayer card widget showing next prayer time with countdown
class PrayerCard extends StatelessWidget {
  const PrayerCard({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = ThemeController.to;

    // Ensure PrayerController is initialized
    if (!Get.isRegistered<PrayerController>()) {
      Get.put(PrayerController());
    }
    final prayerController = Get.find<PrayerController>();

    return Obx(() {
      final isDarkMode = themeController.isDarkMode;
      final isLoading = prayerController.isLoading.value;
      final hasError =
          prayerController.error.value != null &&
          prayerController.prayerTimes.value == null;
      final isOffline = prayerController.isOffline.value;

      return GestureDetector(
        onTap: () => Get.to(() => const PrayerTimesScreen(),
          transition: Transition.fade,
          duration: const Duration(milliseconds: 400),
        ),
        child: Hero(
          tag: 'countdown_card',
          child: Material(
            color: Colors.transparent,
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(20),
            
              decoration: BoxDecoration(
                image: const DecorationImage(
                  opacity: 0.2,
                  fit: BoxFit.cover,
            
                  image: AssetImage('assets/images/masjed.jpg'),
                ),
                color: isDarkMode ? AppColors.primaryDark : AppColors.primaryLight,
                borderRadius: BorderRadius.circular(16),
              ),
              child: isLoading
                  ? _buildLoadingState()
                  : hasError
                  ? _buildErrorState(prayerController)
                  : _buildDataState(prayerController, isOffline),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildLoadingState() {
    return const SizedBox(
      height: 150,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Colors.white),
            SizedBox(height: 12),
            Text(
              'جاري تحميل مواقيت الصلاة...',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(PrayerController controller) {
    return SizedBox(
      height: 150,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.cloud_off, color: Colors.white70, size: 40),
            const SizedBox(height: 12),
            Text(
              controller.error.value ?? 'حدث خطأ',
              style: const TextStyle(color: Colors.white, fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () => controller.loadData(),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: const BorderSide(color: Colors.white),
              ),
              child: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataState(PrayerController controller, bool isOffline) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Offline indicator + Date row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (isOffline)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.cloud_off, color: Colors.white, size: 14),
                    SizedBox(width: 4),
                    Text(
                      'غير متصل',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
              )
            else
              const SizedBox(),
            const Text(
              "", // Date would go here if we add Hijri date
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),

        const SizedBox(height: 10),

        // Prayer info row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Prayer info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(
                    () => Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          controller.nextPrayerNameArabic.value,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          _getPrayerIcon(controller.nextPrayerName.value),
                          color: Colors.white,
                          size: 24,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Obx(
                    () => Text(
                      _getNextPrayerTime(controller),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        height: 1.0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Obx(
                    () => Text(
                      ' وقت الصلاة القادمة ${controller.formattedCountdown}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),


          ],
        ),

        const SizedBox(height: 15),
        const Divider(color: Colors.white38, thickness: 1),
        const SizedBox(height: 10),

        // Bottom row
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'اضغط لعرض جميع أوقات الصلاة',
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
            Icon(Icons.arrow_back_ios, color: Colors.white, size: 18),
          ],
        ),
      ],
    );
  }

  String _getNextPrayerTime(PrayerController controller) {
    final times = controller.prayerTimes.value;
    if (times == null) return '--:--';
    return times.getTimeForPrayer(controller.nextPrayerName.value);
  }

  IconData _getPrayerIcon(String prayerName) {
    switch (prayerName) {
      case 'Fajr':
        return Icons.nights_stay;
      case 'Sunrise':
        return Icons.wb_sunny;
      case 'Dhuhr':
        return Icons.wb_sunny_outlined;
      case 'Asr':
        return Icons.sunny;
      case 'Maghrib':
        return Icons.nightlight_round;
      case 'Isha':
        return Icons.dark_mode;
      default:
        return Icons.access_time;
    }
  }
}
