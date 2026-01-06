import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import '../models/prayer_times_model.dart';
import '../services/prayer_service.dart';

/// GetX controller for Prayer Times and Qibla Compass
class PrayerController extends GetxController {
  static PrayerController get to => Get.find();

  // Prayer times state
  final prayerTimes = Rxn<PrayerTimes>();
  final isLoading = true.obs;
  final error = Rxn<String>();
  final isOffline = false.obs;

  // Qibla state
  final qiblaDirection = Rxn<double>();
  final heading = Rxn<double>();

  // Next prayer countdown
  final nextPrayerName = 'جاري التحميل...'.obs;
  final nextPrayerNameArabic = '---'.obs;
  final timeUntilNextPrayer = Duration.zero.obs;

  // Location
  double? _latitude;
  double? _longitude;

  // Timers and subscriptions
  Timer? _countdownTimer;
  StreamSubscription? _compassSubscription;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  @override
  void onClose() {
    _countdownTimer?.cancel();
    _compassSubscription?.cancel();
    super.onClose();
  }

  /// Main initialization - get location and load data
  Future<void> loadData() async {
    isLoading.value = true;
    error.value = null;

    try {
      // Get location
      final position = await _determinePosition();
      _latitude = position.latitude;
      _longitude = position.longitude;

      // Fetch prayer times
      await _fetchPrayerTimes();

      // Fetch qibla direction
      await _fetchQiblaDirection();

      // Start countdown timer
      _startCountdownTimer();
    } catch (e) {
      error.value = e.toString();

      // Try to load cached data
      _loadCachedData();
    } finally {
      isLoading.value = false;
    }
  }

  /// Refresh data (pull-to-refresh)
  Future<void> refreshData() async {
    if (_latitude == null || _longitude == null) {
      await loadData();
      return;
    }

    error.value = null;
    await _fetchPrayerTimes();
    await _fetchQiblaDirection();
  }

  /// Get current position with permissions
  Future<Position> _determinePosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw 'خدمة الموقع غير مفعلة';
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw 'تم رفض إذن الوصول للموقع';
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw 'إذن الموقع مرفوض بشكل دائم';
    }

    return await Geolocator.getCurrentPosition();
  }

  /// Fetch prayer times from API or cache
  Future<void> _fetchPrayerTimes() async {
    if (_latitude == null || _longitude == null) return;

    final times = await PrayerService.fetchPrayerTimes(_latitude!, _longitude!);

    if (times != null) {
      prayerTimes.value = times;
      isOffline.value = false;
    } else {
      // Network failed - try cache
      _loadCachedData();
    }
  }

  /// Load cached data when offline
  void _loadCachedData() {
    final cachedTimes = PrayerService.getCachedPrayerTimes();
    if (cachedTimes != null) {
      prayerTimes.value = cachedTimes;
      isOffline.value = true;
    } else if (error.value == null) {
      error.value = 'لا يوجد اتصال بالإنترنت ولا توجد بيانات مخزنة';
    }

    final cachedQibla = PrayerService.getCachedQiblaDirection();
    if (cachedQibla != null) {
      qiblaDirection.value = cachedQibla;
    }
  }

  /// Fetch qibla direction
  Future<void> _fetchQiblaDirection() async {
    if (_latitude == null || _longitude == null) return;

    final direction = await PrayerService.fetchQiblaDirection(
      _latitude!,
      _longitude!,
    );
    if (direction != null) {
      qiblaDirection.value = direction;
    } else {
      // Try cache
      final cached = PrayerService.getCachedQiblaDirection();
      if (cached != null) {
        qiblaDirection.value = cached;
      }
    }
  }

  /// Start the countdown timer
  void _startCountdownTimer() {
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _calculateNextPrayer();
    });
    _calculateNextPrayer(); // Calculate immediately
  }

  /// Calculate the next prayer time
  void _calculateNextPrayer() {
    if (prayerTimes.value == null) return;

    final now = DateTime.now();
    final times = prayerTimes.value!;

    String? upcomingPrayerCode;
    DateTime? upcomingPrayerTime;

    for (var prayerCode in PrayerTimes.prayerCodes) {
      final timeStr = times.getTimeForPrayer(prayerCode);
      final parts = timeStr.split(':');
      if (parts.length < 2) continue;

      final prayerDateTime = DateTime(
        now.year,
        now.month,
        now.day,
        int.parse(parts[0]),
        int.parse(parts[1]),
      );

      if (prayerDateTime.isAfter(now)) {
        upcomingPrayerCode = prayerCode;
        upcomingPrayerTime = prayerDateTime;
        break;
      }
    }

    // If all prayers passed, next is Fajr tomorrow
    if (upcomingPrayerCode == null) {
      upcomingPrayerCode = 'Fajr';
      final fajrStr = times.fajr;
      final parts = fajrStr.split(':');
      if (parts.length >= 2) {
        upcomingPrayerTime = DateTime(
          now.year,
          now.month,
          now.day,
          int.parse(parts[0]),
          int.parse(parts[1]),
        ).add(const Duration(days: 1));
      }
    }

    if (upcomingPrayerTime != null) {
      nextPrayerName.value = upcomingPrayerCode;
      nextPrayerNameArabic.value =
          PrayerTimes.arabicNames[upcomingPrayerCode] ?? upcomingPrayerCode;
      timeUntilNextPrayer.value = upcomingPrayerTime.difference(now);
    }
  }

  /// Start listening to compass events
  void startCompass() {
    _compassSubscription?.cancel();
    _compassSubscription = FlutterCompass.events?.listen((event) {
      heading.value = event.heading;
    });
  }

  /// Stop listening to compass events
  void stopCompass() {
    _compassSubscription?.cancel();
    _compassSubscription = null;
  }

  /// Check if qibla is aligned (within 3 degrees)
  bool get isQiblaAligned {
    if (qiblaDirection.value == null || heading.value == null) return false;

    double diff = (qiblaDirection.value! - heading.value!).abs();
    if (diff > 180) diff = 360 - diff;
    return diff < 3;
  }

  /// Trigger haptic feedback when qibla is aligned
  void checkQiblaAlignment() {
    if (isQiblaAligned) {
      HapticFeedback.selectionClick();
    }
  }

  /// Format countdown duration
  String get formattedCountdown {
    final d = timeUntilNextPrayer.value;
    final hours = d.inHours.toString().padLeft(2, '0');
    final minutes = (d.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }
}
