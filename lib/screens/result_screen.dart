import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/user_model.dart';
import '../services/calorie_calculator.dart';

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
            Text('${target.toInt()} kcal/วัน',
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
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
            _buildMealCard('เช้า', meals['breakfast']!),
            _buildMealCard('กลางวัน', meals['lunch']!),
            _buildMealCard('เย็น', meals['dinner']!),
          ],
        ),
      ),
    );
  }

  Widget _buildMealCard(String title, double cal) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: ListTile(
        title: Text(title),
        subtitle: Text('${cal.toInt()} kcal'),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          // TODO: Navigate to FoodDetailScreen
        },
      ),
    );
  }
}