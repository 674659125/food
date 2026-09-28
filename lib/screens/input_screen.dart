import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/user_model.dart';
import '../theme/app_theme.dart';
import 'result_screen.dart';

class InputScreen extends StatefulWidget {
  const InputScreen({super.key});

  @override
  State<InputScreen> createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  String gender = 'male';
  double age = 20, height = 170, weight = 60;
  String goal = 'lose';
  String activityLevel = 'medium';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'คำนวณเป้าหมายแคลอรี่',
          style: GoogleFonts.nunito(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 650),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // การ์ดเลือกเพศ
                  _buildSectionTitle('1. เลือกเพศของคุณ'),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _genderCard(
                          title: 'ชาย',
                          emoji: '👨',
                          value: 'male',
                          isSelected: gender == 'male',
                          color: AppColors.blueDark,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: _genderCard(
                          title: 'หญิง',
                          emoji: '👩',
                          value: 'female',
                          isSelected: gender == 'female',
                          color: AppColors.pinkDark,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // การ์ดกรอกข้อมูล อายุ ส่วนสูง น้ำหนัก
                  _buildSectionTitle('2. ข้อมูลสัดส่วนและร่างกาย'),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.pinkDark.withValues(alpha: 0.1),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // อายุ
                        _sliderTile(
                          label: 'อายุ',
                          valueText: '${age.toInt()} ปี',
                          value: age,
                          min: 10,
                          max: 80,
                          color: AppColors.pinkDark,
                          onChanged: (v) => setState(() => age = v),
                        ),
                        const Divider(height: 24),

                        // ส่วนสูง
                        _sliderTile(
                          label: 'ส่วนสูง',
                          valueText: '${height.toInt()} cm',
                          value: height,
                          min: 100,
                          max: 220,
                          color: AppColors.blueDark,
                          onChanged: (v) => setState(() => height = v),
                        ),
                        const Divider(height: 24),

                        // น้ำหนัก
                        _sliderTile(
                          label: 'น้ำหนัก',
                          valueText: '${weight.toInt()} kg',
                          value: weight,
                          min: 30,
                          max: 150,
                          color: AppColors.lavender,
                          onChanged: (v) => setState(() => weight = v),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // การ์ดเป้าหมาย & กิจกรรม
                  _buildSectionTitle('3. เป้าหมายและกิจกรรม'),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.blueDark.withValues(alpha: 0.1),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // เป้าหมาย
                        Text(
                          '🎯 เป้าหมายของคุณ:',
                          style: GoogleFonts.nunito(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: AppColors.textDark,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                                color: AppColors.pinkDark.withValues(alpha: 0.3)),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: goal,
                              isExpanded: true,
                              icon: const Icon(Icons.arrow_drop_down,
                                  color: AppColors.pinkDark),
                              items: const [
                                DropdownMenuItem(
                                  value: 'lose',
                                  child: Text('📉 ลดน้ำหนัก (Deficit 400 kcal)'),
                                ),
                                DropdownMenuItem(
                                  value: 'maintain',
                                  child: Text('⚖️ คงน้ำหนัก (Maintain TDEE)'),
                                ),
                                DropdownMenuItem(
                                  value: 'gain',
                                  child: Text('📈 เพิ่มน้ำหนัก (Surplus 400 kcal)'),
                                ),
                              ],
                              onChanged: (v) => setState(() => goal = v!),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // ระดับกิจกรรม
                        Text(
                          '🏃‍♂️ ระดับการออกกำลังกาย/กิจกรรม:',
                          style: GoogleFonts.nunito(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: AppColors.textDark,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                                color: AppColors.blueDark.withValues(alpha: 0.3)),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: activityLevel,
                              isExpanded: true,
                              icon: const Icon(Icons.arrow_drop_down,
                                  color: AppColors.blueDark),
                              items: const [
                                DropdownMenuItem(
                                  value: 'low',
                                  child: Text('🚶 นั่งทำงานเป็นหลัก / ออกกำลังกายน้อย'),
                                ),
                                DropdownMenuItem(
                                  value: 'medium',
                                  child: Text('🏃 ออกกำลังกายปานกลาง (3-5 วัน/สัปดาห์)'),
                                ),
                                DropdownMenuItem(
                                  value: 'high',
                                  child: Text('🚴 ออกกำลังกายหนัก (6-7 วัน/สัปดาห์)'),
                                ),
                              ],
                              onChanged: (v) =>
                                  setState(() => activityLevel = v!),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),

                  // ปุ่มกดคำนวณผลลัพธ์
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: () {
                        UserModel user = UserModel(
                          gender: gender,
                          age: age.toInt(),
                          height: height,
                          weight: weight,
                          goal: goal,
                          activityLevel: activityLevel,
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ResultScreen(user: user),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.pinkDark,
                        foregroundColor: Colors.white,
                        elevation: 4,
                        shadowColor: AppColors.pinkDark.withValues(alpha: 0.4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'คำนวณแคลอรี่เป้าหมาย',
                            style: GoogleFonts.nunito(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_forward_rounded, size: 22),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.nunito(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: AppColors.textDark,
      ),
    );
  }

  Widget _genderCard({
    required String title,
    required String emoji,
    required String value,
    required bool isSelected,
    required Color color,
  }) {
    return GestureDetector(
      onTap: () => setState(() => gender = value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? color : Colors.grey.shade300,
            width: 2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 32)),
            const SizedBox(height: 6),
            Text(
              title,
              style: GoogleFonts.nunito(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : AppColors.textDark,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sliderTile({
    required String label,
    required String valueText,
    required double value,
    required double min,
    required double max,
    required Color color,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: GoogleFonts.nunito(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                valueText,
                style: GoogleFonts.nunito(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: color == AppColors.lavender ? AppColors.textDark : color,
                ),
              ),
            ),
          ],
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          activeColor: color == AppColors.lavender ? AppColors.pinkDark : color,
          inactiveColor: color.withValues(alpha: 0.2),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
