import 'package:get/get.dart';
import '../../../core/theme/theme_controller.dart';

/// Home screen controller
class HomeController extends GetxController {
  static HomeController get to => Get.find();

  /// Reference to theme controller
  ThemeController get themeController => ThemeController.to;

  /// Toggle theme
  void toggleTheme() {
    themeController.toggleTheme();
  }
}
