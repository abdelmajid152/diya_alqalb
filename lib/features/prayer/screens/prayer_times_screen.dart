import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/theme/theme_controller.dart';
import '../controllers/prayer_controller.dart';
import 'qibla_compass_screen.dart';

/// Prayer times screen with countdown and prayer list
class PrayerTimesScreen extends GetView<PrayerController> {
  const PrayerTimesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = ThemeController.to;

    return Obx(() {
      final isDarkMode = themeController.isDarkMode;
      final colorScheme = Theme.of(context).colorScheme;

      return Scaffold(
        appBar: AppBar(
          title: const Text('مواقيت الصلاة'),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () => Get.back(),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.explore),
              tooltip: 'اتجاه القبلة',
              onPressed: () {
                if (controller.qiblaDirection.value != null) {
                  Get.to(()=>
                    const QiblaCompassScreen(),

                  );
                } else {
                  Get.snackbar(
                    'انتظر',
                    'جاري تحديد موقع القبلة...',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: colorScheme.primary,
                    colorText: colorScheme.onPrimary,
                  );
                }
              },
            ),
          ],
        ),
        body: _buildBody(context, isDarkMode),
      );
    });
  }

  Widget _buildBody(BuildContext context, bool isDarkMode) {
    final colorScheme = Theme.of(context).colorScheme;

    return Obx(() {
      // Loading state
      if (controller.isLoading.value) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: colorScheme.primary),
              const SizedBox(height: 16),
              Text(
                'جاري تحميل المواقيت...',
                style: TextStyle(
                  color: isDarkMode
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight,
                ),
              ),
            ],
          ),
        );
      }

      // Error state
      if (controller.error.value != null &&
          controller.prayerTimes.value == null) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.cloud_off, size: 80, color: colorScheme.error),
                const SizedBox(height: 16),
                Text(
                  controller.error.value!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: isDarkMode
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () => controller.loadData(),
                  icon: const Icon(Icons.refresh),
                  label: const Text('إعادة المحاولة'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }

      // Data loaded
      return RefreshIndicator(
        onRefresh: () => controller.refreshData(),
        color: colorScheme.primary,
        child: Column(
          children: [
            // Offline indicator
            if (controller.isOffline.value)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 8),
                color: Colors.orange,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.cloud_off, color: Colors.white, size: 18),
                    SizedBox(width: 8),
                    Text(
                      'أنت غير متصل - البيانات من التخزين المحلي',
                      style: TextStyle(color: Colors.white, fontSize: 13),
                    ),
                  ],
                ),
              ),

            // Next prayer countdown card
            _buildCountdownCard(context, isDarkMode),

            // Prayer times list
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildPrayerTile(context, 'الفجر', 'Fajr', isDarkMode,Icons.nights_stay),
                  _buildPrayerTile(context, 'الشروق', 'Sunrise', isDarkMode,Icons.wb_sunny),
                  _buildPrayerTile(context, 'الظهر', 'Dhuhr', isDarkMode,Icons.wb_sunny_outlined),
                  _buildPrayerTile(context, 'العصر', 'Asr', isDarkMode,Icons.sunny),
                  _buildPrayerTile(context, 'المغرب', 'Maghrib', isDarkMode,Icons.nightlight_round),
                  _buildPrayerTile(context, 'العشاء', 'Isha', isDarkMode,Icons.dark_mode),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildCountdownCard(BuildContext context, bool isDarkMode) {
    return Hero(
      tag: 'countdown_card',
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: double.infinity,
          height: 280,
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(

            image: const DecorationImage(
              opacity: 0.3,
              fit: BoxFit.cover,
              image: AssetImage('assets/images/masjed.jpg'),
            ),
            color: AppColors.primaryDark,
            // gradient: LinearGradient(
            //   colors: AppColors.gradientDark ,
            //   begin: Alignment.topLeft,
            //   end: Alignment.bottomRight,
            // ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40,),
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
                  ' وقت الصلاة القادمة بعد ${controller.formattedCountdown}',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPrayerTile(
    BuildContext context,
    String arabicName,
    String englishCode,
    bool isDarkMode,
      IconData icon
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return Obx(() {
      final times = controller.prayerTimes.value;
      final isNext = controller.nextPrayerName.value == englishCode;
      final timeStr = times?.getTimeForPrayer(englishCode) ?? '--:--';

      return Container(
        margin: const EdgeInsets.only(bottom: 8),

        decoration: BoxDecoration(
          color: isDarkMode ? AppColors.surfaceDark : AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withAlpha(13), blurRadius: 10, offset: const Offset(0, 4))],
          border:  isNext
              ? Border.all(color: colorScheme.primary, width: 2)
              : null,
        ),


        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 8,
          ),
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isNext
                  ? colorScheme.primary
                  : colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: isNext ? Colors.white : colorScheme.primary,
            ),
          ),
          title: Text(
            arabicName,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: isNext
                  ? colorScheme.primary
                  : (isDarkMode
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight),
            ),
          ),
          trailing: Text(
            timeStr,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isNext
                  ? colorScheme.primary
                  : (isDarkMode
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight),
            ),
          ),
        ),
      );
    });
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
  String _getNextPrayerTime(PrayerController controller) {
    final times = controller.prayerTimes.value;
    if (times == null) return '--:--';
    return times.getTimeForPrayer(controller.nextPrayerName.value);
  }
}
