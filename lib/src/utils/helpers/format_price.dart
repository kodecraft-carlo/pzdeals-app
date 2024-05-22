import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String priceFormatter(dynamic value) {
  if (value == null || value == 0) {
    return '0.00';
  } else if (value is String) {
    return double.parse(value).toStringAsFixed(2);
  } else if (value is num) {
    return value.toStringAsFixed(2);
  } else {
    throw ArgumentError('Invalid value: $value');
  }
}

String priceFormatterWithComma(dynamic value) {
  if (value == null || value == 0) {
    return '0.00';
  } else if (value is String) {
    return NumberFormat("#,##0.00", "en_US").format(double.parse(value));
  } else if (value is num) {
    return NumberFormat("#,##0.00", "en_US").format(value);
  } else {
    throw ArgumentError('Invalid value: $value');
  }
}
