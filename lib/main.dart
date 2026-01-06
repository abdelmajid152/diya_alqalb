import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'core/bindings/initial_binding.dart';
import 'core/routes/app_pages.dart';
import 'core/routes/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';
import 'core/services/notification_service.dart';
import 'features/onboarding/controllers/onboarding_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize GetStorage for persistent data
  await GetStorage.init();

  // Initialize theme controller early
  Get.put(ThemeController(), permanent: true);

  // Initialize notification service for Azkar reminders

 await NotificationService.initialize();

  runApp(const DiyaAlQalbApp());
}

class DiyaAlQalbApp extends StatelessWidget {
  const DiyaAlQalbApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = ThemeController.to;

    // Determine initial route based on onboarding completion
    final initialRoute = OnboardingController.isOnboardingCompleted()
        ? AppRoutes.home
        : AppRoutes.onboarding;

    return Obx(
      () => GetMaterialApp(
        title: 'ضياء القلب',
        debugShowCheckedModeBanner: false,

        // Arabic localization
        locale: const Locale('ar', 'SA'),
        supportedLocales: const [Locale('ar', 'SA')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],

        // Theme configuration
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: themeController.themeMode,

        // Routing
        initialRoute: initialRoute,
        getPages: AppPages.pages,
        initialBinding: InitialBinding(),

        // Default transitions
        defaultTransition: Transition.fadeIn,
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }
}
