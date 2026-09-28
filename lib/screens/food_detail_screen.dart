import 'package:flutter/material.dart';
import '../models/food_model.dart';
import '../services/food_recommendation.dart';

class FoodDetailScreen extends StatefulWidget {
  final String mealType; // 'breakfast', 'lunch', 'dinner'
  final String mealTitle; // 'มื้อเช้า', 'มื้อกลางวัน', 'มื้อเย็น'
  final double targetCalories;

  const FoodDetailScreen({
    super.key,
    required this.mealType,
    required this.mealTitle,
    required this.targetCalories,
  });

  @override
  State<FoodDetailScreen> createState() => _FoodDetailScreenState();
}

class _FoodDetailScreenState extends State<FoodDetailScreen> {
  // เก็บสถานะเช็คลิสต์วัตถุดิบ (key: ชื่ออาหาร, value: list of bool)
  Map<String, List<bool>> checkedStatus = {};

  @override
  Widget build(BuildContext context) {
    List<FoodModel> foods =
    FoodRecommendation.getFoodsByMealType(widget.mealType);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.mealTitle),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'เป้าหมาย: ${widget.targetCalories.toStringAsFixed(0)} kcal',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'เลือกเมนูที่ต้องการ 👇',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: foods.length,
                itemBuilder: (context, index) {
                  final food = foods[index];
                  // สร้าง checklist state ถ้ายังไม่มี
                  checkedStatus[food.name] ??=
                      List.generate(food.ingredients.length, (_) => false);

                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    elevation: 3,
                    child: ExpansionTile(
                      title: Text(
                        food.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        '${food.calories.toStringAsFixed(0)} kcal  |  '
                            'P: ${food.protein.toStringAsFixed(0)}g  '
                            'C: ${food.carb.toStringAsFixed(0)}g  '
                            'F: ${food.fat.toStringAsFixed(0)}g',
                        style: const TextStyle(fontSize: 12),
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'วัตถุดิบ:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              ...List.generate(food.ingredients.length,
                                      (i) {
                                    return CheckboxListTile(
                                      dense: true,
                                      contentPadding: EdgeInsets.zero,
                                      title: Text(food.ingredients[i]),
                                      value: checkedStatus[food.name]![i],
                                      onChanged: (val) {
                                        setState(() {
                                          checkedStatus[food.name]![i] =
                                              val ?? false;
                                        });
                                      },
                                    );
                                  }),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}