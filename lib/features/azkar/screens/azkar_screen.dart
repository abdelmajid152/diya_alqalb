import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/theme/theme_controller.dart';
import '../controllers/azkar_controller.dart';
import '../models/azkar_category_model.dart';
import 'category_detail_screen.dart';

class AzkarScreen extends StatefulWidget {
  const AzkarScreen({super.key});

  @override
  State<AzkarScreen> createState() => _AzkarScreenState();
}

class _AzkarScreenState extends State<AzkarScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late AzkarController controller;

  @override
  void initState() {
    super.initState();

    // Ensure controller is registered
    if (!Get.isRegistered<AzkarController>()) {
      Get.put(AzkarController());
    }
    controller = Get.find<AzkarController>();

    // Animation controller for staggered list animation
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    // Start animation when data is loaded
    ever(controller.categories, (_) {
      if (controller.categories.isNotEmpty &&
          !_animationController.isAnimating) {
        _animationController.forward();
      }
    });

    // If data already loaded, start animation
    if (controller.categories.isNotEmpty) {
      Future.delayed(const Duration(milliseconds: 100), () {
        _animationController.forward();
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final themeController = ThemeController.to;

    return Scaffold(
      appBar: AppBar(title: const Text('أذكار المسلم'), centerTitle: true),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(color: colorScheme.primary),
          );
        }

        if (controller.error.value != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 60, color: colorScheme.error),
                const SizedBox(height: 16),
                Text(
                  controller.error.value!,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: controller.loadCategories,
                  icon: const Icon(Icons.refresh),
                  label: const Text('إعادة المحاولة'),
                ),
              ],
            ),
          );
        }

        final categories = controller.categories;

        if (categories.isEmpty) {
          return Center(
            child: Text(
              'لا توجد أذكار متاحة',
              style: theme.textTheme.bodyLarge,
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return _AnimatedCategoryCard(
              animation: _animationController,
              index: index,
              totalItems: categories.length,
              child: _buildCategoryCard(
                context,
                category,
                themeController.isDarkMode,
              ),
            );
          },
        );
      }),
    );
  }

  Widget _buildCategoryCard(
    BuildContext context,
    AzkarCategory category,
    bool isDarkMode,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        controller.selectCategory(category);
        Get.to(
          () => CategoryDetailScreen(category: category),
          transition: Transition.fadeIn,
          duration: const Duration(milliseconds: 300),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          color: isDarkMode ? AppColors.surfaceDark : AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(13),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon container using FlutterIslamicIcons
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color:
                    (isDarkMode
                            ? AppColors.primaryDark
                            : AppColors.primaryLight)
                        .withAlpha(26),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Icon(
                  category.icon,
                  size: 30,
                  color: colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category.name,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: isDarkMode
                          ? AppColors.textPrimaryDark
                          : AppColors.textPrimaryLight,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${category.totalCount} ذكر',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: isDarkMode
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: isDarkMode
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

/// Animated wrapper for category cards with staggered fade + slide animation
class _AnimatedCategoryCard extends StatelessWidget {
  final Animation<double> animation;
  final int index;
  final int totalItems;
  final Widget child;

  const _AnimatedCategoryCard({
    required this.animation,
    required this.index,
    required this.totalItems,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate staggered interval for this item
    final double startInterval = (index / totalItems) * 0.6;
    final double endInterval = startInterval + 0.4;

    final fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animation,
        curve: Interval(
          startInterval.clamp(0.0, 1.0),
          endInterval.clamp(0.0, 1.0),
          curve: Curves.easeOut,
        ),
      ),
    );

    final slideAnimation =
        Tween<Offset>(begin: const Offset(0.3, 0), end: Offset.zero).animate(
          CurvedAnimation(
            parent: animation,
            curve: Interval(
              startInterval.clamp(0.0, 1.0),
              endInterval.clamp(0.0, 1.0),
              curve: Curves.easeOutCubic,
            ),
          ),
        );

    final scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: animation,
        curve: Interval(
          startInterval.clamp(0.0, 1.0),
          endInterval.clamp(0.0, 1.0),
          curve: Curves.easeOutBack,
        ),
      ),
    );

    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        return FadeTransition(
          opacity: fadeAnimation,
          child: SlideTransition(
            position: slideAnimation,
            child: ScaleTransition(scale: scaleAnimation, child: child),
          ),
        );
      },
    );
  }
}
