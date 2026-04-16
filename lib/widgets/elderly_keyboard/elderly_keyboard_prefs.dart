import 'package:flutter/foundation.dart';

/// Global preference for the elderly keyboard feature.
/// Defaults to `true` (enabled by default for elderly users).
final ValueNotifier<bool> elderlyKeyboardEnabled = ValueNotifier<bool>(true);
