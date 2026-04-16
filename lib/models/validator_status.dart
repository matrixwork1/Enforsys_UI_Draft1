/// Status types for validator results.
/// Extracted from validator_result_popup.dart to eliminate circular imports
/// and allow reuse across car_plate_recognizer, recognized_plates_popup,
/// validator_record_screen, etc.
enum ValidatorStatus {
  activeUserCoupon,
  activeSeasonPass,
  noPermitFound,
  compoundIssued,
  opnFound,
}
