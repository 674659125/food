import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/food_recommendation.dart';
import '../theme/app_theme.dart';

class FoodDetailScreen extends StatefulWidget {
  final String mealType;
  final String mealTitle;
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
  Map<String, List<bool>> checkedStatus = {};

  @override
  Widget build(BuildContext context) {
    final foods = FoodRecommendation.getFoodsByMealType(widget.mealType);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.blue, AppColors.background],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 0.3],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back,
                          color: AppColors.textDark),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.mealTitle,
                            style: GoogleFonts.nunito(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textDark,
                            ),
                          ),
                          Text(
                            'เป้าหมาย ${widget.targetCalories.toInt()} kcal',
                            style: GoogleFonts.nunito(
                              fontSize: 13,
                              color: AppColors.textLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: foods.length,
                  itemBuilder: (context, index) {
                    final food = foods[index];
                    checkedStatus[food.name] ??=
                        List.generate(food.ingredients.length, (_) => false);

                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.pinkDark.withValues(alpha: 0.15),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          dividerColor: Colors.transparent,
                        ),
                        child: ExpansionTile(
                          tilePadding:
                          const EdgeInsets.symmetric(horizontal: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          title: Text(
                            food.name,
                            style: GoogleFonts.nunito(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: AppColors.textDark,
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Wrap(
                              spacing: 8,
                              children: [
                                _macroBadge(
                                    '${food.calories.toInt()} kcal',
                                    AppColors.pinkDark),
                                _macroBadge(
                                    'P ${food.protein.toInt()}g',
                                    AppColors.blueDark),
                                _macroBadge(
                                    'C ${food.carb.toInt()}g',
                                    AppColors.lavender),
                                _macroBadge(
                                    'F ${food.fat.toInt()}g',
                                    Colors.orange.shade200),
                              ],
                            ),
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '🧺 วัตถุดิบ',
                                    style: GoogleFonts.nunito(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textDark,
                                    ),
                                  ),
                                  ...List.generate(food.ingredients.length,
                                          (i) {
                                        return CheckboxListTile(
                                          dense: true,
                                          contentPadding: EdgeInsets.zero,
                                          activeColor: AppColors.pinkDark,
                                          title: Text(
                                            food.ingredients[i],
                                            style: GoogleFonts.nunito(fontSize: 14),
                                          ),
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
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _macroBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: GoogleFonts.nunito(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
