import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../models/prayer_times_model.dart';

/// Service for fetching prayer times and qibla direction from API
class PrayerService {
  static const String _prayerCacheKey = 'cached_prayer_times';
  static const String _qiblaCacheKey = 'cached_qibla_direction';
  static const String _baseUrl = 'https://api.aladhan.com/v1';

  static final _storage = GetStorage();

  /// Fetch prayer times from API
  /// Returns null if network request fails
  static Future<PrayerTimes?> fetchPrayerTimes(double lat, double long) async {
    try {
      final String date = DateFormat('dd-MM-yyyy').format(DateTime.now());
      // method=8 (Umm Al-Qura)
      final url =
          '$_baseUrl/timings/$date?latitude=$lat&longitude=$long&method=8';

      final response = await http
          .get(Uri.parse(url))
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () => throw Exception('انتهت مهلة الاتصال'),
          );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final prayerTimes = PrayerTimes.fromJson({
          'timings': data['data']['timings'],
          'date': DateTime.now().toIso8601String(),
        });

        // Cache the data
        await savePrayerTimesToCache(prayerTimes);

        return prayerTimes;
      } else {
        throw Exception('فشل في جلب المواقيت');
      }
    } catch (e) {
      // Return null on error - caller should check cache
      return null;
    }
  }

  /// Fetch qibla direction from API
  /// Returns null if network request fails
  static Future<double?> fetchQiblaDirection(double lat, double long) async {
    try {
      final url = '$_baseUrl/qibla/$lat/$long';
      final response = await http
          .get(Uri.parse(url))
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () => throw Exception('انتهت مهلة الاتصال'),
          );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final direction = (data['data']['direction'] as num).toDouble();

        // Cache the qibla direction
        await saveQiblaToCache(direction);

        return direction;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Save prayer times to local storage
  static Future<void> savePrayerTimesToCache(PrayerTimes prayerTimes) async {
    await _storage.write(_prayerCacheKey, prayerTimes.toJson());
  }

  /// Get cached prayer times from local storage
  static PrayerTimes? getCachedPrayerTimes() {
    final cached = _storage.read(_prayerCacheKey);
    if (cached != null) {
      return PrayerTimes.fromJson(cached).asCached();
    }
    return null;
  }

  /// Save qibla direction to local storage
  static Future<void> saveQiblaToCache(double direction) async {
    await _storage.write(_qiblaCacheKey, direction);
  }

  /// Get cached qibla direction from local storage
  static double? getCachedQiblaDirection() {
    return _storage.read<double>(_qiblaCacheKey);
  }

  /// Check if we have cached data
  static bool hasCachedData() {
    return _storage.hasData(_prayerCacheKey);
  }
}
