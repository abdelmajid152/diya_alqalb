import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

/// Repeat mode enum
enum RepeatMode { off, one, all }

/// Controller for Tafsir audio player screen
class TafsirPlayerController extends GetxController {
  // Audio player instance
  final AudioPlayer _audioPlayer = AudioPlayer();

  // Playback state
  final isPlaying = false.obs;
  final position = Duration.zero.obs;
  final duration = Duration.zero.obs;

  // Speed control (0.5x, 0.75x, 1x, 1.25x, 1.5x, 2x)
  final playbackSpeed = 1.0.obs;
  static const List<double> speedOptions = [0.5, 0.75, 1.0, 1.25, 1.5, 2.0];

  // Repeat mode
  final repeatMode = RepeatMode.off.obs;

  // Current track info
  final currentIndex = 0.obs;
  final tafsirList = <Map<String, dynamic>>[].obs;
  final allUrls = <String>[].obs;

  // Current surah display
  String get currentName =>
      tafsirList.isNotEmpty ? tafsirList[currentIndex.value]['name'] ?? '' : '';
  int get currentSuraId => tafsirList.isNotEmpty
      ? tafsirList[currentIndex.value]['sura_id'] ?? 0
      : 0;
  String get currentUrl =>
      tafsirList.isNotEmpty ? tafsirList[currentIndex.value]['url'] ?? '' : '';

  @override
  void onInit() {
    super.onInit();
    _initFromArguments();
    _setupAudioListeners();
    // Enable background playback
    _audioPlayer.setReleaseMode(ReleaseMode.stop);
  }

  void _initFromArguments() {
    final args = Get.arguments as Map<String, dynamic>;
    currentIndex.value = args['index'] ?? 0;
    tafsirList.value = List<Map<String, dynamic>>.from(
      args['tafsirList'] ?? [],
    );
    allUrls.value = List<String>.from(args['allUrls'] ?? []);

    // Start playing
    _playCurrentTrack();
  }

  void _setupAudioListeners() {
    // Duration changes
    _audioPlayer.onDurationChanged.listen((d) {
      duration.value = d;
    });

    // Position changes
    _audioPlayer.onPositionChanged.listen((p) {
      position.value = p;
    });

    // Track completed
    _audioPlayer.onPlayerComplete.listen((_) {
      _handleTrackComplete();
    });
  }

  void _handleTrackComplete() {
    switch (repeatMode.value) {
      case RepeatMode.one:
        // Repeat current track
        position.value = Duration.zero;
        _playCurrentTrack();
        break;
      case RepeatMode.all:
        // Go to next, loop to beginning if at end
        if (currentIndex.value < tafsirList.length - 1) {
          currentIndex.value++;
        } else {
          currentIndex.value = 0;
        }
        position.value = Duration.zero;
        _playCurrentTrack();
        break;
      case RepeatMode.off:
        nextTrack();
        break;
    }
  }

  Future<void> _playCurrentTrack() async {
    if (currentUrl.isEmpty) return;

    try {
      await _audioPlayer.play(UrlSource(currentUrl));
      await _audioPlayer.setPlaybackRate(playbackSpeed.value);
      isPlaying.value = true;
    } catch (e) {
      debugPrint('Error playing audio: $e');
    }
  }

  /// Toggle play/pause
  void togglePlayPause() async {
    if (isPlaying.value) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.resume();
    }
    isPlaying.value = !isPlaying.value;
  }

  /// Set playback speed
  void setSpeed(double speed) async {
    playbackSpeed.value = speed;
    await _audioPlayer.setPlaybackRate(speed);
  }

  /// Cycle through speed options
  void cycleSpeed() {
    final currentIdx = speedOptions.indexOf(playbackSpeed.value);
    final nextIdx = (currentIdx + 1) % speedOptions.length;
    setSpeed(speedOptions[nextIdx]);
  }

  /// Toggle repeat mode
  void toggleRepeatMode() {
    switch (repeatMode.value) {
      case RepeatMode.off:
        repeatMode.value = RepeatMode.all;
        break;
      case RepeatMode.all:
        repeatMode.value = RepeatMode.one;
        break;
      case RepeatMode.one:
        repeatMode.value = RepeatMode.off;
        break;
    }
  }

  /// Play next track
  void nextTrack() {
    if (currentIndex.value < tafsirList.length - 1) {
      currentIndex.value++;
      position.value = Duration.zero;
      _playCurrentTrack();
    } else if (repeatMode.value == RepeatMode.all) {
      currentIndex.value = 0;
      position.value = Duration.zero;
      _playCurrentTrack();
    } else {
      // End of playlist
      isPlaying.value = false;
      Get.back();
    }
  }

  /// Play previous track
  void previousTrack() {
    if (currentIndex.value > 0) {
      currentIndex.value--;
      position.value = Duration.zero;
      _playCurrentTrack();
    }
  }

  /// Seek to position
  void seekTo(double seconds) {
    _audioPlayer.seek(Duration(seconds: seconds.toInt()));
  }

  /// Go back to tafsir list
  void goBack() {
    Get.back();
  }

  @override
  void onClose() {
    _audioPlayer.stop();
    _audioPlayer.dispose();
    super.onClose();
  }
}
