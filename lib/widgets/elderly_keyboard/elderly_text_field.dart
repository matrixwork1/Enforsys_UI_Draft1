import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'elderly_keyboard_prefs.dart';
import 'elderly_keyboard_scaffold.dart';

/// A drop-in replacement for [TextField] that integrates with the elderly
/// keyboard system. When the elderly keyboard preference is enabled, tapping
/// this field shows the custom large-button keyboard instead of the system one.
/// When disabled, it behaves exactly like a normal [TextField].
class ElderlyTextField extends StatefulWidget {
  final TextEditingController? controller;
  final InputDecoration? decoration;
  final TextStyle? style;
  final bool obscureText;
  final bool readOnly;
  final int? maxLines;
  final int? minLines;
  final TextCapitalization textCapitalization;
  final TextInputType? keyboardType;
  final TextAlignVertical? textAlignVertical;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;
  final FocusNode? focusNode;
  final bool autofocus;
  final bool enabled;
  final List<TextInputFormatter>? inputFormatters;
  final TextAlign textAlign;

  const ElderlyTextField({
    super.key,
    this.controller,
    this.decoration,
    this.style,
    this.obscureText = false,
    this.readOnly = false,
    this.maxLines = 1,
    this.minLines,
    this.textCapitalization = TextCapitalization.none,
    this.keyboardType,
    this.textAlignVertical,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.focusNode,
    this.autofocus = false,
    this.enabled = true,
    this.inputFormatters,
    this.textAlign = TextAlign.start,
  });

  @override
  State<ElderlyTextField> createState() => _ElderlyTextFieldState();
}

class _ElderlyTextFieldState extends State<ElderlyTextField> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _ownsController = false;
  bool _ownsFocusNode = false;

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      _controller = widget.controller!;
    } else {
      _controller = TextEditingController();
      _ownsController = true;
    }
    if (widget.focusNode != null) {
      _focusNode = widget.focusNode!;
    } else {
      _focusNode = FocusNode();
      _ownsFocusNode = true;
    }

    // Listen for text changes to forward to onChanged
    _controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    widget.onChanged?.call(_controller.text);
  }

  @override
  void didUpdateWidget(covariant ElderlyTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      if (_ownsController) {
        _controller.removeListener(_onTextChanged);
        _controller.dispose();
      }
      if (widget.controller != null) {
        _controller = widget.controller!;
        _ownsController = false;
      } else {
        _controller = TextEditingController();
        _ownsController = true;
      }
      _controller.addListener(_onTextChanged);
    }
    if (widget.focusNode != oldWidget.focusNode) {
      if (_ownsFocusNode) {
        _focusNode.dispose();
      }
      if (widget.focusNode != null) {
        _focusNode = widget.focusNode!;
        _ownsFocusNode = false;
      } else {
        _focusNode = FocusNode();
        _ownsFocusNode = true;
      }
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    if (_ownsController) {
      _controller.dispose();
    }
    if (_ownsFocusNode) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _onFieldTap() {
    widget.onTap?.call();

    if (!elderlyKeyboardEnabled.value || widget.readOnly) return;

    final keyboardController = ElderlyKeyboardScope.of(context);
    if (keyboardController != null) {
      keyboardController.showKeyboard(
        controller: _controller,
        focusNode: _focusNode,
        obscureText: widget.obscureText,
        textCapitalization: widget.textCapitalization,
        keyboardType: widget.keyboardType,
        fieldContext: context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: elderlyKeyboardEnabled,
      builder: (context, elderlyEnabled, _) {
        return TextField(
          controller: _controller,
          focusNode: _focusNode,
          decoration: widget.decoration,
          style: widget.style,
          obscureText: widget.obscureText,
          readOnly: elderlyEnabled ? true : widget.readOnly,
          maxLines: widget.maxLines,
          minLines: widget.minLines,
          textCapitalization: widget.textCapitalization,
          keyboardType: widget.keyboardType,
          textAlignVertical: widget.textAlignVertical,
          onSubmitted: widget.onSubmitted,
          onTap: _onFieldTap,
          autofocus: widget.autofocus,
          enabled: widget.enabled,
          inputFormatters: widget.inputFormatters,
          textAlign: widget.textAlign,
          showCursor: true,
        );
      },
    );
  }
}

/// A drop-in replacement for [TextFormField] that integrates with the elderly
/// keyboard system.
class ElderlyTextFormField extends StatefulWidget {
  final TextEditingController? controller;
  final String? initialValue;
  final InputDecoration? decoration;
  final TextStyle? style;
  final bool obscureText;
  final bool readOnly;
  final int? maxLines;
  final int? minLines;
  final TextCapitalization textCapitalization;
  final TextInputType? keyboardType;
  final TextAlignVertical? textAlignVertical;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;
  final FocusNode? focusNode;
  final bool autofocus;
  final bool enabled;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;

  const ElderlyTextFormField({
    super.key,
    this.controller,
    this.initialValue,
    this.decoration,
    this.style,
    this.obscureText = false,
    this.readOnly = false,
    this.maxLines = 1,
    this.minLines,
    this.textCapitalization = TextCapitalization.none,
    this.keyboardType,
    this.textAlignVertical,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.focusNode,
    this.autofocus = false,
    this.enabled = true,
    this.validator,
    this.inputFormatters,
  });

  @override
  State<ElderlyTextFormField> createState() => _ElderlyTextFormFieldState();
}

class _ElderlyTextFormFieldState extends State<ElderlyTextFormField> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _ownsController = false;
  bool _ownsFocusNode = false;

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      _controller = widget.controller!;
    } else {
      _controller = TextEditingController(text: widget.initialValue);
      _ownsController = true;
    }
    if (widget.focusNode != null) {
      _focusNode = widget.focusNode!;
    } else {
      _focusNode = FocusNode();
      _ownsFocusNode = true;
    }
  }

  @override
  void dispose() {
    if (_ownsController) _controller.dispose();
    if (_ownsFocusNode) _focusNode.dispose();
    super.dispose();
  }

  void _onFieldTap() {
    widget.onTap?.call();

    if (!elderlyKeyboardEnabled.value || widget.readOnly) return;

    final keyboardController = ElderlyKeyboardScope.of(context);
    if (keyboardController != null) {
      keyboardController.showKeyboard(
        controller: _controller,
        focusNode: _focusNode,
        obscureText: widget.obscureText,
        textCapitalization: widget.textCapitalization,
        keyboardType: widget.keyboardType,
        fieldContext: context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: elderlyKeyboardEnabled,
      builder: (context, elderlyEnabled, _) {
        return TextFormField(
          controller: _controller,
          focusNode: _focusNode,
          decoration: widget.decoration,
          style: widget.style,
          obscureText: widget.obscureText,
          readOnly: elderlyEnabled ? true : widget.readOnly,
          maxLines: widget.maxLines,
          minLines: widget.minLines,
          textCapitalization: widget.textCapitalization,
          keyboardType: widget.keyboardType,
          textAlignVertical: widget.textAlignVertical,
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onSubmitted,
          onTap: _onFieldTap,
          autofocus: widget.autofocus,
          enabled: widget.enabled,
          validator: widget.validator,
          inputFormatters: widget.inputFormatters,
          showCursor: true,
        );
      },
    );
  }
}
