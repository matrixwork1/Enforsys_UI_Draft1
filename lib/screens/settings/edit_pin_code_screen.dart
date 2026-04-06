import 'package:flutter/material.dart';

class EditPinCodeScreen extends StatefulWidget {
  const EditPinCodeScreen({super.key});

  @override
  State<EditPinCodeScreen> createState() => _EditPinCodeScreenState();
}

class _EditPinCodeScreenState extends State<EditPinCodeScreen> {
  final TextEditingController _pinController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isSettingNew = false; // toggles between Edit and Set modes

  @override
  void dispose() {
    _pinController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onValidate() {
    if (_pinController.text.length == 6) {
      if (!_isSettingNew) {
        // currently in edit/verify mode
        setState(() {
          _isSettingNew = true;
          _pinController.clear();
        });
      } else {
        // currently in set mode
        Navigator.of(context).pop();
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a 6-digit PIN')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Off-white background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFF5A623)),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 48),
              // Top Icon
              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  color: const Color(0xFFF5A623),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFF5A623).withValues(alpha: 0.3),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    )
                  ],
                ),
                child: const Center(
                  child: Icon(
                    Icons.mobile_friendly, // proxy icon for the lock on mobile screen
                    size: 72,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 48),
              Text(
                _isSettingNew ? 'Set your pin code' : 'Edit your pin code',
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                _isSettingNew
                    ? 'Please create a 6-digit PIN for quick\nand secure access.'
                    : 'Enter your current pin code',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 48),
              // PIN Input field
              _buildPinInput(),
              const SizedBox(height: 48),
              // Action Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _onValidate,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF5A623),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 6,
                    shadowColor: const Color(0xFFF5A623).withValues(alpha: 0.5),
                  ),
                  child: Text(
                    _isSettingNew ? 'SET' : 'VERIFY',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Forgot PIN
              if (!_isSettingNew)
                TextButton(
                  onPressed: () {
                    // handle forgot pin
                  },
                  child: const Text(
                    'Forgot PIN?',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.blueGrey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPinInput() {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(_focusNode);
      },
      child: Stack(
        children: [
          // Hidden TextField
          Opacity(
            opacity: 0.0,
            child: TextField(
              controller: _pinController,
              focusNode: _focusNode,
              keyboardType: TextInputType.number,
              maxLength: 6,
              onChanged: (val) {
                setState(() {}); // trigger rebuild to update pin display
              },
            ),
          ),
          // Visible UI
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(6, (index) {
              final pinLength = _pinController.text.length;
              final isFocused = _focusNode.hasFocus && index == pinLength;
              final hasContent = index < pinLength;

              Color bottomColor = Colors.grey.shade400;
              if (hasContent) {
                bottomColor = Colors.redAccent;
              } else if (isFocused) {
                bottomColor = Colors.blueAccent;
              }

              return Container(
                width: 45,
                height: 55,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  border: Border(
                    bottom: BorderSide(
                      color: bottomColor,
                      width: 2.0,
                    ),
                  ),
                ),
                child: Center(
                  child: Text(
                    hasContent ? _pinController.text[index] : (isFocused ? '|' : ''),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: isFocused && !hasContent ? Colors.black38 : Colors.black87,
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
