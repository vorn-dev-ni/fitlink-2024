import 'package:intl/intl.dart';

class FormatterUtils {
  FormatterUtils._();

  /// Formats a number with commas as thousand separators.
  static String formatNumberWithCommas(int number) {
    return number.toString().replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (Match match) => '${match.group(1)},',
        );
  }

  static String removeJsonString(String input) {
    // Remove backticks and unwanted "json" if present
    return input
        .replaceAll(RegExp(r'```'), '')
        .replaceAll(RegExp(r'json'), '')
        .trim();
  }

  /// Formats a DateTime to a readable string (e.g., "Nov 22, 2024").
  static String formatDate(DateTime date) {
    return '${_monthNames[date.month - 1]} ${date.day}, ${date.year}';
  }

  /// Converts a duration to a formatted string (e.g., "02:30:15").
  static String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String hours = twoDigits(duration.inHours);
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$hours:$minutes:$seconds';
  }

  /// Capitalizes the first letter of a given string.
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return '${text[0].toUpperCase()}${text.substring(1)}';
  }

  /// Shortens a string to a specified length and adds ellipsis (e.g., "Hello Wo...").
  static String shortenWithEllipsis(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  /// Formats a double value to two decimal places.
  static String formatToTwoDecimalPlaces(double value) {
    return value.toStringAsFixed(2);
  }

  /// Formats a DateTime into a custom pattern (e.g., "22/11/2024").
  static String formatDateCustom(DateTime date, {String separator = '/'}) {
    return '${date.day.toString().padLeft(2, '0')}$separator${date.month.toString().padLeft(2, '0')}$separator${date.year}';
  }

  static String formatAppDateString(String dateString) {
    try {
      DateTime date = DateTime.parse(dateString);

      return DateFormat('MMM d, y').format(date);
    } catch (e) {
      return "Invalid date format";
    }
  }

  // Helper for month names
  static const List<String> _monthNames = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];
}
