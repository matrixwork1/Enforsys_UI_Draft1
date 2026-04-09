import 'package:flutter/material.dart';
import 'dart:async';
import 'elderly_keyboard_scaffold.dart';

/// A custom on-screen keyboard with large circular buttons designed for elderly
/// users. Uses a staggered 5-column grid layout for maximum readability and
/// touch-friendliness, inspired by accessibility keyboard designs.
class ElderlyKeyboard extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onDone;
  final bool obscureText;
  final TextCapitalization textCapitalization;
  final TextInputType? keyboardType;

  const ElderlyKeyboard({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onDone,
    this.obscureText = false,
    this.textCapitalization = TextCapitalization.none,
    this.keyboardType,
  });

  @override
  State<ElderlyKeyboard> createState() => _ElderlyKeyboardState();
}

class _ElderlyKeyboardState extends State<ElderlyKeyboard> {
  bool _isShifted = true; // Start with shift on (capital first letter)
  bool _isCapsLock = false;
  // 0 = letters, 1 = numbers/symbols, 2 = extended symbols
  int _layoutMode = 0;
  Timer? _backspaceTimer;

  // Accent color matching the app theme
  static const Color _accent = Color(0xFFF5A623);

  void _setLayoutMode(int mode) {
    setState(() {
      _layoutMode = mode;
    });
    // Notify scaffold for dynamic height
    ElderlyKeyboardScope.of(context)?.setNumberMode(mode > 0);
  }

  // Staggered 5-column QWERTY layout (letter pairs per visual row)
  // Row pairs are offset to create a honeycomb-like pattern
  static const List<String> _letterRow1 = ['Q', 'E', 'T', 'U', 'O'];
  static const List<String> _letterRow2 = ['W', 'R', 'Y', 'I', 'P'];
  static const List<String> _letterRow3 = ['A', 'D', 'G', 'J', 'L'];
  static const List<String> _letterRow4 = ['S', 'F', 'H', 'K'];
  static const List<String> _letterRow5 = ['Z', 'C', 'B', 'M'];
  static const List<String> _letterRow6 = ['X', 'V', 'N'];

  // Number/symbol layout (staggered 5-column)
  static const List<String> _numRow1 = ['1', '2', '3', '4', '5'];
  static const List<String> _numRow2 = ['6', '7', '8', '9', '0'];
  static const List<String> _numRow3 = ['@', '#', '\$', '%', '&'];
  static const List<String> _numRow4 = ['-', '+', '(', ')'];
  static const List<String> _numRow5 = ['*', '"', "'", '!'];
  static const List<String> _numRow6 = [':', ';', '/'];

  // Extended symbols layout
  static const List<String> _extRow1 = ['~', '`', '|', '•', '√'];
  static const List<String> _extRow2 = ['π', '÷', '×', '§', '∆'];
  static const List<String> _extRow3 = ['£', '¢', '€', '¥', '^'];
  static const List<String> _extRow4 = ['°', '=', '{', '}'];
  static const List<String> _extRow5 = ['\\', '©', '®', '™'];
  static const List<String> _extRow6 = ['✓', '[', ']'];

  void _insertCharacter(String char) {
    final text = widget.controller.text;
    final selection = widget.controller.selection;

    String charToInsert = char;

    // Only handle capitalization for letters
    if (RegExp(r'[a-zA-Z]').hasMatch(char)) {
      if (_isShifted || _isCapsLock) {
        charToInsert = char.toUpperCase();
      } else {
        charToInsert = char.toLowerCase();
      }
      if (widget.textCapitalization == TextCapitalization.characters) {
        charToInsert = charToInsert.toUpperCase();
      }
    }

    if (selection.isValid && selection.start >= 0) {
      final newText = text.replaceRange(selection.start, selection.end, charToInsert);
      widget.controller.value = TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(offset: selection.start + charToInsert.length),
      );
    } else {
      widget.controller.value = TextEditingValue(
        text: text + charToInsert,
        selection: TextSelection.collapsed(offset: text.length + charToInsert.length),
      );
    }

