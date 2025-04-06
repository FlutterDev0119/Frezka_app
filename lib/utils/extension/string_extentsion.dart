import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../generated/assets.dart';
import '../common/common.dart';
import '../common/common_base.dart';
import '../constants.dart';
import '../shared_prefences.dart';

extension StrExt on String {
  //region common
  String get firstLetter => isNotEmpty ? this[0] : '';

  //endregion

  //region DateTime,Duration format
  String get formatDuration {
    DateTime now = DateTime.now();
    DateTime inputTime = DateFormat.Hms().parse(this);

    // Convert inputTime to today's date
    inputTime = DateTime(now.year, now.month, now.day, inputTime.hour, inputTime.minute, inputTime.second);

    // If the input time is earlier in the day, assume it's for tomorrow
    if (inputTime.isBefore(now)) {
      inputTime = inputTime.add(Duration(days: 1));
    }

    // Calculate difference
    Duration difference = inputTime.difference(now);

    // Format the duration
    int hours = difference.inHours;
    int minutes = difference.inMinutes.remainder(60);

    if (hours > 0 && minutes > 0) {
      return '${hours}h ${minutes}min';
    } else if (hours > 0) {
      return '${hours}h';
    } else {
      return '${minutes}min';
    }
  }

  String formattedDate({String? dateTimeFormat}) {
    if (dateTimeFormat.validate().isNotEmpty) return DateFormat(dateTimeFormat).format(DateTime.parse(this));
    return DateFormat.jm().format(DateTime.parse(this));
  }

  // String formatToDisplayDate() {
  //   String? languageCode = selectedLanguageCode.value;
  //   String dateFormat = getStringAsync(AppSharedPreferenceKeys.displayDateFormat).isNotEmpty ? getStringAsync(AppSharedPreferenceKeys.displayDateFormat) : DateFormatConstants.yyyy_MM_dd;
  //
  //   // Parse the date and time separately
  //   DateTime newDate = DateTime.parse(this);
  //
  //   // Merge the date with the time
  //   DateTime finalDateTime = DateTime(newDate.year, newDate.month, newDate.day);
  //
  //   // Handle ordinal suffix in the date
  //   if (dateFormat.contains('dS')) {
  //     int day = finalDateTime.day;
  //     String formattedDate = DateFormat(dateFormat.replaceAll('S', ''), languageCode).format(finalDateTime);
  //     return formattedDate.replaceFirst('$day', '${addOrdinalSuffix(day)}');
  //   }

  //   return '${DateFormat(dateFormat, languageCode).format(finalDateTime)}';
  // }

  // String formatToDisplayDateTime({String time = ''}) {
  //   String dateFormat = getStringAsync(AppSharedPreferenceKeys.displayDateFormat).isNotEmpty ? getStringAsync(AppSharedPreferenceKeys.displayDateFormat) : DateFormatConstants.yyyy_MM_dd;
  //   String timeFormat = getStringAsync(AppSharedPreferenceKeys.displayTimeFormat).isNotEmpty ? getStringAsync(AppSharedPreferenceKeys.displayTimeFormat) : DateFormatConstants.HH_mm12Hour;
  //
  //   // Parse the date and time separately
  //   DateTime newDate = DateTime.parse(this);
  //   DateTime newTime = DateTime.parse(time.isNotEmpty ? time : this);
  //
  //   // Merge the date with the time
  //   DateTime finalDateTime = DateTime(newDate.year, newDate.month, newDate.day, newTime.hour, newTime.minute, newTime.second);
  //
  //   // Handle ordinal suffix in the date
  //   if (dateFormat.contains('dS')) {
  //     int day = finalDateTime.day;
  //     String formattedDate = DateFormat(dateFormat.replaceAll('S', ''), selectedLanguageCode.value).format(finalDateTime);
  //     return formattedDate.replaceFirst('$day', '${addOrdinalSuffix(day)}') + ' ${DateFormat(timeFormat, selectedLanguageCode.value).format(finalDateTime)}';
  //   }
  //
  //   return '${DateFormat(dateFormat, selectedLanguageCode.value).format(finalDateTime)} ${DateFormat(timeFormat, selectedLanguageCode.value).format(finalDateTime)}';
  // }

  String formatToDisplayTime() {
    if (this.isEmpty) return "";
    // Get user preference for time format
    String timeFormat =
        getStringAsync(AppSharedPreferenceKeys.displayTimeFormat).isNotEmpty ? getStringAsync(AppSharedPreferenceKeys.displayTimeFormat) : DateFormatConstants.HH_mm12Hour; // Default to 12-hour format

    try {
      DateTime parsedTime;

      // Check if `time` contains only time or a full date-time
      if (this.contains("-")) {
        // It's a full date-time string (e.g., "2025-02-17 05:52:16")
        parsedTime = DateTime.parse(this);
      } else {
        parsedTime = DateFormat("HH:mm").parse(this);
      }

      // Format the parsed time
      return DateFormat(timeFormat, selectedLanguageCode.value).format(parsedTime);
    } catch (e) {
      print("Error parsing time: $e");
      return this; // Return original if parsing fails
    }
  }



  String formatPhoneNumber(String phoneCode) {
    String trimmedPhoneNumber = trim();

    if (trimmedPhoneNumber.startsWith(phoneCode)) {
      return trimmedPhoneNumber;
    } else {
      return '$phoneCode $trimmedPhoneNumber';
    }
  }

  String formatToTimeAgo() {
    DateTime? dateTime = DateTime.tryParse(this);
    if (dateTime == null) return 'Unknown';

    Duration difference = DateTime.now().difference(dateTime);

    if (difference.inSeconds < 60) {
      if (difference.inSeconds > 0) return "Just now";
      return '${difference.inSeconds}s ago';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else if (difference.inDays < 30) {
      return '${(difference.inDays / 7).floor()}w ago';
    } else if (difference.inDays < 365) {
      return '${(difference.inDays / 30).floor()}mo ago';
    } else {
      return '${(difference.inDays / 365).floor()}y ago';
    }
  }

  (String, String) get extractPhoneCodeAndNumber {
    // Split the string by spaces and hyphens
    List<String> parts = trim().split(RegExp(r'[\s-]+'));

    if (parts.length > 1) {
      // Assume the first part is the phone code
      String phoneCode = parts[0].trim().replaceAll("+", '');
      // Join the remaining parts as the phone number
      String phoneNumber = parts.sublist(1).join('').trim();
      return (phoneCode, phoneNumber);
    } else {
      // If there's no separator, treat the whole string as the number
      return ('', trim());
    }
  }
}