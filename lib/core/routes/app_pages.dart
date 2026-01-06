import 'package:get/get.dart';
import '../../features/onboarding/screens/onboarding_screen.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/nawawi/screens/nawawi_screen.dart';
import '../../features/tafsir/screens/tafsir_screen.dart';
import '../../features/tafsir/screens/tafsir_player_screen.dart';
import '../../features/quran_audio/screens/reciters_screen.dart';
import '../../features/quran_audio/screens/suwar_screen.dart';
import '../../features/quran_audio/screens/quran_player_screen.dart';
import 'app_routes.dart';

/// App pages configuration for GetX routing
class AppPages {
  static final List<GetPage> pages = [
    GetPage(
      name: AppRoutes.onboarding,
      page: () => const OnboardingScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.nawawi,
      page: () => const NawawiScreen(),
      transition: Transition.rightToLeft,
    ),
    // Tafsir pages
    GetPage(
      name: AppRoutes.tafsir,
      page: () => const TafsirScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.tafsirPlayer,
      page: () => const TafsirPlayerScreen(),
      transition: Transition.rightToLeft,
    ),
    // Quran Audio pages
    GetPage(
      name: AppRoutes.quranAudio,
      page: () => const RecitersScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.quranAudioSuwar,
      page: () => const SuwarScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.quranAudioPlayer,
      page: () => const QuranPlayerScreen(),
      transition: Transition.rightToLeft,
    ),
  ];
}
