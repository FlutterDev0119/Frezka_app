import 'package:intl/intl.dart';

import '../constants.dart';


extension DateExtension on DateTime {
  String formatDateYYYYmmdd() {
    final formatter = DateFormat(DateFormatConstants.yyyy_MM_dd);
    return formatter.format(this);
  }

  String formatDateDDMMYYYY() {
    final formatter = DateFormat(DateFormatConstants.DD_MM_YY);
    return formatter.format(this);
  }
}