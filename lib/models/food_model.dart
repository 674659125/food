class FoodModel {
  final String name;
  final double calories;
  final double protein;
  final double carb;
  final double fat;
  final List<String> ingredients;
  final String imageUrl;

  FoodModel({
    required this.name,
    required this.calories,
    required this.protein,
    required this.carb,
    required this.fat,
    required this.ingredients,
    this.imageUrl = '',
  });
}