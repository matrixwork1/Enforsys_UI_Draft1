/// Shared date/time formatting utilities used across the app.
/// Consolidates duplicated timestamp formatting from multiple screens.
class DateFormatUtils {
  DateFormatUtils._();

  /// Returns a human-readable timestamp like "2026-04-16, 08:30 AM".
  /// Used by car_plate_recognizer_screen and create_opn_popup.
  static String currentTimestamp() {
    final now = DateTime.now();
    final hour = now.hour > 12
        ? now.hour - 12
        : (now.hour == 0 ? 12 : now.hour);
    final period = now.hour >= 12 ? 'PM' : 'AM';
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}, '
        '${hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')} $period';
  }

  /// Returns a short date like "2026-04-16".
  /// Used by offence_list_screen and opn_history_screen.
  static String formatDateShort(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  /// Returns a friendly date like "Apr 16, 2026".
  /// Used by car_plate_enquiry_screen.
  static String formatDateFriendly(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[date.month - 1]} ${date.day.toString().padLeft(2, '0')}, ${date.year}';
  }
}
