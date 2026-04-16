import 'validator_status.dart';

/// Data model for a recognized plate entry.
/// Extracted from recognized_plates_popup.dart.
class RecognizedPlateEntry {
  final String plate;
  final ValidatorStatus status;

  const RecognizedPlateEntry({
    required this.plate,
    required this.status,
  });
}
