import 'validator_status.dart';

/// Data model for a validator result.
/// Extracted from validator_result_popup.dart.
class ValidatorResultData {
  final String plate;
  final String parkingArea;
  final String checkedAt;
  final String imageUrl;
  final ValidatorStatus status;

  const ValidatorResultData({
    required this.plate,
    required this.parkingArea,
    required this.checkedAt,
    required this.imageUrl,
    required this.status,
  });
}
