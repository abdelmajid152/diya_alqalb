/// API endpoints for mp3quran.net Quran audio services
class ApiEndpoints {
  // Base URL for mp3quran.net API
  static const String baseUrl = 'https://mp3quran.net/api/v3';

  // Reciters list endpoint
  static const String reciters = '$baseUrl/reciters';

  // Tafsir (Al-Tabari explanation) endpoint
  static const String tafsir = '$baseUrl/tafsir';

  // Suwar (chapters) list endpoint
  static const String suwar = '$baseUrl/suwar';
}
