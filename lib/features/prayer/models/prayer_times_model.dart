/// Prayer times model for storing prayer schedule data
class PrayerTimes {
  final String fajr;
  final String sunrise;
  final String dhuhr;
  final String asr;
  final String maghrib;
  final String isha;
  final DateTime date;
  final bool isFromCache;

  PrayerTimes({
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
    required this.date,
    this.isFromCache = false,
  });

  factory PrayerTimes.fromJson(Map<String, dynamic> json) {
    final timings = json['timings'] ?? json;
    return PrayerTimes(
      fajr: _cleanTime(timings['Fajr'] ?? ''),
      sunrise: _cleanTime(timings['Sunrise'] ?? ''),
      dhuhr: _cleanTime(timings['Dhuhr'] ?? ''),
      asr: _cleanTime(timings['Asr'] ?? ''),
      maghrib: _cleanTime(timings['Maghrib'] ?? ''),
      isha: _cleanTime(timings['Isha'] ?? ''),
      date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
      isFromCache: json['isFromCache'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'timings': {
        'Fajr': fajr,
        'Sunrise': sunrise,
        'Dhuhr': dhuhr,
        'Asr': asr,
        'Maghrib': maghrib,
        'Isha': isha,
      },
      'date': date.toIso8601String(),
      'isFromCache': isFromCache,
    };
  }

  /// Creates a cached version of this prayer times
  PrayerTimes asCached() {
    return PrayerTimes(
      fajr: fajr,
      sunrise: sunrise,
      dhuhr: dhuhr,
      asr: asr,
      maghrib: maghrib,
      isha: isha,
      date: date,
      isFromCache: true,
    );
  }

  /// Remove timezone info from time string (e.g., "05:30 (EET)" -> "05:30")
  static String _cleanTime(String time) {
    return time.split(' ').first;
  }

  /// Get time for a specific prayer by name
  String getTimeForPrayer(String prayerName) {
    switch (prayerName) {
      case 'Fajr':
        return fajr;
      case 'Sunrise':
        return sunrise;
      case 'Dhuhr':
        return dhuhr;
      case 'Asr':
        return asr;
      case 'Maghrib':
        return maghrib;
      case 'Isha':
        return isha;
      default:
        return '';
    }
  }

  /// Prayer names in order
  static const List<String> prayerCodes = [
    'Fajr',
    'Sunrise',
    'Dhuhr',
    'Asr',
    'Maghrib',
    'Isha',
  ];

  /// Arabic prayer names
  static const Map<String, String> arabicNames = {
    'Fajr': 'الفجر',
    'Sunrise': 'الشروق',
    'Dhuhr': 'الظهر',
    'Asr': 'العصر',
    'Maghrib': 'المغرب',
    'Isha': 'العشاء',
  };
}
