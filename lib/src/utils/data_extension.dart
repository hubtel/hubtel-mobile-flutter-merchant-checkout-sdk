

import 'package:intl/intl.dart';

String getDayOfMonthSuffix(int n) {
  if (n >= 11 && n <= 13) {
    return 'th';
  } else {
    switch (n % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }
}

extension DateStringExtensions on String {
  /// Parses a yyyy-MM-dd HH:mm:ss or yyyy-MM-dd'T'HH:mm:ss [String]
  /// to an equivalent [Date] object.
  ///
  /// @param includeTime indicates the whether the HH:mm:ss part of the
  /// date string being parsed should be included in the output [Date]
  /// object.
  ///
  /// @return [Date] object equivalent of the [String] or null if the
  /// parsing of the [String] fails.
  DateTime? parseDateTime({bool includeTime = true}) {
    DateTime? parsedDate = parseYyyyMMddHHmmss(includeTime);
    if (parsedDate != null) {
      return parsedDate;
    }
    return parseYyyyMMddTHHmmss(includeTime);
  }

  DateFormat? parseDate() {
    try {
      DateFormat dateFormat = DateFormat('HH:mm \'GMT\'');
      return dateFormat;
    } catch (ex) {
      return null;
    }
  }

  /// Use parseDateTime() instead
  ///
  DateTime? parseYyyyMMddHHmmss(bool includeTime) {
    final formatString = 'yyyy-MM-dd${includeTime ? ' HH:mm:ss' : ''}';
    final parseString = includeTime ? split(RegExp(r'\s+')).firstOrNull ?? this : this;

    try {
      final sdf = DateFormat(formatString, 'en_US');
      return sdf.parse(parseString);
    } catch (ex) {
      return null;
    }
  }

  /// Use parseDateTime() instead
  ///
  DateTime? parseYyyyMMddTHHmmss(bool includeTime) {
    final formatString = 'yyyy-MM-dd${includeTime ? "'T'HH:mm:ss" : ''}';
    final parseString = includeTime ? split(RegExp(r"'T'")).firstOrNull ?? this : this;

    try {
      final sdf = DateFormat(formatString, 'en_US');
      return sdf.parse(parseString);
    } catch (ex) {
      return null;
    }
  }

  String convertToDate() {
    DateTime? dateTime = DateTime.tryParse(this);
    if (dateTime != null) {
      return DateFormat('MMM d y').format(dateTime);
    }
    return "";
  }

  String convertToGMT() {
    DateTime? dateTime = DateTime.tryParse(this);
    if (dateTime != null) {
      return DateFormat('HH:mm \'GMT\'').format(dateTime);
    }

    return "";
  }
}

extension DateFormatExtension on DateTime {
  String? format(String pattern) {
    final sdf = DateFormat(pattern, 'en_US');
    try {
      return sdf.format(this);
    } catch (ex) {
      return null;
    }
  }

  /// Formats a [Date] object into to d MMMM, yyyy [String] with the position of
  /// day in month indicated.
  ///
  /// @return formatted [String] represented by the [Date] object.
  ///
  ///  ### Example:
  /// ```
  ///   println(Date(1646737397238).toNthDateFormat()) // outputs 8th March 2022
  /// ```
  String toNthDateFormat() {
    final sdf = DateFormat('d MMMM yyyy', 'en_US');
    try {
      final formattedString = sdf.format(this);
      final splitString = formattedString.split(RegExp(r'\s+'));
      final sb = StringBuffer();

      splitString.asMap().forEach((index, s) {
        if (index == 0 && splitString.length > 1) {
          sb.write(s);
          sb.write(getDayOfMonthSuffix(int.tryParse(s) ?? 0));
        } else {
          sb.write(s);
        }
        sb.write(' ');
      });

      return sb.toString().trim();
    } catch (ex) {
      return toString();
    }
  }

  /// Formats to a MMM dd, yyyy [String].
  ///
  /// @return formatted [String] represented by the [Date] object and null
  /// if formatting fails.
  ///
  ///  ### Example:
  /// ```
  ///   println(Date().formatMMMddYYYY()) // outputs Feb 15, 2020
  /// ```
  String? formatMMMddYYYY() {
    return format('MMM dd, yyyy');
  }

  /// Formats to a YYYY-MM-dd HH:mm:ss [String].
  ///
  /// @return formatted [String] represented by the [Date] object and null
  /// if formatting fails.
  ///
  ///  ### Example:
  /// ```
  ///   println(Date(1646737397238).formatYyyyMMddHHmmss()) // outputs 2022-03-08 17:45:30
  /// ```
  String? formatYyyyMMddHHmmss() {
    return format('yyyy-MM-dd HH:mm:ss');
  }

  /// Formats to a H:mm a [String].
  ///
  /// @return formatted [String] represented by the [Date] object and null
  /// if formatting fails.
  ///
  ///  ### Example:
  /// ```
  ///   println(Date(1646737397238).formatHmma()) // outputs 11:03 AM
  /// ```
  String? formatHmma() {
    return format('h:mm a');
  }

  String? formatMMMMdyyyy() {
    return format('MMMM d, yyyy');
  }

  bool isSameDay(DateTime other) {
    return format('yyyyMMdd') == other.format('yyyyMMdd');
  }

  /// @return a [Date] representation of the difference between subtracting
  /// the two [Date.getTime] values.
  DateTime operator -(DateTime other) {
    return DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch - other.millisecondsSinceEpoch);
  }

  /// @return a [Date] representation of the difference between adding
  /// the two [Date.getTime] values.
  DateTime operator +(DateTime other) {
    return DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch + other.millisecondsSinceEpoch);
  }

  /// Formats to a MMM d y [String].
  ///
  /// @return formatted [String] represented by the [Date] object and null
  /// if formatting fails.
  ///
  ///  ### Example:
  /// ```
  ///   println(Date().formatMMMddYYYY()) // outputs Feb 9 2020
  /// ```
  String? formatMMMdY() {
    return format('MMM d y');
  }

  // Name error workaround => "the name '+' is already defined"
  DateTime addMilliseconds(int milliseconds) {
    return DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch + milliseconds);
  }

  DateTime subtractMilliseconds(int milliseconds) {
    return DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch - milliseconds);
  }

  DateTime getDay(int dayOfWeek) {
    return subtract(Duration(days: weekday - dayOfWeek));
  }

  DateTime previousMonth() {
    return DateTime(year, month - 1, day);
  }

  String friendlyMonthYear() {
    return DateFormat('MMMM, yyyy').format(this);
  }

  String friendlyDayDate() {
    return DateFormat("E, dd MMM yyyy").format(this);
  }

  String friendlyShortDate() {
    return DateFormat("dd MMM yyyy").format(this);
  }

  String friendlyMonth() {
    return DateFormat('MMMM').format(this);
  }

  String friendlyDayMonth() {
    return DateFormat('d MMMM').format(this);
  }

  String friendlyDayMonthShort() {
    return DateFormat('d MMM').format(this);
  }

  DateTime getDaysAgo({required numberOfDays}) {
    return subtract(Duration(days: numberOfDays));
  }

  String systemDateFormat() {
    return DateFormat('yyyy-MM-dd').format(this);
  }

  String systemDateMonthFormat() {
    return DateFormat('MM-yyyy').format(this);
  }

  String friendlyDate() {
    var format = DateFormat.yMMMd();
    return format.format(this);
  }

  String fullFriendlyDate() {
    var format = DateFormat.yMMMMd();
    return format.format(this);
  }

  String friendlyDateMonth() {
    var format = DateFormat.yMMM();
    return format.format(this);
  }

  String friendlyDateTime({bool? newLine}) {
    var format = DateFormat.jm();
    return '${friendlyDate()}${newLine == true ? "\n" : " • "}${format.format(this)}';
  }

  int getDayOfYear() {
    // Create a new DateTime object for the start of the year
    DateTime startOfYear = DateTime(year, 1, 1);

    // Get the difference in days between the current date and the start of the year
    int dayOfYear = difference(startOfYear).inDays + 1;

    return dayOfYear;
  }
}
