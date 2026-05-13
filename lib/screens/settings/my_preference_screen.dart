import 'package:flutter/material.dart';
import '../../widgets/elderly_keyboard/elderly_keyboard_prefs.dart';

class MyPreferenceScreen extends StatefulWidget {
  const MyPreferenceScreen({super.key});

  @override
  State<MyPreferenceScreen> createState() => _MyPreferenceScreenState();
}

class _MyPreferenceScreenState extends State<MyPreferenceScreen> {
  String _currentLanguage = 'EN';

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
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 24),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Language Dropdown
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F9FA),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.language, color: Colors.black87, size: 22),
                    ),
                    title: const Text(
                      'Language',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    trailing: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _currentLanguage,
                        isDense: true,
                        icon: const Icon(Icons.keyboard_arrow_down, size: 18, color: Colors.grey),
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.black54,
                        ),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              _currentLanguage = newValue;
                            });
                          }
                        },
                        items: const [
                          DropdownMenuItem(value: 'EN', child: Text('English')),
                          DropdownMenuItem(value: 'MS', child: Text('Bahasa Melayu')),
                          DropdownMenuItem(value: 'ZH', child: Text('中文')),
                        ],
                      ),
                    ),
                  ),
                  const Divider(height: 1, thickness: 1, color: Color(0xFFF0F0F0), indent: 64, endIndent: 20),
                  // Elderly Keyboard Toggle
                  ValueListenableBuilder<bool>(
                    valueListenable: elderlyKeyboardEnabled,
                    builder: (context, isEnabled, _) {
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
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
                            fontSize: 15,
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
          ],
        ),
      ),
    );
  }
}
