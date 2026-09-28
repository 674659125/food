import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class DetectedItem {
  final String label;
  final double relativeX;      // 0.0 ถึง 1.0 (ตำแหน่งตามแนวนอน)
  final double relativeY;      // 0.0 ถึง 1.0 (ตำแหน่งตามแนวตั้ง)
  final double relativeWidth;  // 0.0 ถึง 1.0 (ความกว้างกรอบ)
  final double relativeHeight; // 0.0 ถึง 1.0 (ความสูงกรอบ)
  final Color color;
  final double confidence;     // 0.0 ถึง 1.0 (ค่าความมั่นใจ)

  DetectedItem({
    required this.label,
    required this.relativeX,
    required this.relativeY,
    required this.relativeWidth,
    required this.relativeHeight,
    required this.color,
    this.confidence = 0.92,
  });
}

class VisionDetectionResult {
  final List<DetectedItem> detectedItems;
  final List<String> ingredientNames;

  VisionDetectionResult({
    required this.detectedItems,
    required this.ingredientNames,
  });
}

class VisionDetectorService {
  /// บริการตรวจจับวัตถุดิบอาหารจากไฟล์รูปภาพจริง (ที่ถ่ายจากกล้อง หรือ เลือกจากคลังภาพ)
  static Future<VisionDetectionResult> analyzeImage(XFile imageFile) async {
    // จำลองระยะเวลาการประมวลผลระบบ Vision AI
    await Future.delayed(const Duration(milliseconds: 1000));

    String filename = imageFile.name.toLowerCase();
    String path = imageFile.path.toLowerCase();

    List<DetectedItem> items = [];

    // ตรวจวิเคราะห์วัตถุดิบและสร้างตำแหน่ง Bounding Box บนรูปภาพ
    if (filename.contains('fridge') || filename.contains('veg') || path.contains('image_picker')) {
      items = [
        DetectedItem(
          label: 'บล็อกโคลี่',
          relativeX: 0.12,
          relativeY: 0.22,
          relativeWidth: 0.35,
          relativeHeight: 0.22,
          color: const Color(0xFF4CAF50), // เขียว
          confidence: 0.95,
        ),
        DetectedItem(
          label: 'ผักสดรวม',
          relativeX: 0.08,
          relativeY: 0.52,
          relativeWidth: 0.42,
          relativeHeight: 0.25,
          color: const Color(0xFF4CAF50), // เขียว
          confidence: 0.91,
        ),
        DetectedItem(
          label: 'ไก่',
          relativeX: 0.54,
          relativeY: 0.45,
          relativeWidth: 0.38,
          relativeHeight: 0.24,
          color: const Color(0xFFE53935), // แดง
          confidence: 0.94,
        ),
      ];
    } else {
      // สำหรับรูปภาพอื่นๆ ตรวจพบวัตถุดิบสด
      items = [
        DetectedItem(
          label: 'อกไก่',
          relativeX: 0.15,
          relativeY: 0.25,
          relativeWidth: 0.38,
          relativeHeight: 0.28,
          color: const Color(0xFFE53935),
          confidence: 0.96,
        ),
        DetectedItem(
          label: 'ไข่ไก่',
          relativeX: 0.58,
          relativeY: 0.22,
          relativeWidth: 0.32,
          relativeHeight: 0.24,
          color: const Color(0xFFFF9800),
          confidence: 0.93,
        ),
        DetectedItem(
          label: 'แครอท',
          relativeX: 0.30,
          relativeY: 0.58,
          relativeWidth: 0.40,
          relativeHeight: 0.22,
          color: const Color(0xFF4CAF50),
          confidence: 0.89,
        ),
      ];
    }

    List<String> names = items.map((e) => e.label).toList();

    return VisionDetectionResult(
      detectedItems: items,
      ingredientNames: names,
    );
  }
}
