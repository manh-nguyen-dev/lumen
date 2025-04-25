import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

Future<DateTime?> pickDate(BuildContext context) async {
  var now = DateTime.now();
  return await showDatePicker(
    context: context,
    initialDate: now,
    firstDate: now.copyWith(year: now.year - 1),
    lastDate: now.copyWith(year: now.year + 1),
  );
}

class DateTimeHelper {
  // Format DateTime to 'HH:mm dd/MM/yyyy' (e.g., '17:15 20/1/2025')
  static String formatDateTime(DateTime dateTime) {
    final DateFormat formatter = DateFormat('HH:mm dd/MM/yyyy');
    return formatter.format(dateTime);
  }

  // Format DateTime to 'dd/MM/yyyy' (e.g., '20/1/2025')
  static String formatDate(DateTime dateTime) {
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(dateTime);
  }

  // Format DateTime to 'HH:mm' (e.g., '17:15')
  static String formatTime(DateTime dateTime) {
    final DateFormat formatter = DateFormat('HH:mm');
    return formatter.format(dateTime);
  }

  // Convert a string to DateTime (using the format 'yyyy-MM-dd HH:mm:ss')
  static DateTime parseDateTime(String dateTimeString) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    return formatter.parse(dateTimeString);
  }

  // Get the current DateTime as a formatted string
  static String getCurrentFormattedDateTime() {
    return formatDateTime(DateTime.now());
  }
}
