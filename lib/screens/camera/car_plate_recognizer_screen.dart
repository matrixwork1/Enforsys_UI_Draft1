import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:sensors_plus/sensors_plus.dart';
import '../history/validator_record_screen.dart';
import '../../widgets/elderly_keyboard/elderly_text_field.dart';
import '../../widgets/validator_result_popup.dart';
import '../../widgets/recognized_plates_popup.dart';
import '../../models/models.dart';

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
  final TextEditingController _searchController = TextEditingController();
  int _captureCount = 0;

  // Device orientation tracking via accelerometer
  StreamSubscription<AccelerometerEvent>? _accelSubscription;
  double _iconRotation = 0.0; // in quarter turns (0, 0.25, 0.5, -0.25)

  // Demo data sets that cycle on each capture press
  final List<List<RecognizedPlateEntry>> _demoCaptureSets = const [
    [
      RecognizedPlateEntry(plate: 'QAA9979P', status: ValidatorStatus.noPermitFound),
      RecognizedPlateEntry(plate: 'QBD5227', status: ValidatorStatus.activeSeasonPass),
      RecognizedPlateEntry(plate: 'SWQ2003', status: ValidatorStatus.opnFound),
      RecognizedPlateEntry(plate: 'QSR8812', status: ValidatorStatus.activeUserCoupon),
    ],
    [
      RecognizedPlateEntry(plate: 'QLB2927', status: ValidatorStatus.activeUserCoupon),
      RecognizedPlateEntry(plate: 'QS8852L', status: ValidatorStatus.compoundIssued),
      RecognizedPlateEntry(plate: 'VJK1992', status: ValidatorStatus.noPermitFound),
    ],
    [
      RecognizedPlateEntry(plate: 'QSJ1831', status: ValidatorStatus.activeSeasonPass),
      RecognizedPlateEntry(plate: 'QAA9677P', status: ValidatorStatus.noPermitFound),
      RecognizedPlateEntry(plate: 'BBM445', status: ValidatorStatus.opnFound),
      RecognizedPlateEntry(plate: 'WXX111', status: ValidatorStatus.activeUserCoupon),
      RecognizedPlateEntry(plate: 'JUD8898', status: ValidatorStatus.compoundIssued),
    ],
  ];

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _startOrientationTracking();
  }

  void _startOrientationTracking() {
    _accelSubscription = accelerometerEventStream(
      samplingPeriod: const Duration(milliseconds: 200),
    ).listen((AccelerometerEvent event) {
      double newRotation = _iconRotation;

      // Determine physical orientation from accelerometer
      // x ~ 0, y ~ 9.8 → portrait up (0)
      // x ~ 9.8, y ~ 0 → landscape left (0.25 turn = 90° CW)
      // x ~ -9.8, y ~ 0 → landscape right (-0.25 turn = 90° CCW)
      // x ~ 0, y ~ -9.8 → upside down (0.5 turn)
      if (event.y.abs() > event.x.abs()) {
        if (event.y > 0) {
          newRotation = 0.0; // Portrait up
        } else {
          newRotation = 0.5; // Upside down
        }
      } else {
        if (event.x > 0) {
          newRotation = 0.25; // Device rotated CCW → icons rotate CW to stay upright
        } else {
          newRotation = -0.25; // Device rotated CW → icons rotate CCW to stay upright
        }
      }

      if (newRotation != _iconRotation && mounted) {
        setState(() {
          _iconRotation = newRotation;
        });
      }
    });
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
    _accelSubscription?.cancel();
    _controller?.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onCapture() {
    final setIndex = _captureCount % _demoCaptureSets.length;
    final plates = _demoCaptureSets[setIndex];
    _captureCount++;

    showRecognizedPlatesPopup(
      context,
      capturedImageUrl: 'https://loremflickr.com/400/300/parking?lock=$_captureCount',
      plates: plates,
    );
  }

  void _onSearch() {
    final text = _searchController.text.trim();
    if (text.isEmpty) return;

    FocusScope.of(context).unfocus();

    // Cycle through different demo statuses for search results
    final statuses = ValidatorStatus.values;
    final statusIndex = text.hashCode.abs() % statuses.length;

    final data = ValidatorResultData(
      plate: text.toUpperCase(),
      parkingArea: 'Jalan Pedada',
      checkedAt: _getCurrentTimestamp(),
      imageUrl: 'https://loremflickr.com/400/300/car?lock=${text.hashCode}',
      status: statuses[statusIndex],
    );
    showValidatorResultPopup(context, data);
  }

  String _getCurrentTimestamp() {
    final now = DateTime.now();
    final hour = now.hour > 12 ? now.hour - 12 : (now.hour == 0 ? 12 : now.hour);
    final period = now.hour >= 12 ? 'PM' : 'AM';
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}, '
        '${hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')} $period';
  }

  /// Wraps a child widget with animated rotation based on physical device orientation.
  Widget _orientedIcon(Widget child) {
    return AnimatedRotation(
      turns: _iconRotation,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: child,
    );
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

          // Search bar overlay — positioned below the app bar, stands out more
          Positioned(
            top: MediaQuery.of(context).padding.top + kToolbarHeight + 12,
            left: 16,
            right: 16,
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.25),
                    blurRadius: 18,
                    offset: const Offset(0, 6),
                  ),
                  BoxShadow(
                    color: const Color(0xFFF5A623).withValues(alpha: 0.15),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
                border: Border.all(
                  color: const Color(0xFFF5A623).withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: ElderlyTextField(
                      controller: _searchController,
                      textCapitalization: TextCapitalization.characters,
                      textAlignVertical: TextAlignVertical.center,
                      onSubmitted: (_) => _onSearch(),
                      decoration: const InputDecoration(
                        hintText: 'Search car plate no.',
                        hintStyle: TextStyle(
                          color: Color(0xFFBDBDBD),
                          fontStyle: FontStyle.italic,
                          fontSize: 14,
                        ),
                        prefixIcon: Icon(Icons.directions_car_outlined, color: Color(0xFF9CA3AF), size: 20),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                        isDense: true,
                      ),
                    ),
                  ),
                  Container(
                    height: 50,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF5A623),
                      borderRadius: BorderRadius.horizontal(right: Radius.circular(13)),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: _onSearch,
                        borderRadius: const BorderRadius.horizontal(right: Radius.circular(13)),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 18),
                          child: Row(
                            children: [
                              Icon(Icons.search, color: Colors.white, size: 20),
                              SizedBox(width: 6),
                              Text(
                                'Search',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
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

          // Bottom Controls
          Positioned(
            bottom: 40,
            left: 30,
            right: 30,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Empty placeholder for left alignment (swapped with validator record)
                const SizedBox(width: 60),
                
                // Camera Capture Button — no white ring, orange fill
                GestureDetector(
                  onTap: _onCapture,
                  child: Container(
                    width: 76,
                    height: 76,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFFF5A623),
                          Color(0xFFE8941A),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFF5A623).withValues(alpha: 0.45),
                          blurRadius: 20,
                          spreadRadius: 3,
                        ),
                      ],
                    ),
                    child: _orientedIcon(
                      const Icon(Icons.camera_alt, color: Colors.white, size: 34),
                    ),
                  ),
                ),
                
                // Validator Record Button — moved to bottom right
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
                    child: _orientedIcon(
                      const Icon(
                        Icons.receipt_long_outlined,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
