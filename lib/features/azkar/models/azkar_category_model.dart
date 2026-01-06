import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'thikr_model.dart';

class AzkarCategory {
  final String name;
  final List<Thikr> athkar;

  AzkarCategory({required this.name, required this.athkar});

  factory AzkarCategory.fromJson(String categoryName, List<dynamic> jsonList) {
    return AzkarCategory(
      name: categoryName,
      athkar: jsonList.map((json) => Thikr.fromJson(json)).toList(),
    );
  }

  // Get total count of athkar
  int get totalCount => athkar.length;

  // Get icon based on category name using FlutterIslamicIcons
  IconData get icon {
    if (name.contains('الصباح')) return FlutterIslamicIcons.solidLantern;
    if (name.contains('المساء')) return FlutterIslamicIcons.solidCrescentMoon;
    if (name.contains('الصلاة')) return FlutterIslamicIcons.solidMosque;
    if (name.contains('الاستيقاظ')) return FlutterIslamicIcons.lantern;
    if (name.contains('النوم')) return FlutterIslamicIcons.crescentMoon;

    if (name.contains('تسابيح')) return FlutterIslamicIcons.solidPrayer;
    if (name.contains('قرآنية')) return FlutterIslamicIcons.solidQuran;
    if (name.contains('الأنبياء')) return FlutterIslamicIcons.solidKaaba;
    if (name.contains('الوضوء')) return FlutterIslamicIcons.wudhu;
    if (name.contains('الثوب')) return FlutterIslamicIcons.muslim;
    if (name.contains('الخلاء') || name.contains('الحمام')) {
      return Icons.bathroom_outlined;
    }
    if (name.contains('المسجد') || name.contains('مسجد')) {
      return FlutterIslamicIcons.solidMosque;
    }
    if (name.contains('الآذان')) return FlutterIslamicIcons.solidMinaret;
    if (name.contains('السوق')) return FlutterIslamicIcons.solidFamily;
    if (name.contains('المنزل') || name.contains('البيت')) {
      return Icons.house_outlined;
    }
    if (name.contains('السفر')) return FlutterIslamicIcons.solidKaaba;
    if (name.contains('الطعام') || name.contains('الأكل')) {
      return FlutterIslamicIcons.solidIftar;
    }
    if (name.contains('ركوع')) return FlutterIslamicIcons.solidPrayer;
    if (name.contains('الاستفتاح')) return FlutterIslamicIcons.takbir;
    if (name.contains('السجود')) return FlutterIslamicIcons.kowtow;
    if (name.contains('تلاوة')) return FlutterIslamicIcons.kowtow;
    if (name.contains('الاستخارة')) return FlutterIslamicIcons.takbir;
    if (name.contains('دعاء')) return FlutterIslamicIcons.solidPrayingPerson;
    if (name.contains('تشهد')) return FlutterIslamicIcons.solidPrayingPerson;
    if (name.contains('ذكر')) return FlutterIslamicIcons.solidPrayer;
    return FlutterIslamicIcons.islam;
  }
}
