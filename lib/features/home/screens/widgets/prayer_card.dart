import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/theme_controller.dart';



class PrayerCard extends GetView<ThemeController> {
  const PrayerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(

      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: controller.isDarkMode? AppColors.primaryDark : AppColors.primaryLight, // اللون الأخضر الأساسي
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // التاريخ - سيظهر في اليمين تلقائياً لأن الاتجاه RTL
          const Align(
            alignment: AlignmentDirectional.topStart,
            child: Text(
              "14 رجب، 1447 هـ",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),

          const SizedBox(height: 10),

          // الصف الأوسط (الصورة والمعلومات)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // معلومات الصلاة (ستظهر في اليمين بسبب RTL)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start, // يبدأ من اليمين في RTL
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text(
                        "الفجر",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.nights_stay, color: Colors.white, size: 24),
                    ],
                  ),
                  const Text(
                    "5:18",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 60,
                      fontWeight: FontWeight.bold,
                      height: 1.0,
                    ),
                  ),
                  const Text(
                    "موعد الصلاة القادمة 15 : 08 : 14",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),

              // الجهة اليسرى: صورة المصلي (ستنتقل لليسار تلقائياً في RTL)
              const Icon(
                  Icons.person_pin,
                  size: 110,
                  color: Colors.white70
              ),
            ],
          ),

          const SizedBox(height: 15),
          const Divider(color: Colors.white38, thickness: 1),
          const SizedBox(height: 10),

          // السطر السفلي
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // النص السفلي (يمين)
              const Text(
                "إضغط لعرض المزيد من أوقات الصلاة",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
              // زر السهم (يسار)
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white38),
                ),
                child: const Icon(
                  Icons.arrow_back, // سيتم قلبه تلقائياً في RTL ليشير لليسار
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}