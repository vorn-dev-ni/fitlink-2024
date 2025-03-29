import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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

  static bool isDifferentDay(DateTime currentDate, DateTime previousDate) {
    return currentDate.year != previousDate.year ||
        currentDate.month != previousDate.month ||
        currentDate.day != previousDate.day;
  }

  static bool isTimeDifferenceSignificant(
      DateTime currentDate, DateTime previousDate) {
    final difference = currentDate.difference(previousDate).inMinutes;

    debugPrint('diff $difference'); // Debugging the time difference

    if (difference < 10) {
      return false;
    }

    return currentDate.year != previousDate.year ||
        currentDate.month != previousDate.month ||
        currentDate.day != previousDate.day;
  }

  static String formatChatTimeStamp(Timestamp timestamp) {
    final DateTime dateTime = timestamp.toDate();

    final DateTime currentTime = DateTime.now();

    final differenceInDays = currentTime.difference(dateTime).inDays;
    if (differenceInDays == 0) {
      return DateFormat('HH:mm').format(dateTime);
    } else if (differenceInDays == 1) {
      return 'Yesterday at ${DateFormat('HH:mm').format(dateTime)}';
    } else if (differenceInDays < 7) {
      return DateFormat('EEE, HH:mm').format(dateTime).toUpperCase();
    } else {
      return "${DateFormat('MMM dd').format(dateTime)} at ${DateFormat('HH:mm').format(dateTime)}";
    }
  }

  static String formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) {
      return '';
    }
    DateTime dateTime = timestamp.toDate();
    Duration difference = DateTime.now().difference(dateTime);

    if (difference.inSeconds < 60) {
      return "${difference.inSeconds}s ago";
    } else if (difference.inMinutes < 60) {
      return "${difference.inMinutes}m ago";
    } else if (difference.inHours < 24) {
      return "${difference.inHours}h ago";
    } else if (difference.inDays < 15) {
      return "${difference.inDays}d ago";
    } else {
      return DateFormat('MMM d, yyyy').format(dateTime);
    }
  }

  static String formatExerciseDuration(int seconds) {
    if (seconds < 60) {
      return "$seconds sec";
    }

    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;

    if (remainingSeconds == 0) {
      return "${minutes}min";
    }

    return "${minutes}min ${remainingSeconds}sec";
  }

  static String formatToAlarmClock(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;

    // Format minutes and seconds as two digits
    String formattedMinutes = minutes.toString().padLeft(2, '0');
    String formattedSeconds = remainingSeconds.toString().padLeft(2, '0');

    return "$formattedMinutes:$formattedSeconds";
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

  static String getFormattedTime(DateTime dateTime) {
    final DateFormat timeFormat = DateFormat('h:mm a');
    return timeFormat.format(dateTime);
  }

  static String? formatDateToDuration(DateTime? datetime) {
    if (datetime == null) {
      return null;
    }
    String formattedTime = DateFormat('HH:mm').format(datetime);
    return formattedTime;
  }

  static String formatAppDateString(String dateString) {
    try {
      DateTime date = DateTime.parse(dateString);

      return DateFormat('MMM d, y').format(date);
    } catch (e) {
      return "Invalid date format";
    }
  }

  static String getFormattedMonth(DateTime date) {
    return DateFormat('MMM').format(date);
  } // Month as "JUN", "APR", etc.

  static String? formatDateToString(DateTime? dateTime) {
    try {
      if (dateTime == null) {
        return null;
      }
      return DateFormat('MMM d, y').format(dateTime);
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
