import 'package:flutter/material.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  bool _obsOld = true;
  bool _obsNew = true;
  bool _obsConfirm = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Change Password',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFF5A623).withValues(alpha: 0.15),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField(
                hint: 'Old Password',
                isPassword: true,
                obscureText: _obsOld,
                onVisibilityChanged: () => setState(() => _obsOld = !_obsOld),
                icon: Icons.lock_clock, // approximate icon for old password
                isTop: true,
              ),
              const Divider(height: 1, color: Color(0xFFF0F0F0), indent: 16, endIndent: 16),
              _buildTextField(
                hint: 'New Password',
                isPassword: true,
                obscureText: _obsNew,
                onVisibilityChanged: () => setState(() => _obsNew = !_obsNew),
                icon: Icons.lock,
              ),
              const Divider(height: 1, color: Color(0xFFF0F0F0), indent: 16, endIndent: 16),
              _buildTextField(
                hint: 'Re-enter New Password',
                isPassword: true,
                obscureText: _obsConfirm,
                onVisibilityChanged: () => setState(() => _obsConfirm = !_obsConfirm),
                icon: Icons.lock_outline,
                isBottom: true,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Handle save
          Navigator.of(context).pop();
        },
        backgroundColor: const Color(0xFFF5A623),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.check, color: Colors.white, size: 28),
      ),
    );
  }

  Widget _buildTextField({
    required String hint,
    required bool isPassword,
    required bool obscureText,
    required VoidCallback onVisibilityChanged,
    required IconData icon,
    bool isTop = false,
    bool isBottom = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(
        top: isTop ? 12.0 : 4.0,
        bottom: isBottom ? 12.0 : 4.0,
        left: 20.0,
        right: 8.0,
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFF5A623), size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: TextField(
              obscureText: obscureText,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(color: Colors.black38, fontSize: 16),
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              obscureText ? Icons.visibility_off : Icons.visibility,
              color: const Color(0xFFF5A623).withValues(alpha: 0.5),
            ),
            onPressed: onVisibilityChanged,
          ),
        ],
      ),
    );
  }
}
