import 'package:flutter/material.dart';
import '../../widgets/elderly_keyboard/elderly_keyboard_prefs.dart';

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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Language Toggle
              ListTile(
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
              const Divider(height: 1, thickness: 1, color: Color(0xFFF0F0F0), indent: 64, endIndent: 20),
              // Elderly Keyboard Toggle
              ValueListenableBuilder<bool>(
                valueListenable: elderlyKeyboardEnabled,
                builder: (context, isEnabled, _) {
                  return ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F9FA),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.keyboard_alt_outlined, color: Colors.black87, size: 22),
                    ),
                    title: const Text(
                      'Elderly Keyboard',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    subtitle: const Text(
                      'Large keys for easier typing',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.black45,
                      ),
                    ),
                    trailing: Switch(
                      value: isEnabled,
                      onChanged: (val) {
                        elderlyKeyboardEnabled.value = val;
                      },
                      activeThumbColor: const Color(0xFFF5A623),
                      activeTrackColor: const Color(0xFFF5A623).withValues(alpha: 0.3),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
