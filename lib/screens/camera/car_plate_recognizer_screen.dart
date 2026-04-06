import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import '../history/validator_record_screen.dart';

class CarPlateRecognizerScreen extends StatefulWidget {
  const CarPlateRecognizerScreen({super.key});

  @override
  State<CarPlateRecognizerScreen> createState() => _CarPlateRecognizerScreenState();
}

class _CarPlateRecognizerScreenState extends State<CarPlateRecognizerScreen> {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  bool _isCameraInitialized = false;
  bool _confirmationModeEnabled = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras != null && _cameras!.isNotEmpty) {
        _controller = CameraController(
          _cameras![0],
          ResolutionPreset.high,
          enableAudio: false,
        );
        await _controller!.initialize();
        if (mounted) {
          setState(() {
            _isCameraInitialized = true;
          });
        }
      }
    } catch (e) {
      debugPrint("Error initializing camera: $e");
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Car Plate Recognizer',
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
        actions: [
          Row(
            children: [
              const Text('Confirmation', style: TextStyle(color: Colors.black, fontSize: 12)),
              Switch(
                value: _confirmationModeEnabled,
                onChanged: (val) {
                  setState(() {
                     _confirmationModeEnabled = val;
                  });
                },
                activeTrackColor: const Color(0xFFF5A623),
              ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Stack(
        children: [
          // Camera Preview
          if (_isCameraInitialized && _controller != null)
            SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: CameraPreview(_controller!),
            )
          else
            const Center(
              child: CircularProgressIndicator(color: Color(0xFFF5A623)),
            ),

          // Landscape overlay text
          if (MediaQuery.of(context).orientation == Orientation.portrait)
            Positioned(
              bottom: 150,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                       BoxShadow(
                         color: Colors.black.withValues(alpha: 0.2),
                         blurRadius: 10,
                       )
                    ]
                  ),
                  child: const Text(
                    'Please use landscape orientation',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

          // Bottom Controls
          Positioned(
            bottom: 40,
            left: 30,
            right: 30,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Validator Record Button
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const ValidatorRecordScreen()),
                    );
                  },
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 1.5),
                    ),
                    child: const Icon(
                      Icons.receipt_long_outlined,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ),
                
                // Camera Capture Button
                GestureDetector(
                  onTap: () {
                    // Capture logic
                  },
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey.shade300, width: 4),
                    ),
                    child: const Center(
                      child: Icon(Icons.camera_alt, color: Colors.black54, size: 36),
                    ),
                  ),
                ),
                
                // Empty placeholder for right alignment
                const SizedBox(width: 60),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
