import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/user_model.dart';
import '../services/calorie_calculator.dart';
import '../theme/app_theme.dart';
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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.pink, AppColors.blue],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 0.35],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 10),
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back,
                          color: AppColors.textDark),
                    ),
                    Text(
                      'สรุปแคลอรี่',
                      style: GoogleFonts.nunito(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                _buildCalorieCard(target),
                const SizedBox(height: 20),
                _buildMacroChart(macros),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '🍽️ มื้ออาหารของวันนี้',
                        style: GoogleFonts.nunito(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildMealCard(
                        context,
                        title: 'เช้า',
                        emoji: '🌅',
                        cal: meals['breakfast']!,
                        mealType: 'breakfast',
                        color: AppColors.pinkDark,
                      ),
                      _buildMealCard(
                        context,
                        title: 'กลางวัน',
                        emoji: '☀️',
                        cal: meals['lunch']!,
                        mealType: 'lunch',
                        color: AppColors.blueDark,
                      ),
                      _buildMealCard(
                        context,
                        title: 'เย็น',
                        emoji: '🌙',
                        cal: meals['dinner']!,
                        mealType: 'dinner',
                        color: AppColors.lavender,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCalorieCard(double target) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30),
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.pinkDark.withValues(alpha: 0.2),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            '🔥 เป้าหมายพลังงาน',
            style: GoogleFonts.nunito(
              fontSize: 14,
              color: AppColors.textLight,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${target.toInt()}',
            style: GoogleFonts.nunito(
              fontSize: 42,
              fontWeight: FontWeight.bold,
              color: AppColors.pinkDark,
            ),
          ),
          Text(
            'kcal / วัน',
            style: GoogleFonts.nunito(
              fontSize: 14,
              color: AppColors.textLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMacroChart(Map<String, double> macros) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.blueDark.withValues(alpha: 0.15),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            '📊 สัดส่วนสารอาหาร',
            style: GoogleFonts.nunito(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 180,
            child: PieChart(
              PieChartData(
                sectionsSpace: 3,
                centerSpaceRadius: 45,
                sections: [
                  PieChartSectionData(
                    value: macros['carb'],
                    color: AppColors.blueDark,
                    title: 'คาร์บ',
                    radius: 55,
                    titleStyle: GoogleFonts.nunito(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  PieChartSectionData(
                    value: macros['protein'],
                    color: AppColors.pinkDark,
                    title: 'โปรตีน',
                    radius: 55,
                    titleStyle: GoogleFonts.nunito(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  PieChartSectionData(
                    value: macros['fat'],
                    color: AppColors.lavender,
                    title: 'ไขมัน',
                    radius: 55,
                    titleStyle: GoogleFonts.nunito(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _legendDot(AppColors.blueDark, 'คาร์บ'),
              _legendDot(AppColors.pinkDark, 'โปรตีน'),
              _legendDot(AppColors.lavender, 'ไขมัน'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _legendDot(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(label, style: GoogleFonts.nunito(fontSize: 12)),
      ],
    );
  }

  Widget _buildMealCard(
      BuildContext context, {
        required String title,
        required String emoji,
        required double cal,
        required String mealType,
        required Color color,
      }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.2),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
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
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Text(emoji, style: const TextStyle(fontSize: 24)),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.nunito(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${cal.toInt()} kcal',
                        style: GoogleFonts.nunito(
                          fontSize: 13,
                          color: AppColors.textLight,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios, size: 16, color: color),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
