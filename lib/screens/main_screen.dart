import 'package:flutter/material.dart';
import 'home/home_screen.dart';
import 'camera/car_plate_recognizer_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      extendBody: true, // Enables true floating layering over body
      body: SafeArea(
        child: _screens[_currentIndex],
      ),
      floatingActionButton: SizedBox(
        width: 72,
        height: 72,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const CarPlateRecognizerScreen()),
            );
          },
          backgroundColor: const Color(0xFFF5A623),
          shape: const CircleBorder(),
          elevation: 6,
          child: const Icon(Icons.camera_alt, color: Colors.white, size: 36),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

