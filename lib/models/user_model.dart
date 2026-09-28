class UserModel {
  String gender; // 'male' or 'female'
  int age;
  double height; // cm
  double weight; // kg
  String goal;   // 'lose' or 'gain'
  String activityLevel; // 'low', 'medium', 'high'

  UserModel({
    required this.gender,
    required this.age,
    required this.height,
    required this.weight,
    required this.goal,
    required this.activityLevel,
  });
}