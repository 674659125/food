import '../models/food_model.dart';

class FoodRecommendation {
  // เมนูอาหารเช้า
  static List<FoodModel> breakfastFoods = [
    FoodModel(
      name: 'ข้าวต้มไก่',
      calories: 350,
      protein: 25,
      carb: 45,
      fat: 8,
      ingredients: ['ข้าวสวย 1 ถ้วย', 'อกไก่ต้ม 100g', 'ขิงซอย', 'ต้นหอม'],
    ),
    FoodModel(
      name: 'ไข่ต้ม + ขนมปังโฮลวีท',
      calories: 300,
      protein: 18,
      carb: 30,
      fat: 10,
      ingredients: ['ไข่ไก่ 2 ฟอง', 'ขนมปังโฮลวีท 2 แผ่น', 'อะโวคาโด'],
    ),
    FoodModel(
      name: 'โยเกิร์ต + ผลไม้ + กราโนล่า',
      calories: 320,
      protein: 15,
      carb: 40,
      fat: 9,
      ingredients: ['โยเกิร์ตกรีก 1 ถ้วย', 'กล้วย 1 ลูก', 'กราโนล่า 30g'],
    ),
  ];

  // เมนูอาหารกลางวัน
  static List<FoodModel> lunchFoods = [
    FoodModel(
      name: 'ข้าวกล้อง + อกไก่ย่าง + ผัดผัก',
      calories: 550,
      protein: 40,
      carb: 60,
      fat: 12,
      ingredients: ['ข้าวกล้อง 1 ถ้วย', 'อกไก่ย่าง 150g', 'บรอกโคลี', 'แครอท'],
    ),
    FoodModel(
      name: 'สลัดปลาแซลมอน',
      calories: 500,
      protein: 35,
      carb: 30,
      fat: 22,
      ingredients: ['ปลาแซลมอนย่าง 120g', 'ผักสลัดรวม', 'มะเขือเทศ', 'น้ำสลัด'],
    ),
    FoodModel(
      name: 'ข้าวผัดกะเพราไก่ (น้ำมันน้อย)',
      calories: 520,
      protein: 30,
      carb: 65,
      fat: 14,
      ingredients: ['ข้าวสวย 1 ถ้วย', 'อกไก่สับ 120g', 'กะเพรา', 'พริก'],
    ),
  ];

  // เมนูอาหารเย็น
  static List<FoodModel> dinnerFoods = [
    FoodModel(
      name: 'ต้มยำกุ้ง + ข้าวสวย',
      calories: 400,
      protein: 28,
      carb: 45,
      fat: 8,
      ingredients: ['กุ้ง 150g', 'เห็ด', 'ข้าวสวย 3/4 ถ้วย', 'สมุนไพรต้มยำ'],
    ),
    FoodModel(
      name: 'ปลานึ่งมะนาว + ผักต้ม',
      calories: 380,
      protein: 32,
      carb: 30,
      fat: 10,
      ingredients: ['ปลากะพง 150g', 'มะนาว', 'กระเทียม', 'ผักบุ้ง'],
    ),
    FoodModel(
      name: 'สเต็กอกไก่ + มันหวานอบ',
      calories: 420,
      protein: 38,
      carb: 35,
      fat: 11,
      ingredients: ['อกไก่ 150g', 'มันหวาน 100g', 'บร็อกโคลีนึ่ง'],
    ),
  ];

  // ดึงรายการอาหารตามประเภทมื้อ
  static List<FoodModel> getFoodsByMealType(String mealType) {
    switch (mealType) {
      case 'breakfast':
        return breakfastFoods;
      case 'lunch':
        return lunchFoods;
      case 'dinner':
        return dinnerFoods;
      default:
        return [];
    }
  }
}