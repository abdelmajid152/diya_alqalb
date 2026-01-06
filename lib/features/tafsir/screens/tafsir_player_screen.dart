import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/audio_player_widgets.dart';
import '../../../core/theme/theme_controller.dart';
import '../controllers/tafsir_player_controller.dart';

/// Helper to map controller RepeatMode to UI RepeatMode
RepeatModeUI _mapRepeatMode(RepeatMode mode) {
  switch (mode) {
    case RepeatMode.off:
      return RepeatModeUI.off;
    case RepeatMode.one:
      return RepeatModeUI.one;
    case RepeatMode.all:
      return RepeatModeUI.all;
  }
}

/// Audio player screen for Tafsir
class TafsirPlayerScreen extends StatelessWidget {
  const TafsirPlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TafsirPlayerController());
    final themeController = Get.find<ThemeController>();
    final isDark = themeController.isDarkMode;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.backgroundDark
          : AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text(
          'تفسير الطبري',
          style: TextStyle(fontFamily: 'UthmanicHafs', fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: isDark
            ? AppColors.surfaceDark
            : AppColors.surfaceLight,
        foregroundColor: isDark
            ? AppColors.textPrimaryDark
            : AppColors.textPrimaryLight,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: controller.goBack,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Quran icon
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color:
                      (isDark ? AppColors.primaryDark : AppColors.primaryLight)
                          .withAlpha(26),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  FlutterIslamicIcons.quran2,
                  size: 80,
                  color: isDark
                      ? AppColors.primaryDark
                      : AppColors.primaryLight,
                ),
              ),
              const SizedBox(height: 40),

              // Surah info
              Obx(
                () => AudioInfoDisplay(
                  title: ' ${controller.currentName}',
                  subtitle: 'رقم السورة: ${controller.currentSuraId}',
                ),
              ),
              const SizedBox(height: 40),

              // Seek bar
              Obx(
                () => AudioSeekBar(
                  position: controller.position.value,
                  duration: controller.duration.value,
                  onSeek: controller.seekTo,
                ),
              ),
              const SizedBox(height: 24),

              // Player controls with speed and repeat
              Obx(
                () => ExtendedPlayerControls(
                  isPlaying: controller.isPlaying.value,
                  onPlayPause: controller.togglePlayPause,
                  onPrevious: controller.previousTrack,
                  onNext: controller.nextTrack,
                  speed: controller.playbackSpeed.value,
                  onSpeedTap: controller.cycleSpeed,
                  repeatMode: _mapRepeatMode(controller.repeatMode.value),
                  onRepeatTap: controller.toggleRepeatMode,
                ),
              ),
              const SizedBox(height: 24),

              // Track counter
              Obx(
                () => Text(
                  '${controller.currentIndex.value + 1} / ${controller.tafsirList.length}',
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
