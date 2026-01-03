import 'package:get/get.dart';
import '../theme/theme_controller.dart';
import '../../features/onboarding/controllers/onboarding_controller.dart';
import '../../features/home/controllers/home_controller.dart';

/// Initial binding for all app-wide and feature dependencies
class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Core controllers - persistent throughout app lifecycle
    Get.put(ThemeController(), permanent: true);

    // Feature controllers - lazy loaded when needed
    Get.lazyPut<OnboardingController>(() => OnboardingController());
    Get.lazyPut<HomeController>(() => HomeController());
  }
}
