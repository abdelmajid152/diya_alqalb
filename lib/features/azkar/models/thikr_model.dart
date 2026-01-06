class Thikr {
  final String category;
  final String count;
  final String description;
  final String reference;
  final String content;

  Thikr({
    required this.category,
    required this.count,
    required this.description,
    required this.reference,
    required this.content,
  });

  factory Thikr.fromJson(Map<String, dynamic> json) {
    return Thikr(
      category: json['category'] ?? '',
      count: json['count'] ?? '1',
      description: json['description'] ?? '',
      reference: json['reference'] ?? '',
      content: json['content'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'count': count,
      'description': description,
      'reference': reference,
      'content': content,
    };
  }

  // Get count as integer
  int get countAsInt {
    try {
      // Remove leading zeros
      String cleanCount = count.replaceFirst(RegExp(r'^0+'), '');
      if (cleanCount.isEmpty) cleanCount = '1';
      return int.parse(cleanCount);
    } catch (e) {
      return 1;
    }
  }
}
