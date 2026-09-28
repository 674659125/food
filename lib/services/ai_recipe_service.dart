import '../models/food_model.dart';

class AiRecipe {
  final String title;
  final String description;
  final double calories;
  final double protein;
  final double carb;
  final double fat;
  final int cookingTimeMinutes;
  final String difficulty;
  final List<String> matchedIngredients;
  final List<String> extraIngredientsNeeded;
  final List<String> instructions;
  final String imageUrl;

  AiRecipe({
    required this.title,
    required this.description,
    required this.calories,
    required this.protein,
    required this.carb,
    required this.fat,
    required this.cookingTimeMinutes,
    required this.difficulty,
    required this.matchedIngredients,
    required this.extraIngredientsNeeded,
    required this.instructions,
    this.imageUrl = '',
  });
}

class AiRecipeService {
  /// AI คิดเมนูอาหารจากรายการวัตถุดิบที่สแกนได้
  static List<AiRecipe> generateRecipes(List<String> ingredients) {
    List<String> lowerIngredients =
        ingredients.map((e) => e.toLowerCase()).toList();

    List<AiRecipe> allRecipes = [
      AiRecipe(
        title: 'ผัดบร็อกโคลี่อกไก่ใส่ไข่',
        description: 'เมนูคลีนโปรตีนสูง ทำง่าย เหมาะสำหรับผู้ที่ต้องการควบคุมน้ำหนัก',
        calories: 380,
        protein: 35,
        carb: 18,
        fat: 12,
        cookingTimeMinutes: 15,
        difficulty: 'ง่าย',
        matchedIngredients: ['ไข่ไก่', 'บล็อกโคลี่', 'ไก่'],
        extraIngredientsNeeded: ['กระเทียม', 'ซอสหอยนางรมโซเดียมต่ำ'],
        instructions: [
          'หั่นอกไก่และบร็อกโคลี่เป็นชิ้นพอดีคำ',
          'ตั้งกระทะใช้น้ำมันมะกอกเล็กน้อย ผัดกระเทียมจนหอม',
          'ใส่อกไก่ลงไปผัดจนเริ่มสุก แล้วตามด้วยบร็อกโคลี่',
          'ตอกไข่ใส่ลงไป ยีพอสุกแล้วผัดคลุกเคล้าให้เข้ากัน',
          'ปรุงรสด้วยซอสหอยนางรมโซเดียมต่ำ พร้อมเสิร์ฟ',
        ],
        imageUrl:
            'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=600&auto=format&fit=crop',
      ),
      AiRecipe(
        title: 'ไข่พระอาทิตย์ผักสดรวม',
        description: 'เมนูไข่ทรงเครื่องเพิ่มคุณค่าทางอาหารด้วยผักสดหลากสี',
        calories: 310,
        protein: 22,
        carb: 12,
        fat: 18,
        cookingTimeMinutes: 10,
        difficulty: 'ง่ายมาก',
        matchedIngredients: ['ไข่ไก่', 'ผักสดรวม'],
        extraIngredientsNeeded: ['พริกไทย', 'ซีอิ๊วขาว'],
        instructions: [
          'ตอกไข่ไก่ใส่ชาม ตีให้เข้ากัน',
          'สับผักสดรวมให้เป็นชิ้นเล็กๆ แล้วผสมลงในไข่',
          'ปรุงรสด้วยซีอิ๊วขาวและพริกไทยเล็กน้อย',
          'ตั้งกระทะเทฟลอน ใช้ไฟอ่อน เทไข่ลงไปทอดจนสุกเหลืองทั้งสองด้าน',
        ],
        imageUrl:
            'https://images.unsplash.com/photo-1525351484163-7529414344d8?w=600&auto=format&fit=crop',
      ),
      AiRecipe(
        title: 'แกงจืดบร็อกโคลี่อกไก่สับ',
        description: 'ซุปร้อนๆ รสชาติกลมกล่อม ซดคล่องคอ ให้พลังงานต่ำ',
        calories: 250,
        protein: 28,
        carb: 15,
        fat: 6,
        cookingTimeMinutes: 20,
        difficulty: 'ปานกลาง',
        matchedIngredients: ['บล็อกโคลี่', 'ไก่'],
        extraIngredientsNeeded: ['ซุปก้อนซี่โครงหมู/ไก่', 'ซีอิ๊วขาว'],
        instructions: [
          'ตั้งน้ำให้เดือด ใส่ซุปก้อนต้มจนละลาย',
          'ปั้นอกไก่สับเป็นก้อนก้อนพอดีคำ ใส่ลงในน้ำเดือด',
          'เมื่อไก่สุก ลอยขึ้นมา ใส่บร็อกโคลี่ลงไปต้มประมาณ 3 นาที',
          'ปรุงรสตามชอบ ตักใส่ชามเสิร์ฟร้อนๆ',
        ],
        imageUrl:
            'https://images.unsplash.com/photo-1547592166-23ac45744acd?w=600&auto=format&fit=crop',
      ),
      AiRecipe(
        title: 'สลัดผักรวมต้มไข่ & อกไก่ฉีก',
        description: 'สลัดจานใหญ่ สดชื่น ได้ไฟเบอร์และโปรตีนเน้นๆ',
        calories: 290,
        protein: 30,
        carb: 14,
        fat: 10,
        cookingTimeMinutes: 12,
        difficulty: 'ง่ายมาก',
        matchedIngredients: ['ไข่ไก่', 'ผักสดรวม', 'ไก่'],
        extraIngredientsNeeded: ['น้ำสลัดงาญี่ปุ่น'],
        instructions: [
          'ต้มไข่ไก่จนสุกระดับที่ชอบ แล้วปอกเปลือกหั่นครึ่ง',
          'ต้มอกไก่จนสุก แล้วนำมาฉีกเป็นเส้นๆ',
          'ล้างผักสดรวมให้สะอาด จัดใส่จาน',
          'วางอกไก่ฉีกและไข่ต้มด้านบน ราดด้วยน้ำสลัดงาญี่ปุ่น',
        ],
        imageUrl:
            'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=600&auto=format&fit=crop',
      ),
    ];

    // จัดลำดับเมนูตามจำนวนวัตถุดิบที่ตรงกัน
    allRecipes.sort((a, b) {
      int matchA = a.matchedIngredients
          .where((ing) => lowerIngredients.any((i) => i.contains(ing.toLowerCase()) || ing.toLowerCase().contains(i)))
          .length;
      int matchB = b.matchedIngredients
          .where((ing) => lowerIngredients.any((i) => i.contains(ing.toLowerCase()) || ing.toLowerCase().contains(i)))
          .length;
      return matchB.compareTo(matchA);
    });

    return allRecipes;
  }
}
