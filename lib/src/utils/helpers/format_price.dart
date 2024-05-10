import 'package:flutter/material.dart';

String priceFormatter(dynamic value) {
  if (value == null) {
    return '0.00';
  } else if (value is String) {
    return double.parse(value).toStringAsFixed(2);
  } else if (value is num) {
    return value.toStringAsFixed(2);
  } else {
    throw ArgumentError('Invalid value: $value');
  }
}
