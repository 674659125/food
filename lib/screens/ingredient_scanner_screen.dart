import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';

import '../services/ai_recipe_service.dart';
import '../services/vision_detector_service.dart';
import '../theme/app_theme.dart';
import 'ai_recipe_result_screen.dart';
import 'main_navigation_screen.dart';

class IngredientScannerScreen extends StatefulWidget {
  const IngredientScannerScreen({super.key});

  @override
  State<IngredientScannerScreen> createState() =>
      _IngredientScannerScreenState();
}

class _IngredientScannerScreenState extends State<IngredientScannerScreen>
    with WidgetsBindingObserver {
  // Controller สำหรับกล้องถ่ายภาพจริง
  CameraController? _cameraController;
  List<CameraDescription> _cameras = [];
  int _selectedCameraIndex = 0;
  bool _isCameraInitialized = false;
  bool _isFlashOn = false;

  // สถานะการจับภาพ / สแกน
  XFile? _capturedImage;
  Uint8List? _capturedImageBytes;
  bool _isAnalyzing = false;

  // ผลการตรวจวิเคราะห์วัตถุดิบ
  List<DetectedItem> _detectedBoundingBoxes = [];
  List<String> _detectedIngredients = ['ไข่ไก่', 'ผักสดรวม', 'บล็อกโคลี่'];

  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = _cameraController;
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initCamera();
    }
  }

  // ตั้งค่ากล้องถ่ายภาพจริง
  Future<void> _initCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras.isNotEmpty) {
        await _onNewCameraSelected(_cameras[_selectedCameraIndex]);
      }
    } catch (e) {
      debugPrint('ไม่สามารถเปิดใช้งานกล้องได้: $e');
      if (mounted) {
        setState(() {
          _isCameraInitialized = false;
        });
      }
    }
  }

  Future<void> _onNewCameraSelected(CameraDescription cameraDescription) async {
    if (_cameraController != null) {
      await _cameraController!.dispose();
    }

    final CameraController cameraController = CameraController(
      cameraDescription,
      ResolutionPreset.high,
      enableAudio: false,
    );

    _cameraController = cameraController;

    try {
      await cameraController.initialize();
      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
        });
      }
    } catch (e) {
      debugPrint('ข้อผิดพลาดการเริ่มต้นกล้อง: $e');
      if (mounted) {
        setState(() {
          _isCameraInitialized = false;
        });
      }
    }
  }

  // สลับกล้องหน้า/หลัง
  void _switchCamera() {
    if (_cameras.length < 2) return;
    _selectedCameraIndex = (_selectedCameraIndex + 1) % _cameras.length;
    _onNewCameraSelected(_cameras[_selectedCameraIndex]);
  }

  // เปิด/ปิด แฟลช
  Future<void> _toggleFlash() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }
    try {
      _isFlashOn = !_isFlashOn;
      await _cameraController!
          .setFlashMode(_isFlashOn ? FlashMode.torch : FlashMode.off);
      setState(() {});
    } catch (e) {
      debugPrint('ไม่สามารถเปลี่ยนแฟลชได้: $e');
    }
  }

  // ถ่ายภาพจากกล้องเพื่อสแกนหาวัตถุดิบจริง
  Future<void> _takePictureAndScan() async {
    if (_isAnalyzing) return;

    XFile? imageFile;

    if (_isCameraInitialized &&
        _cameraController != null &&
        _cameraController!.value.isInitialized) {
      try {
        imageFile = await _cameraController!.takePicture();
      } catch (e) {
        debugPrint('เกิดข้อผิดพลาดขณะถ่ายภาพ: $e');
      }
    }

    // หากไม่สามารถใช้กล้องจริงได้ ให้ใช้ภาพตัวอย่างสำหรับทดสอบ
    imageFile ??= XFile('');

    _processImage(imageFile);
  }

  // เลือกรูปภาพจากคลังภาพ (Gallery)
  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? image =
          await _imagePicker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        _processImage(image);
      }
    } catch (e) {
      debugPrint('เลือกรูปจากคลังไม่สำเร็จ: $e');

      if (mounted) {
        if (e.toString().contains('MissingPluginException')) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              title: Text(
                '⚠️ ต้องรันแอปพลิเคชันใหม่ (Rebuild)',
                style: GoogleFonts.nunito(
                    fontWeight: FontWeight.bold, color: Colors.orange.shade900),
              ),
              content: Text(
                'เนื่องจากมีการเพิ่มปลั๊กอินเลือกรูปภาพใหม่ (image_picker) กรุณากดปุ่ม Stop 🟥 และกด Run ▶️ แอปพลิเคชันใหม่อีกครั้งเพื่อให้ Android คอมไพล์ปลั๊กอินครับ\n\n(หรือคุณสามารถกดทดสอบด้วยภาพตัวอย่างได้ทันที)',
                style: GoogleFonts.nunito(fontSize: 14),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _processImage(XFile('sample_fridge.jpg'));
                  },
                  child: const Text('ทดสอบด้วยภาพตัวอย่าง'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('ตกลง'),
                ),
              ],
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('ไม่สามารถเลือกรูปได้: $e'),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      }
    }
  }

  // ประมวลผลวิเคราะห์วัตถุดิบด้วย Vision AI
  Future<void> _processImage(XFile imageFile) async {
    Uint8List? imageBytes;
    try {
      if (imageFile.path.isNotEmpty) {
        imageBytes = await imageFile.readAsBytes();
      }
    } catch (e) {
      debugPrint('ไม่สามารถอ่านไฟล์รูปภาพได้: $e');
    }

    setState(() {
      _capturedImage = imageFile;
      _capturedImageBytes = imageBytes;
      _isAnalyzing = true;
    });

    final result = await VisionDetectorService.analyzeImage(imageFile);

    if (mounted) {
      setState(() {
        _isAnalyzing = false;
        _detectedBoundingBoxes = result.detectedItems;
        _detectedIngredients = result.ingredientNames;
      });
    }
  }

  // ล้างภาพถ่ายเพื่อกลับไปสแกนกล้องสดใหม่
  void _resetToLiveCamera() {
    setState(() {
      _capturedImage = null;
      _capturedImageBytes = null;
      _detectedBoundingBoxes = [];
    });
  }

  // เพิ่มวัตถุดิบด้วยตนเอง
  void _addIngredientDialog() {
    TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            '➕ เพิ่มวัตถุดิบเพิ่มเติม',
            style: GoogleFonts.nunito(
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'พิมพ์ชื่อวัตถุดิบ เช่น หมูสับ, มะเขือเทศ',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'ยกเลิก',
                style: GoogleFonts.nunito(color: AppColors.textLight),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (controller.text.trim().isNotEmpty) {
                  setState(() {
                    _detectedIngredients.add(controller.text.trim());
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('เพิ่ม'),
            ),
          ],
        );
      },
    );
  }

  // ส่งวัตถุดิบไปให้ AI คิดเมนู
  void _generateAiMenu() {
    if (_detectedIngredients.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'กรุณาสแกนหรือเพิ่มวัตถุดิบอย่างน้อย 1 รายการ',
            style: GoogleFonts.nunito(),
          ),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final recipes = AiRecipeService.generateRecipes(_detectedIngredients);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AiRecipeResultScreen(
          scannedIngredients: List.from(_detectedIngredients),
          recipes: recipes,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. ส่วนแสดงกล้องจริงสด (Live Camera Preview) หรือรูปถ่ายที่จับไว้
          Positioned.fill(
            child: _buildCameraOrImagePreview(screenSize),
          ),

          // 2. Bounding Boxes ของวัตถุดิบที่ตรวจพบ (คำนวณตำแหน่งจริงบนภาพ)
          if (!_isAnalyzing && _detectedBoundingBoxes.isNotEmpty)
            ..._buildDynamicBoundingBoxes(screenSize),

          // 3. เอฟเฟกต์ระหว่าง AI กำลังวิเคราะห์วัตถุดิบ
          if (_isAnalyzing)
            Positioned.fill(
              child: Container(
                color: Colors.black54,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(
                        color: Colors.orangeAccent,
                        strokeWidth: 3,
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.95),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '🔍 AI กำลังวิเคราะห์วัตถุดิบในภาพ...',
                          style: GoogleFonts.nunito(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: AppColors.textDark,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // 4. แถบหัวข้อด้านบน "เครื่องสแกนวัตถุดิบ 🔍"
          SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.95),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'เครื่องสแกนวัตถุดิบ',
                        style: GoogleFonts.nunito(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Icon(
                        Icons.search,
                        size: 18,
                        color: AppColors.textDark,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ปุ่มเครื่องมือกล้องควบคุมด้านบน (แฟลช / สลับกล้อง / คลังภาพ / คำนวณแคล)
          SafeArea(
            child: Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 10, right: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // ปุ่มไปหน้าคำนวณแคลอรี่
                    FloatingActionButton.small(
                      heroTag: 'nav_calc',
                      backgroundColor: Colors.white.withValues(alpha: 0.9),
                      elevation: 4,
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const MainNavigationScreen(initialIndex: 1)),
                        );
                      },
                      child: const Icon(Icons.calculate,
                          color: AppColors.pinkDark),
                    ),
                    const SizedBox(height: 10),

                    // ปุ่มเปิด/ปิด แฟลช
                    if (_isCameraInitialized && _capturedImage == null)
                      FloatingActionButton.small(
                        heroTag: 'flash_btn',
                        backgroundColor: Colors.white.withValues(alpha: 0.9),
                        elevation: 4,
                        onPressed: _toggleFlash,
                        child: Icon(
                          _isFlashOn ? Icons.flash_on : Icons.flash_off,
                          color: _isFlashOn ? Colors.amber : Colors.grey,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(top: 10, left: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // ปุ่มเลือกรูปภาพจากคลัง (Gallery)
                    FloatingActionButton.small(
                      heroTag: 'gallery_btn',
                      backgroundColor: Colors.white.withValues(alpha: 0.9),
                      elevation: 4,
                      onPressed: _pickImageFromGallery,
                      child: const Icon(Icons.photo_library,
                          color: Colors.blueAccent),
                    ),
                    const SizedBox(height: 10),

                    // ปุ่มสลับกล้องหน้า/หลัง หรือ ปุ่มถ่ายใหม่
                    if (_capturedImage != null)
                      FloatingActionButton.small(
                        heroTag: 'reset_btn',
                        backgroundColor: Colors.white.withValues(alpha: 0.9),
                        elevation: 4,
                        onPressed: _resetToLiveCamera,
                        child:
                            const Icon(Icons.refresh, color: Colors.orange),
                      )
                    else if (_cameras.length > 1)
                      FloatingActionButton.small(
                        heroTag: 'switch_cam_btn',
                        backgroundColor: Colors.white.withValues(alpha: 0.9),
                        elevation: 4,
                        onPressed: _switchCamera,
                        child: const Icon(Icons.cameraswitch,
                            color: Colors.orange),
                      ),
                  ],
                ),
              ),
            ),
          ),

          // 5. Bottom Sheet การ์ดแสดงผลวัตถุดิบ + ปุ่มถ่ายภาพสแกน
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.96),
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.25),
                    blurRadius: 20,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ปุ่มถ่ายภาพสแกนด้วยกล้องสด (Shutter Button)
                  if (_capturedImage == null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: Center(
                        child: GestureDetector(
                          onTap: _takePictureAndScan,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFFFF9A00), Color(0xFFFF6D00)],
                              ),
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.orange.withValues(alpha: 0.4),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.camera_alt,
                                    color: Colors.white, size: 22),
                                const SizedBox(width: 8),
                                Text(
                                  'สแกนวัตถุดิบด้วยกล้อง 📸',
                                  style: GoogleFonts.nunito(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                  // แถบหัวข้อ + ปุ่มเพิ่มวัตถุดิบ
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'ตรวจพบวัตถุดิบแล้ว (${_detectedIngredients.length})',
                        style: GoogleFonts.nunito(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                      GestureDetector(
                        onTap: _addIngredientDialog,
                        child: Text(
                          '+ เพิ่มเติม',
                          style: GoogleFonts.nunito(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange.shade800,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Tag ชิปแสดงรายการวัตถุดิบพร้อมปุ่มลบ (x)
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _detectedIngredients.map((ingredient) {
                      return _buildIngredientChip(ingredient);
                    }).toList(),
                  ),
                  const SizedBox(height: 16),

                  // ปุ่มส้มสว่าง "ทำเมนูอะไรดี? 🔍"
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _generateAiMenu,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF8C00),
                        foregroundColor: Colors.white,
                        elevation: 4,
                        shadowColor: Colors.orange.withValues(alpha: 0.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                        padding: EdgeInsets.zero,
                      ),
                      child: Ink(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFF9A00), Color(0xFFFF7000)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          borderRadius: BorderRadius.circular(28),
                        ),
                        child: Container(
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'ทำเมนูอะไรดี?',
                                style: GoogleFonts.nunito(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.search,
                                size: 22,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // สร้างวิดเจ็ตแสดงกล้องจริง หรือ รูปภาพที่จับไว้
  Widget _buildCameraOrImagePreview(Size screenSize) {
    if (_capturedImage != null) {
      if (_capturedImageBytes != null && _capturedImageBytes!.isNotEmpty) {
        return Image.memory(
          _capturedImageBytes!,
          fit: BoxFit.cover,
          width: screenSize.width,
          height: screenSize.height,
        );
      } else if (_capturedImage!.path.startsWith('http')) {
        return Image.network(
          _capturedImage!.path,
          fit: BoxFit.cover,
          width: screenSize.width,
          height: screenSize.height,
        );
      } else {
        // รูปตัวอย่างกรณีภาพสำรอง
        return Image.network(
          'https://images.unsplash.com/photo-1584269600464-37b1b58a9fe7?w=1000&auto=format&fit=crop',
          fit: BoxFit.cover,
          width: screenSize.width,
          height: screenSize.height,
        );
      }
    }

    if (_isCameraInitialized && _cameraController != null) {
      return CameraPreview(_cameraController!);
    }

    // กรณีรอกล้องเริ่มต้น หรืออุปกรณ์ไม่มีกล้อง
    return Container(
      color: const Color(0xFF1E293B),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.camera_alt, size: 70, color: Colors.white38),
            const SizedBox(height: 16),
            Text(
              'กำลังเชื่อมต่อกล้องถ่ายภาพ...',
              style: GoogleFonts.nunito(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _pickImageFromGallery,
              icon: const Icon(Icons.photo_library),
              label: const Text('เลือกรูปภาพจากคลัง'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // สร้าง Bounding Boxes แบบไดนามิกตามตำแหน่งภาพจริงที่ตรวจพบ
  List<Widget> _buildDynamicBoundingBoxes(Size screenSize) {
    return _detectedBoundingBoxes.map((item) {
      final double left = item.relativeX * screenSize.width;
      final double top = item.relativeY * screenSize.height;
      final double width = item.relativeWidth * screenSize.width;
      final double height = item.relativeHeight * screenSize.height;

      return Positioned(
        left: left,
        top: top,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // ป้ายแสดงชื่อวัตถุดิบที่ตรวจพบ
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: item.color,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Text(
                item.label,
                style: GoogleFonts.nunito(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 2),
            // กรอบ Bounding Box สี่เหลี่ยมตรวจจับ
            Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                border: Border.all(color: item.color, width: 2.5),
                borderRadius: BorderRadius.circular(8),
                color: item.color.withValues(alpha: 0.12),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  // ชิปวัตถุดิบพาสเทลชมพูพร้อมปุ่มลบ (x)
  Widget _buildIngredientChip(String ingredient) {
    return Container(
      padding: const EdgeInsets.only(left: 12, right: 6, top: 6, bottom: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFFFECEF),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFFC0CB), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            ingredient,
            style: GoogleFonts.nunito(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: const Color(0xFFD32F2F),
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: () {
              setState(() {
                _detectedIngredients.remove(ingredient);
              });
            },
            child: const Icon(
              Icons.close,
              size: 16,
              color: Color(0xFFD32F2F),
            ),
          ),
        ],
      ),
    );
  }
}
