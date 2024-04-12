import 'package:flutter/material.dart';
import 'package:pzdeals/src/features/account/models/settings_data.dart';

class UserSettingsMapper {
  static SettingsData mapToSettingsData(dynamic responseData) {
    try {
      final json = responseData[0];
      return SettingsData(
        priceMistake: json['price_mistake'],
        frontpageNotification: json['front_page_notif'] ?? false,
        percentageNotification: json['percentage_notification'] ?? false,
        percentageThreshold: json['percentage_threshold'] ?? 10,
        numberOfAlerts: json['alerts_count'] ?? 10,
      );
    } catch (e) {
      debugPrint('Error in mapToKeywordData: $e');
      throw ('Error in mapToKeywordData $e');
    }
  }
}
