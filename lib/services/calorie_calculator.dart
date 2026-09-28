import '../models/user_model.dart';  // 👈 เพิ่มบรรทัดนี้บรรทัดแรก

class CalorieCalculator {
  // คำนวณ BMR ด้วยสูตร Mifflin-St Jeor
  static double calculateBMR(UserModel user) {
    if (user.gender == 'male') {
      return 10 * user.weight + 6.25 * user.height - 5 * user.age + 5;
    } else {
      return 10 * user.weight + 6.25 * user.height - 5 * user.age - 161;
    }
  }

  // คำนวณ TDEE จาก Activity Level
  static double calculateTDEE(UserModel user) {
    double bmr = calculateBMR(user);
    Map<String, double> multiplier = {
      'low': 1.2,
      'medium': 1.55,
      'high': 1.9,
    };
    return bmr * (multiplier[user.activityLevel] ?? 1.2);
  }

  // ปรับตามเป้าหมาย
  static double getTargetCalories(UserModel user) {
    double tdee = calculateTDEE(user);
    if (user.goal == 'lose') {
      return tdee - 400; // ลดน้ำหนัก
    } else if (user.goal == 'gain') {
      return tdee + 400; // เพิ่มน้ำหนัก
    }
    return tdee; // คงที่
  }

  // แบ่งแคลแต่ละมื้อ (เช้า 30%, กลางวัน 40%, เย็น 30%)
  static Map<String, double> splitMeals(double targetCal) {
    return {
      'breakfast': targetCal * 0.30,
      'lunch': targetCal * 0.40,
      'dinner': targetCal * 0.30,
    };
  }

  // คำนวณสัดส่วนสารอาหาร (Macro)
  static Map<String, double> calculateMacros(double targetCal) {
    return {
      'carb': (targetCal * 0.45) / 4,     // กรัม
      'protein': (targetCal * 0.30) / 4,  // กรัม
      'fat': (targetCal * 0.25) / 9,      // กรัม
    };
  }
}