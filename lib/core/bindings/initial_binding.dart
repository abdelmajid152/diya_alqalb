import 'package:get/get.dart';
import '../theme/theme_controller.dart';
import '../../features/onboarding/controllers/onboarding_controller.dart';
import '../../features/home/controllers/home_controller.dart';
import '../../features/azkar/controllers/azkar_controller.dart';
import '../../features/prayer/controllers/prayer_controller.dart';
import '../../features/nawawi/controllers/nawawi_controller.dart';
import '../../features/tafsir/controllers/tafsir_controller.dart';
import '../../features/quran_audio/controllers/reciters_controller.dart';

/// Initial binding for all app-wide and feature dependencies
class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Core controllers - persistent throughout app lifecycle
    Get.put(ThemeController(), permanent: true);

    // Feature controllers - lazy loaded when needed
    Get.lazyPut<OnboardingController>(() => OnboardingController());
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<AzkarController>(() => AzkarController());
    Get.lazyPut<PrayerController>(() => PrayerController());
    Get.lazyPut<NawawiController>(() => NawawiController());
    Get.lazyPut<TafsirController>(() => TafsirController());
    Get.lazyPut<RecitersController>(() => RecitersController());
  }
}
