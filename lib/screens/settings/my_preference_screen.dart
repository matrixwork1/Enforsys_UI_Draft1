import 'package:flutter/material.dart';

class MyPreferenceScreen extends StatefulWidget {
  const MyPreferenceScreen({super.key});

  @override
  State<MyPreferenceScreen> createState() => _MyPreferenceScreenState();
}

class _MyPreferenceScreenState extends State<MyPreferenceScreen> {
  String _currentLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'My Preference',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: Container(
          color: Colors.white,
          child: ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FA),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.language, color: Colors.black87, size: 22),
            ),
            title: const Text(
              'Switch Language',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _currentLanguage,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
              ],
            ),
            onTap: () {
              // Toggle just for visual feedback logic
              setState(() {
                _currentLanguage = _currentLanguage == 'English' ? 'Bahasa Melayu' : 'English';
              });
            },
          ),
        ),
      ),
    );
  }
}
