import 'package:flutter/material.dart';
import 'elderly_keyboard.dart';
import 'elderly_keyboard_prefs.dart';

/// An InheritedWidget that provides elderly keyboard controller access
/// to all descendants.
class ElderlyKeyboardScope extends InheritedWidget {
  final ElderlyKeyboardController controller;

  const ElderlyKeyboardScope({
    super.key,
    required this.controller,
    required super.child,
  });

  static ElderlyKeyboardController? of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<ElderlyKeyboardScope>();
    return scope?.controller;
  }

  @override
  bool updateShouldNotify(covariant ElderlyKeyboardScope oldWidget) {
    return controller != oldWidget.controller;
  }
}

/// Controller that manages showing/hiding the elderly keyboard overlay.
class ElderlyKeyboardController extends ChangeNotifier {
  TextEditingController? _activeController;
  FocusNode? _activeFocusNode;
  bool _isKeyboardVisible = false;
  bool _obscureText = false;
  TextCapitalization _textCapitalization = TextCapitalization.none;
  TextInputType? _keyboardType;

  bool get isKeyboardVisible => _isKeyboardVisible;
  TextEditingController? get activeController => _activeController;
  FocusNode? get activeFocusNode => _activeFocusNode;
  bool get obscureText => _obscureText;
  TextCapitalization get textCapitalization => _textCapitalization;
  TextInputType? get keyboardType => _keyboardType;

  // Track the current layout mode so the scaffold can dynamically adjust height
  bool _isNumberMode = false;
  bool get isNumberMode => _isNumberMode;

  void setNumberMode(bool value) {
    if (_isNumberMode != value) {
      _isNumberMode = value;
      notifyListeners();
    }
  }

  // Track the BuildContext of the active field for scroll-into-view
  BuildContext? _activeFieldContext;
  BuildContext? get activeFieldContext => _activeFieldContext;

  void showKeyboard({
    required TextEditingController controller,
    required FocusNode focusNode,
    bool obscureText = false,
    TextCapitalization textCapitalization = TextCapitalization.none,
    TextInputType? keyboardType,
    BuildContext? fieldContext,
  }) {
    if (_activeFocusNode != focusNode) {
      _activeFocusNode?.removeListener(_onFocusChanged);
      _activeFocusNode = focusNode;
      _activeFocusNode!.addListener(_onFocusChanged);
    }
    _activeController = controller;
    _obscureText = obscureText;
    _textCapitalization = textCapitalization;
    _keyboardType = keyboardType;
    _activeFieldContext = fieldContext;
    _isKeyboardVisible = true;
    notifyListeners();
  }

  void _onFocusChanged() {
    if (_activeFocusNode != null && !_activeFocusNode!.hasFocus) {
      hideKeyboard();
    }
  }

  void hideKeyboard() {
    _isKeyboardVisible = false;
    _activeFocusNode?.removeListener(_onFocusChanged);
    _activeFocusNode?.unfocus();
    _activeController = null;
    _activeFocusNode = null;
    _activeFieldContext = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _activeFocusNode?.removeListener(_onFocusChanged);
    super.dispose();
  }
}

/// Wraps a Scaffold to provide the elderly keyboard overlay.
/// Place this at the app level (around MaterialApp or at each screen).
class ElderlyKeyboardScaffold extends StatefulWidget {
  final Widget child;

  const ElderlyKeyboardScaffold({
    super.key,
    required this.child,
  });

  @override
  State<ElderlyKeyboardScaffold> createState() => _ElderlyKeyboardScaffoldState();
}

class _ElderlyKeyboardScaffoldState extends State<ElderlyKeyboardScaffold>
    with SingleTickerProviderStateMixin {
  final ElderlyKeyboardController _controller = ElderlyKeyboardController();
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    _controller.addListener(_onControllerChanged);
  }

  void _onControllerChanged() {
    if (_controller.isKeyboardVisible) {
      _animationController.forward().then((_) {
        // Wait until the final geometry is fully applied from the animation
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && _controller.isKeyboardVisible) {
            _scrollActiveFieldIntoView();
          }
        });
      });
    } else {
      _animationController.reverse();
    }
    // Trigger rebuild
    if (mounted) setState(() {});
  }

  void _scrollActiveFieldIntoView() {
    final fieldContext = _controller.activeFieldContext;
    if (fieldContext != null && fieldContext.mounted) {
      Scrollable.ensureVisible(
        fieldContext,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        alignmentPolicy: ScrollPositionAlignmentPolicy.keepVisibleAtEnd,
      );
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerChanged);
    _controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  double _calculateKeyboardHeight(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    const vGap = 4.0; // matching keyboard vGap

    if (_controller.isNumberMode) {
      // Symbol layouts: 7 rows at symbol key size
      final ks = ((screenWidth - 24 - (4.5 * 16.0)) / 5.5).clamp(44.0, 50.0);
      return (7 * ks) + (6 * vGap) + 8.0 + bottomPadding; // 8.0 padding total
    } else {
      // Letter layout: 9 rows at letter key size
      final ks = ((screenWidth - 24 - (4.5 * 16.0)) / 5.5).clamp(42.0, 46.0);
      return (9 * ks) + (8 * vGap) + 8.0 + bottomPadding;
    }
  }

  @override
  Widget build(BuildContext context) {
    final exactHeight = _calculateKeyboardHeight(context);

    return ElderlyKeyboardScope(
      controller: _controller,
      child: Stack(
        children: [
          // Main content — inject bottom inset so app Scaffolds gracefully resize
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, childBuilder) {
                final currentHeight = exactHeight * _animationController.value;
                final mediaQuery = MediaQuery.of(context);
                return MediaQuery(
                  data: mediaQuery.copyWith(
                    viewInsets: mediaQuery.viewInsets.copyWith(
                      bottom: mediaQuery.viewInsets.bottom + currentHeight,
                    ),
                  ),
                  child: childBuilder!,
                );
              },
              child: widget.child,
            ),
          ),
          // Keyboard overlay
          if (_controller.isKeyboardVisible && _controller.activeController != null)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: SlideTransition(
                position: _slideAnimation,
                child: ValueListenableBuilder<bool>(
                  valueListenable: elderlyKeyboardEnabled,
                  builder: (context, enabled, _) {
                    if (!enabled) {
                      // If disabled mid-session, hide
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _controller.hideKeyboard();
                      });
                      return const SizedBox.shrink();
                    }
                    return ElderlyKeyboard(
                      controller: _controller.activeController!,
                      focusNode: _controller.activeFocusNode!,
                      obscureText: _controller.obscureText,
                      textCapitalization: _controller.textCapitalization,
                      keyboardType: _controller.keyboardType,
                      onDone: () {
                        _controller.hideKeyboard();
                      },
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}
