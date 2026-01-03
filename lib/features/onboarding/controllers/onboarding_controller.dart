import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../core/routes/app_routes.dart';
import '../models/onboarding_page_model.dart';

/// Controller for onboarding flow management
class OnboardingController extends GetxController {
  static OnboardingController get to => Get.find();

  final _storage = GetStorage();
  final _key = 'onboardingCompleted';

  /// Current page index
  final _currentPage = 0.obs;
  int get currentPage => _currentPage.value;

  /// Onboarding pages data
  final List<OnboardingPageModel> pages = [
    OnboardingPageModel(
      title: 'مرحباً بك',
      subtitle: 'Welcome',
      description: 'ضياء القلب - تطبيقك المميز لتجربة فريدة',
      icon: '💫',
    ),
    OnboardingPageModel(
      title: 'اكتشف المميزات',
      subtitle: 'Discover Features',
      description: 'استمتع بتجربة سلسة ومميزة مع واجهة عصرية وسهلة الاستخدام',
      icon: '✨',
    ),
    OnboardingPageModel(
      title: 'ابدأ الآن',
      subtitle: 'Get Started',
      description: 'انضم إلينا واستمتع بكل ما نقدمه من خدمات رائعة',
      icon: '🚀',
    ),
  ];

  /// Check if user is on the last page
  bool get isLastPage => _currentPage.value == pages.length - 1;

  /// Navigate to next page
  void nextPage() {
    if (isLastPage) {
      completeOnboarding();
    } else {
      _currentPage.value++;
    }
  }

  /// Navigate to previous page
  void previousPage() {
    if (_currentPage.value > 0) {
      _currentPage.value--;
    }
  }

  /// Update current page (for PageView sync)
  void updatePage(int index) {
    _currentPage.value = index;
  }

  /// Skip onboarding and go to home
  void skipOnboarding() {
    completeOnboarding();
  }

  /// Complete onboarding and navigate to home
  void completeOnboarding() {
    _storage.write(_key, true);
    Get.offAllNamed(AppRoutes.home);
  }

  /// Check if onboarding was completed before
  static bool isOnboardingCompleted() {
    return GetStorage().read('onboardingCompleted') ?? false;
  }
}
