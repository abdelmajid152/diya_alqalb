/// Nawawi hadith model class
class Nawawi {
  final String title;
  final String hadith;
  final String description;

  Nawawi({
    required this.title,
    required this.hadith,
    required this.description,
  });

  factory Nawawi.fromJson(Map<String, dynamic> json) {
    return Nawawi(
      title: json['title'] ?? '',
      hadith: json['hadith'] ?? '',
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'title': title, 'hadith': hadith, 'description': description};
  }
}
