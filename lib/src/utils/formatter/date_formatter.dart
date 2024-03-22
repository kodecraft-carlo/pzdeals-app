import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String formatDateToDisplay(dynamic date, String dateFormat) {
  if (date is DateTime) {
    return DateFormat(dateFormat).format(date.toLocal());
  } else if (date is String) {
    return DateFormat(dateFormat).format(DateTime.parse(date).toLocal());
  } else {
    return date;
  }
}

String formatDateToLocale(dynamic date) {
  if (date is Map<String, dynamic>) {
    int? year = date['year'] ?? 1900;
    int? month = date['month'];
    int? day = date['day'];
    if (year != null && month != null && day != null) {
      return DateFormat('yyyy-MM-dd')
          .format(DateTime(year, month, day).toLocal());
    }
    return '';
  } else if (date is Timestamp) {
    return date.toDate().toLocal().toIso8601String();
  } else if (date is String) {
    DateTime dateTime = DateTime.parse(date);
    return dateTime.toIso8601String();
  } else {
    return '';
  }
}

DateTime? formatDateToDateTime(dynamic date) {
  if (date is Map<String, dynamic>) {
    int? year = date['year'] ?? 1900;
    int? month = date['month'];
    int? day = date['day'];
    if (year != null && month != null && day != null) {
      return DateTime(year, month, day).toLocal();
    }
  } else if (date is Timestamp) {
    return date.toDate().toLocal();
  } else if (date is String) {
    DateTime dateTime = DateTime.parse(date);
    return dateTime.toLocal();
  } else {
    return null;
  }
  return null;
}

DateTime millisecondsToDateTime(int millisecondsSinceEpoch) {
  debugPrint('millisecondsSinceEpoch: $millisecondsSinceEpoch');
  debugPrint(
      'millisecondsSinceEpoch: ~ ${DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch)}');
  return DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);
}

DateTime timestampToDateTime(Timestamp timestamp) {
  return timestamp.toDate().toLocal();
}
