import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/user_model.dart';
import '../services/calorie_calculator.dart';
import 'food_detail_screen.dart';

class ResultScreen extends StatelessWidget {
  final UserModel user;
  const ResultScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    double target = CalorieCalculator.getTargetCalories(user);
    Map<String, double> macros = CalorieCalculator.calculateMacros(target);
    Map<String, double> meals = CalorieCalculator.splitMeals(target);

    return Scaffold(
      appBar: AppBar(title: const Text('สรุปแคลอรี่')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16),
            Text('${target.toInt()} kcal/วัน',
                style: const TextStyle(
                    fontSize: 28, fontWeight: FontWeight.bold)),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(
                      value: macros['carb'],
                      color: Colors.orange,
                      title: 'คาร์บ',
                    ),
                    PieChartSectionData(
                      value: macros['protein'],
                      color: Colors.red,
                      title: 'โปรตีน',
                    ),
                    PieChartSectionData(
                      value: macros['fat'],
                      color: Colors.yellow,
                      title: 'ไขมัน',
                    ),
                  ],
                ),
              ),
            ),
            _buildMealCard(
              context,
              title: 'เช้า',
              cal: meals['breakfast']!,
              mealType: 'breakfast',
            ),
            _buildMealCard(
              context,
              title: 'กลางวัน',
              cal: meals['lunch']!,
              mealType: 'lunch',
            ),
            _buildMealCard(
              context,
              title: 'เย็น',
              cal: meals['dinner']!,
              mealType: 'dinner',
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildMealCard(
      BuildContext context, {
        required String title,
        required double cal,
        required String mealType,
      }) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('${cal.toInt()} kcal'),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FoodDetailScreen(
                mealType: mealType,
                mealTitle: 'มื้อ$title',
                targetCalories: cal,
              ),
            ),
          );
        },
      ),
    );
  }
}