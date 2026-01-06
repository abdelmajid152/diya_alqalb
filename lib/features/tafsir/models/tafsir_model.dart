/// Model for Tafsir (Al-Tabari explanation) audio data
class TafsirModel {
  final int id;
  final int suraId;
  final int tafsirId;
  final String url;
  final String name;

  TafsirModel({
    required this.id,
    required this.suraId,
    required this.tafsirId,
    required this.url,
    required this.name,
  });

  factory TafsirModel.fromJson(Map<String, dynamic> json) {
    return TafsirModel(
      id: json['id'] ?? 0,
      suraId: json['sura_id'] ?? 0,
      tafsirId: json['tafsir_id'] ?? 0,
      url: json['url'] ?? '',
      name: json['name'] ?? '',
    );
  }
}