    // Turn off shift after one character (unless caps lock)
    if (_isShifted && !_isCapsLock) {
      setState(() => _isShifted = false);
    }
  }

  void _handleBackspace() {
    final text = widget.controller.text;
    final selection = widget.controller.selection;

    if (selection.isValid && selection.start > 0) {
      if (selection.start == selection.end) {
        final newText = text.replaceRange(selection.start - 1, selection.start, '');
        widget.controller.value = TextEditingValue(
          text: newText,
          selection: TextSelection.collapsed(offset: selection.start - 1),
        );
      } else {
        final newText = text.replaceRange(selection.start, selection.end, '');
        widget.controller.value = TextEditingValue(
          text: newText,
          selection: TextSelection.collapsed(offset: selection.start),
        );
      }
    } else if (text.isNotEmpty && (!selection.isValid || selection.start < 0)) {
      widget.controller.value = TextEditingValue(
        text: text.substring(0, text.length - 1),
        selection: TextSelection.collapsed(offset: text.length - 1),
      );
    }
  }

  void _startBackspaceRepeat() {
    _handleBackspace();
    _backspaceTimer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      _handleBackspace();
    });
  }

  void _stopBackspaceRepeat() {
    _backspaceTimer?.cancel();
    _backspaceTimer = null;
  }

  @override
  void dispose() {
    _backspaceTimer?.cancel();
    super.dispose();
  }

  // ─── Key size calculations ────────────────────────────────────────────
  double _letterKeySize(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    // Calculate key size assuming a reasonable target hGap of 16.0
    return ((screenWidth - 24 - (4.5 * 16.0)) / 5.5).clamp(42.0, 46.0);
  }

  double _symbolKeySize(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return ((screenWidth - 24 - (4.5 * 16.0)) / 5.5).clamp(44.0, 50.0);
  }

  double _calculateHGap(BuildContext context, double ks) {
    final screenWidth = MediaQuery.of(context).size.width;
    // Distribute remaining width into 4.5 gaps so the layout exactly touches the horizontal padding
    return ((screenWidth - 24 - (5.5 * ks)) / 4.5).clamp(8.0, 32.0);
  }

  double _offset(double ks, double hGap) {
    return (ks + hGap) / 2; // half a key + half a gap for stagger offset
  }

  // ─── BUILD ────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFE8EAED),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea( // Adds bottom padding automatically
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 6, 12, 2),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: _layoutMode == 0
                ? _buildLetterLayout(context)
                : _layoutMode == 1
                    ? _buildNumberLayout(context)
                    : _buildExtendedLayout(context),
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  //  LETTER LAYOUT
  // ═══════════════════════════════════════════════════════════════════════
  List<Widget> _buildLetterLayout(BuildContext context) {
    final ks = _letterKeySize(context);
    final hGap = _calculateHGap(context, ks);
    final off = _offset(ks, hGap);
    const vGap = 4.0; // Very tight vertical packing to resolve height layout overflow

    return [
      // Top number rows (Row 0 and Row 0.5)
      _buildStaggeredRow(['1', '2', '3', '4', '5'], ks, hGap, offset: 0),
      SizedBox(height: vGap),
      _buildStaggeredRow(['6', '7', '8', '9', '0'], ks, hGap, offset: off),
      SizedBox(height: vGap),
      // Row 1: Q E T U O (aligned left)
      _buildStaggeredRow(_letterRow1, ks, hGap, offset: 0),
      SizedBox(height: vGap),
      // Row 2: W R Y I P (offset right)
      _buildStaggeredRow(_letterRow2, ks, hGap, offset: off),
      SizedBox(height: vGap),
      // Row 3: A D G J L (aligned left)
      _buildStaggeredRow(_letterRow3, ks, hGap, offset: 0),
      SizedBox(height: vGap),
      // Row 4: S F H K + emoji/period (offset right)
      _buildRow4Letters(ks, hGap, off),
      SizedBox(height: vGap),
      // Row 5: Z C B M + backspace (aligned left)
      _buildRow5Letters(ks, hGap),
      SizedBox(height: vGap),
      // Row 6: X V N + . + 123 (offset right)
      _buildRow6Letters(ks, hGap, off),
      SizedBox(height: vGap),
      // Bottom row: shift, space, done
      _buildBottomRow(ks, hGap),
    ];
  }

  Widget _buildStaggeredRow(List<String> keys, double ks, double gap, {double offset = 0}) {
    return Padding(
      padding: EdgeInsets.only(left: offset),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: keys.asMap().entries.map((e) {
          final key = e.value;
          final displayKey = (_isShifted || _isCapsLock) ? key.toUpperCase() : key.toLowerCase();
          return Padding(
            padding: EdgeInsets.only(right: e.key < keys.length - 1 ? gap : 0),
            child: _buildCircleKey(
              label: displayKey,
              size: ks,
              onTap: () => _insertCharacter(key),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildRow4Letters(double ks, double gap, double off) {
    return Padding(
      padding: EdgeInsets.only(left: off),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ..._letterRow4.asMap().entries.map((e) {
            final key = e.value;
            final displayKey = (_isShifted || _isCapsLock) ? key.toUpperCase() : key.toLowerCase();
            return Padding(
              padding: EdgeInsets.only(right: gap),
              child: _buildCircleKey(
                label: displayKey,
                size: ks,
                onTap: () => _insertCharacter(key),
              ),
            );
          }),
          // Period/dot key in accent circle
          _buildCircleKey(
            label: '.',
            size: ks,
            onTap: () => _insertCharacter('.'),
            backgroundColor: _accent,
            textColor: Colors.white,
            fontSize: 22,
          ),
        ],
      ),
    );
  }

  Widget _buildRow5Letters(double ks, double gap) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ..._letterRow5.asMap().entries.map((e) {
          final key = e.value;
          final displayKey = (_isShifted || _isCapsLock) ? key.toUpperCase() : key.toLowerCase();
          return Padding(
            padding: EdgeInsets.only(right: gap),
            child: _buildCircleKey(
              label: displayKey,
              size: ks,
              onTap: () => _insertCharacter(key),
            ),
          );
        }),
        // Backspace key
        GestureDetector(
          onLongPressStart: (_) => _startBackspaceRepeat(),
          onLongPressEnd: (_) => _stopBackspaceRepeat(),
          child: _buildCircleKey(
            icon: Icons.backspace_outlined,
            size: ks,
            onTap: _handleBackspace,
            backgroundColor: _accent,
            iconColor: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildRow6Letters(double ks, double gap, double off) {
    return Padding(
      padding: EdgeInsets.only(left: off),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ..._letterRow6.asMap().entries.map((e) {
            final key = e.value;
            final displayKey = (_isShifted || _isCapsLock) ? key.toUpperCase() : key.toLowerCase();
            return Padding(
              padding: EdgeInsets.only(right: gap),
              child: _buildCircleKey(
                label: displayKey,
                size: ks,
                onTap: () => _insertCharacter(key),
              ),
            );
          }),
          // Comma key
          Padding(
            padding: EdgeInsets.only(right: gap),
            child: _buildCircleKey(
              label: ',',
              size: ks,
              onTap: () => _insertCharacter(','),
            ),
          ),
          // 123 toggle
          _buildCircleKey(
            label: '123',
            size: ks,
            onTap: () => _setLayoutMode(1),
            backgroundColor: _accent,
            textColor: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w800,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomRow(double ks, double gap) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
          // Shift key
          _buildCircleKey(
            icon: _isCapsLock ? Icons.keyboard_capslock : Icons.arrow_upward_rounded,
            size: ks,
            onTap: () {
              setState(() {
                if (_isCapsLock) {
                  _isCapsLock = false;
                  _isShifted = false;
                } else if (_isShifted) {
                  _isCapsLock = true;
                } else {
                  _isShifted = true;
                }
              });
            },
            backgroundColor: (_isShifted || _isCapsLock) ? _accent : Colors.white,
            iconColor: (_isShifted || _isCapsLock) ? Colors.white : const Color(0xFF555555),
            hasBorder: !(_isShifted || _isCapsLock),
          ),
          SizedBox(width: gap),
          // Space bar
          _buildSpaceBar(ks, width: (3.5 * ks) + (2.5 * gap)),
          SizedBox(width: gap),
          // Done / Enter button
          _buildCircleKey(
            label: 'Done',
            fontSize: ks * 0.28,
            size: ks,
            onTap: widget.onDone,
            backgroundColor: _accent,
            textColor: Colors.white,
          ),
        ],
    );
  }

  Widget _buildSpaceBar(double height, {required double width}) {
    return _AnimatedKey(
      onTap: () => _insertCharacter(' '),
      width: width,
      height: height,
      backgroundColor: Colors.white,
      isCircle: false,
      hasBorder: true,
      accentColor: _accent,
      child: Container(
        width: 48,
        height: 4,
        decoration: BoxDecoration(
          color: _accent.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  //  NUMBER / SYMBOL LAYOUT
  // ═══════════════════════════════════════════════════════════════════════
  List<Widget> _buildNumberLayout(BuildContext context) {
    final ks = _symbolKeySize(context);
    final hGap = _calculateHGap(context, ks);
    final off = _offset(ks, hGap);
    const vGap = 4.0;

    return [
      _buildSymbolRow(_numRow1, ks, hGap, offset: 0),
      SizedBox(height: vGap),
      _buildSymbolRow(_numRow2, ks, hGap, offset: off),
      SizedBox(height: vGap),
      _buildSymbolRow(_numRow3, ks, hGap, offset: 0),
      SizedBox(height: vGap),
      _buildNumRow4Symbols(ks, hGap, off),
      SizedBox(height: vGap),
      _buildNumRow5Symbols(ks, hGap),
      SizedBox(height: vGap),
      _buildNumRow6Symbols(ks, hGap, off),
      SizedBox(height: vGap),
      _buildBottomRowNum(ks, hGap),
    ];
  }

  Widget _buildSymbolRow(List<String> keys, double ks, double gap, {double offset = 0}) {
    return Padding(
      padding: EdgeInsets.only(left: offset),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: keys.asMap().entries.map((e) {
          final key = e.value;
          return Padding(
            padding: EdgeInsets.only(right: e.key < keys.length - 1 ? gap : 0),
            child: _buildCircleKey(
              label: key,
              size: ks,
              onTap: () => _insertCharacter(key),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildNumRow4Symbols(double ks, double gap, double off) {
    return Padding(
      padding: EdgeInsets.only(left: off),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ..._numRow4.asMap().entries.map((e) {
            return Padding(
              padding: EdgeInsets.only(right: gap),
              child: _buildCircleKey(
                label: e.value,
                size: ks,
                onTap: () => _insertCharacter(e.value),
              ),
            );
          }),
          _buildCircleKey(
            label: '?',
            size: ks,
            onTap: () => _insertCharacter('?'),
            backgroundColor: _accent,
            textColor: Colors.white,
            fontSize: 24,
          ),
        ],
      ),
    );
  }

  Widget _buildNumRow5Symbols(double ks, double gap) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ..._numRow5.asMap().entries.map((e) {
          return Padding(
            padding: EdgeInsets.only(right: gap),
            child: _buildCircleKey(
              label: e.value,
              size: ks,
              onTap: () => _insertCharacter(e.value),
            ),
          );
        }),
        // Backspace
        GestureDetector(
          onLongPressStart: (_) => _startBackspaceRepeat(),
          onLongPressEnd: (_) => _stopBackspaceRepeat(),
          child: _buildCircleKey(
            icon: Icons.backspace_outlined,
            size: ks,
            onTap: _handleBackspace,
            backgroundColor: _accent,
            iconColor: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildNumRow6Symbols(double ks, double gap, double off) {
    return Padding(
      padding: EdgeInsets.only(left: off),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ..._numRow6.asMap().entries.map((e) {
            return Padding(
              padding: EdgeInsets.only(right: gap),
              child: _buildCircleKey(
                label: e.value,
                size: ks,
                onTap: () => _insertCharacter(e.value),
              ),
            );
          }),
          Padding(
            padding: EdgeInsets.only(right: gap),
            child: _buildCircleKey(
              label: '.',
              size: ks,
              onTap: () => _insertCharacter('.'),
            ),
          ),
          // ABC toggle
          _buildCircleKey(
            label: 'ABC',
            size: ks,
            onTap: () => _setLayoutMode(0),
            backgroundColor: _accent,
            textColor: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomRowNum(double ks, double gap) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
          // #+= key — opens extended symbols
          _buildCircleKey(
            label: '#+=',
            size: ks,
            onTap: () => _setLayoutMode(2),
            backgroundColor: Colors.white,
            textColor: const Color(0xFF555555),
            fontSize: 14,
            fontWeight: FontWeight.w700,
            hasBorder: true,
          ),
          SizedBox(width: gap),
          // Space bar
          _buildSpaceBar(ks, width: (3.5 * ks) + (2.5 * gap)),
          SizedBox(width: gap),
          // Done / Enter button
          _buildCircleKey(
            label: 'Done',
            fontSize: ks * 0.28,
            size: ks,
            onTap: widget.onDone,
            backgroundColor: _accent,
            textColor: Colors.white,
          ),
        ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  //  EXTENDED SYMBOLS LAYOUT
  // ═══════════════════════════════════════════════════════════════════════
  List<Widget> _buildExtendedLayout(BuildContext context) {
    final ks = _symbolKeySize(context);
    final hGap = _calculateHGap(context, ks);
    final off = _offset(ks, hGap);
    const vGap = 4.0;

    return [
      _buildSymbolRow(_extRow1, ks, hGap, offset: 0),
      SizedBox(height: vGap),
      _buildSymbolRow(_extRow2, ks, hGap, offset: off),
      SizedBox(height: vGap),
      _buildSymbolRow(_extRow3, ks, hGap, offset: 0),
      SizedBox(height: vGap),
      _buildExtRow4(ks, hGap, off),
      SizedBox(height: vGap),
      _buildExtRow5(ks, hGap),
      SizedBox(height: vGap),
      _buildExtRow6(ks, hGap, off),
      SizedBox(height: vGap),
      _buildBottomRowExt(ks, hGap),
    ];
  }

  Widget _buildExtRow4(double ks, double gap, double off) {
    return Padding(
      padding: EdgeInsets.only(left: off),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ..._extRow4.asMap().entries.map((e) {
            return Padding(
              padding: EdgeInsets.only(right: gap),
              child: _buildCircleKey(
                label: e.value,
                size: ks,
                onTap: () => _insertCharacter(e.value),
              ),
            );
          }),
          _buildCircleKey(
            label: '<',
            size: ks,
            onTap: () => _insertCharacter('<'),
            backgroundColor: _accent,
            textColor: Colors.white,
            fontSize: 24,
          ),
        ],
      ),
    );
  }

  Widget _buildExtRow5(double ks, double gap) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ..._extRow5.asMap().entries.map((e) {
          return Padding(
            padding: EdgeInsets.only(right: gap),
            child: _buildCircleKey(
              label: e.value,
              size: ks,
              onTap: () => _insertCharacter(e.value),
            ),
          );
        }),
        // Backspace
        GestureDetector(
          onLongPressStart: (_) => _startBackspaceRepeat(),
          onLongPressEnd: (_) => _stopBackspaceRepeat(),
          child: _buildCircleKey(
            icon: Icons.backspace_outlined,
            size: ks,
            onTap: _handleBackspace,
            backgroundColor: _accent,
            iconColor: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildExtRow6(double ks, double gap, double off) {
    return Padding(
      padding: EdgeInsets.only(left: off),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ..._extRow6.asMap().entries.map((e) {
            return Padding(
              padding: EdgeInsets.only(right: gap),
              child: _buildCircleKey(
                label: e.value,
                size: ks,
                onTap: () => _insertCharacter(e.value),
              ),
            );
          }),
          Padding(
            padding: EdgeInsets.only(right: gap),
            child: _buildCircleKey(
              label: '>',
              size: ks,
              onTap: () => _insertCharacter('>'),
            ),
          ),
          // ABC toggle
          _buildCircleKey(
            label: 'ABC',
            size: ks,
            onTap: () => _setLayoutMode(0),
            backgroundColor: _accent,
            textColor: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomRowExt(double ks, double gap) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
          // 123 key — go back to basic symbols
          _buildCircleKey(
            label: '123',
            size: ks,
            onTap: () => _setLayoutMode(1),
            backgroundColor: Colors.white,
            textColor: const Color(0xFF555555),
            fontSize: 14,
            fontWeight: FontWeight.w700,
            hasBorder: true,
          ),
          SizedBox(width: gap),
          // Space bar
          _buildSpaceBar(ks, width: (3.5 * ks) + (2.5 * gap)),
          SizedBox(width: gap),
          // Done / Enter button
          _buildCircleKey(
            label: 'Done',
            fontSize: ks * 0.28,
            size: ks,
            onTap: widget.onDone,
            backgroundColor: _accent,
            textColor: Colors.white,
          ),
        ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  //  CIRCLE KEY BUILDER
  // ═══════════════════════════════════════════════════════════════════════
  Widget _buildCircleKey({
    String? label,
    IconData? icon,
    required double size,
    required VoidCallback onTap,
    Color backgroundColor = Colors.white,
    Color textColor = const Color(0xFF1F2937),
    Color iconColor = const Color(0xFF1F2937),
    double fontSize = 20,
    FontWeight fontWeight = FontWeight.w700,
    bool hasBorder = false,
  }) {
    return _AnimatedKey(
      onTap: onTap,
      width: size,
      height: size,
      backgroundColor: backgroundColor,
      isCircle: true,
      hasBorder: hasBorder,
      accentColor: _accent,
      child: icon != null
          ? Icon(icon, size: size * 0.4, color: iconColor)
          : Text(
              label ?? '',
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: fontWeight,
                color: textColor,
              ),
            ),
    );
  }
}

class _AnimatedKey extends StatefulWidget {
  final VoidCallback onTap;
  final double width;
  final double height;
  final Color backgroundColor;
  final Widget child;
  final bool isCircle;
  final bool hasBorder;
  final Color accentColor;

  const _AnimatedKey({
    required this.onTap,
    required this.width,
    required this.height,
    required this.backgroundColor,
    required this.child,
    required this.isCircle,
    required this.hasBorder,
    required this.accentColor,
  });

  @override
  State<_AnimatedKey> createState() => _AnimatedKeyState();
}

class _AnimatedKeyState extends State<_AnimatedKey> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    // For spacebar, rounded rectangle radius is also height/2 to match circles
    final borderRadius = widget.height / 2;
    final isAccent = widget.backgroundColor == widget.accentColor;

    return AnimatedScale(
      scale: _isPressed ? 0.90 : 1.0,
      duration: const Duration(milliseconds: 60),
      curve: Curves.easeOutQuad,
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          borderRadius: widget.isCircle ? null : BorderRadius.circular(borderRadius),
          shape: widget.isCircle ? BoxShape.circle : BoxShape.rectangle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: widget.backgroundColor,
          clipBehavior: Clip.hardEdge,
          shape: widget.isCircle
              ? CircleBorder(side: widget.hasBorder ? const BorderSide(color: Color(0xFFCBCFD4), width: 1.5) : BorderSide.none)
              : RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                  side: widget.hasBorder ? const BorderSide(color: Color(0xFFD1D5DB), width: 1.5) : BorderSide.none,
                ),
          child: InkWell(
            onTap: widget.onTap,
            onHighlightChanged: (val) {
              setState(() {
                _isPressed = val;
              });
            },
            // If the key is already yellow (_accent), use white ripple so it's clearly visible
            splashColor: isAccent 
                ? Colors.white.withValues(alpha: 0.3) 
                : widget.accentColor.withValues(alpha: 0.35),
            highlightColor: isAccent 
                ? Colors.white.withValues(alpha: 0.1) 
                : widget.accentColor.withValues(alpha: 0.15),
            child: Center(child: widget.child),
          ),
        ),
      ),
    );
  }
}
