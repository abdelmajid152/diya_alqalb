import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants/app_colors.dart';
import '../theme/theme_controller.dart';

/// Audio player control buttons (previous, play/pause, next)
class PlayerControls extends StatelessWidget {
  final VoidCallback onPrevious;
  final VoidCallback onPlayPause;
  final VoidCallback onNext;
  final bool isPlaying;

  const PlayerControls({
    super.key,
    required this.onPrevious,
    required this.onPlayPause,
    required this.onNext,
    required this.isPlaying,
  });

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final primaryColor = themeController.isDarkMode
        ? AppColors.primaryDark
        : AppColors.primaryLight;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Previous button
        IconButton(
          onPressed: onPrevious,
          icon: Icon(
            Icons.skip_previous_rounded,
            size: 40,
            color: primaryColor,
          ),
        ),
        const SizedBox(width: 16),
        // Play/Pause button
        Container(
          decoration: BoxDecoration(
            color: primaryColor,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            onPressed: onPlayPause,
            icon: Icon(
              isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
              size: 40,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(width: 16),
        // Next button
        IconButton(
          onPressed: onNext,
          icon: Icon(Icons.skip_next_rounded, size: 40, color: primaryColor),
        ),
      ],
    );
  }
}

/// Speed control button widget
class SpeedControlButton extends StatelessWidget {
  final double speed;
  final VoidCallback onTap;

  const SpeedControlButton({
    super.key,
    required this.speed,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final primaryColor = themeController.isDarkMode
        ? AppColors.primaryDark
        : AppColors.primaryLight;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: primaryColor.withAlpha(26),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: primaryColor.withAlpha(51)),
        ),
        child: Text(
          '${speed}x',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
        ),
      ),
    );
  }
}

/// Repeat mode enum (import from controller or define here)
enum RepeatModeUI { off, one, all }

/// Repeat mode button widget
class RepeatModeButton extends StatelessWidget {
  final RepeatModeUI repeatMode;
  final VoidCallback onTap;

  const RepeatModeButton({
    super.key,
    required this.repeatMode,
    required this.onTap,
  });

  IconData get _icon {
    switch (repeatMode) {
      case RepeatModeUI.off:
        return Icons.repeat;
      case RepeatModeUI.one:
        return Icons.repeat_one;
      case RepeatModeUI.all:
        return Icons.repeat_on;
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final primaryColor = themeController.isDarkMode
        ? AppColors.primaryDark
        : AppColors.primaryLight;
    final isActive = repeatMode != RepeatModeUI.off;

    return IconButton(
      onPressed: onTap,
      icon: Icon(
        _icon,
        size: 28,
        color: isActive ? primaryColor : primaryColor.withAlpha(102),
      ),
    );
  }
}

/// Extended player controls with speed and repeat
class ExtendedPlayerControls extends StatelessWidget {
  final VoidCallback onPrevious;
  final VoidCallback onPlayPause;
  final VoidCallback onNext;
  final bool isPlaying;
  final double speed;
  final VoidCallback onSpeedTap;
  final RepeatModeUI repeatMode;
  final VoidCallback onRepeatTap;

  const ExtendedPlayerControls({
    super.key,
    required this.onPrevious,
    required this.onPlayPause,
    required this.onNext,
    required this.isPlaying,
    required this.speed,
    required this.onSpeedTap,
    required this.repeatMode,
    required this.onRepeatTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Main controls
        PlayerControls(
          onPrevious: onPrevious,
          onPlayPause: onPlayPause,
          onNext: onNext,
          isPlaying: isPlaying,
        ),
        const SizedBox(height: 16),
        // Speed and repeat controls
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SpeedControlButton(speed: speed, onTap: onSpeedTap),
            const SizedBox(width: 24),
            RepeatModeButton(repeatMode: repeatMode, onTap: onRepeatTap),
          ],
        ),
      ],
    );
  }
}

/// Seek bar with duration and position labels
class AudioSeekBar extends StatelessWidget {
  final Duration position;
  final Duration duration;
  final Function(double) onSeek;

  const AudioSeekBar({
    super.key,
    required this.position,
    required this.duration,
    required this.onSeek,
  });

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final primaryColor = themeController.isDarkMode
        ? AppColors.primaryDark
        : AppColors.primaryLight;
    final textColor = themeController.isDarkMode
        ? AppColors.textSecondaryDark
        : AppColors.textSecondaryLight;

    final maxValue = duration.inSeconds.toDouble();
    final currentValue = position.inSeconds.toDouble().clamp(0.0, maxValue);

    return Column(
      children: [
        Slider(
          value: currentValue,
          max: maxValue > 0 ? maxValue : 1.0,
          onChanged: onSeek,
          activeColor: primaryColor,
          inactiveColor: primaryColor.withAlpha(51),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatDuration(position),
                style: TextStyle(fontSize: 12, color: textColor),
              ),
              Text(
                _formatDuration(duration),
                style: TextStyle(fontSize: 12, color: textColor),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Displays surah/reciter info in player screen
class AudioInfoDisplay extends StatelessWidget {
  final String title;
  final String subtitle;

  const AudioInfoDisplay({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            fontFamily: 'UthmanicHafs',
            color: themeController.isDarkMode
                ? AppColors.textPrimaryDark
                : AppColors.textPrimaryLight,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 16,
            color: themeController.isDarkMode
                ? AppColors.textSecondaryDark
                : AppColors.textSecondaryLight,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
