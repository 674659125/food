import 'package:flutter/material.dart';
import '../models/user_model.dart';
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
      appBar: AppBar(title: const Text('คำนวณแคลอรี่')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // เพศ
            Row(
              children: [
                Expanded(
                  child: RadioListTile(
                    title: const Text('ชาย'),
                    value: 'male',
                    groupValue: gender,
                    onChanged: (v) => setState(() => gender = v!),
                  ),
                ),
                Expanded(
                  child: RadioListTile(
                    title: const Text('หญิง'),
                    value: 'female',
                    groupValue: gender,
                    onChanged: (v) => setState(() => gender = v!),
                  ),
                ),
              ],
            ),
            // อายุ
            Text('อายุ: ${age.toInt()} ปี'),
            Slider(
              value: age, min: 10, max: 80,
              onChanged: (v) => setState(() => age = v),
            ),
            // ส่วนสูง
            Text('ส่วนสูง: ${height.toInt()} cm'),
            Slider(
              value: height, min: 100, max: 220,
              onChanged: (v) => setState(() => height = v),
            ),
            // น้ำหนัก
            Text('น้ำหนัก: ${weight.toInt()} kg'),
            Slider(
              value: weight, min: 30, max: 150,
              onChanged: (v) => setState(() => weight = v),
            ),
            // เป้าหมาย
            DropdownButton<String>(
              value: goal,
              items: const [
                DropdownMenuItem(value: 'lose', child: Text('ลดน้ำหนัก')),
                DropdownMenuItem(value: 'gain', child: Text('เพิ่มน้ำหนัก')),
                DropdownMenuItem(value: 'maintain', child: Text('คงน้ำหนัก')),
              ],
              onChanged: (v) => setState(() => goal = v!),
            ),
            const Spacer(),
            ElevatedButton(
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
              child: const Text('คำนวณ'),
            ),
          ],
        ),
      ),
    );
  }
}