import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

class IDCardCameraPage extends StatefulWidget {
  const IDCardCameraPage({super.key});

  @override
  _IDCardCameraPageState createState() => _IDCardCameraPageState();
}

class _IDCardCameraPageState extends State<IDCardCameraPage> {
  CameraController? _controller;
  File? _croppedImage;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      final camera = cameras.first;
      // _controller = CameraController(camera, ResolutionPreset.high);
      _controller = CameraController(
        camera,
        ResolutionPreset.high,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );
      await _controller!.initialize();
      setState(() {});
    } catch (e) {
      print('❌ กล้องมีปัญหา: $e');
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _captureAndCropImage() async {
    try {
      final picture = await _controller!.takePicture();

      // ✅ รอให้กล้องบันทึกภาพเสร็จจริง
      await Future.delayed(Duration(milliseconds: 300));

      final file = File(picture.path);
      int retry = 0;
      while (!file.existsSync() && retry < 5) {
        await Future.delayed(Duration(milliseconds: 100));
        retry++;
      }

      final imageBytes = await file.readAsBytes();
      final original = img.decodeImage(imageBytes);
      if (original == null) return;

      // สร้าง crop ตามกรอบตรงกลาง (สัดส่วน 1.6:1 เหมือนบัตร)
      final cropWidth = (original.width * 0.6).toInt();
      final cropHeight = (cropWidth / 1.4).toInt();
      final cropX = (original.width ~/ 1.8) - (cropWidth ~/ 1.8);
      final cropY = (original.height ~/ 1.8) - (cropHeight ~/ 1.8);

      final cropped = img.copyCrop(original, cropX, cropY, cropWidth, cropHeight);
      final tempDir = await getTemporaryDirectory();
      final croppedFile = File('${tempDir.path}/cropped_idcard_${DateTime.now().millisecondsSinceEpoch}.jpg')..writeAsBytesSync(img.encodeJpg(cropped));

      setState(() {
        _croppedImage = croppedFile;
      });
    } catch (e) {
      print("❌ เกิดข้อผิดพลาดขณะถ่ายภาพ: $e");
    }
  }

  void _retake() {
    setState(() {
      _croppedImage = null;
    });
  }

  void _confirm() {
    if (_croppedImage != null) {
      print('✅ รูปถูกเลือก: ${_croppedImage!.path}');
      Navigator.pop(context, _croppedImage);
      // ใช้ path นี้ต่อ เช่น upload หรือแสดงผล
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _croppedImage != null
          ? _buildPreview()
          : (_controller == null || !_controller!.value.isInitialized)
              ? Center(child: CircularProgressIndicator(color: Colors.white))
              : _buildCamera(),
    );
  }

  Widget _buildCamera() {
    return Stack(
      children: [
        CameraPreview(_controller!),
        _buildOverlayFrame(),
        Positioned(
          bottom: 40,
          left: 0,
          right: 0,
          child: Center(
            child: GestureDetector(
              onTap: _captureAndCropImage,
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: Icon(Icons.camera_alt, size: 30, color: Colors.black),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOverlayFrame() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenW = constraints.maxWidth;
        final frameW = screenW * 0.7;
        final frameH = frameW / 1.7;

        return Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.black.withOpacity(0.5),
            ),
            Center(
              child: Container(
                width: frameW,
                height: frameH,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(color: Colors.greenAccent, width: 3),
                ),
              ),
            ),
            Positioned(
              top: 60,
              left: 450,
              right: 0,
              child: Text(
                "กรุณาถ่ายรูปให้อยู่ในกรอบ",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
            Positioned(
              top: 50,
              left: 10,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  height: MediaQuery.of(context).size.width * 0.15,
                  width: MediaQuery.of(context).size.width * 0.15,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      // color: brown,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPreview() {
    return Stack(
      children: [
        Center(child: Image.file(_croppedImage!)),
        Positioned(
          bottom: 30,
          left: 40,
          right: 40,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton.icon(
                onPressed: _retake,
                icon: Icon(Icons.refresh, color: Colors.white),
                label: Text("ถ่ายใหม่", style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
              ),
              ElevatedButton.icon(
                onPressed: _confirm,
                icon: Icon(Icons.check, color: Colors.white),
                label: Text("ตกลง", style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
