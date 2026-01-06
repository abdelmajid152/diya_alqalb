import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/azkar_controller.dart';
import '../models/azkar_category_model.dart';
import '../widgets/thikr_card.dart';

/// Category detail screen showing all athkar in a category
class CategoryDetailScreen extends GetView<AzkarController> {
  final AzkarCategory category;

  const CategoryDetailScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category.name),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Get.back(),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: category.athkar.length,
        itemBuilder: (context, index) {
          final thikr = category.athkar[index];
          return ZekrCard(
            azkar: thikr,
            categoryName: category.name,
            index: index,
          );
        },
      ),
    );
  }
}
