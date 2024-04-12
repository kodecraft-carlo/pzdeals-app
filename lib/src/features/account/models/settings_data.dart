import 'package:hive/hive.dart';

part 'settings_data.g.dart';

@HiveType(typeId: 8)
class SettingsData extends HiveObject {
  @HiveField(0)
  bool priceMistake;

  @HiveField(1)
  bool frontpageNotification;

  @HiveField(2)
  bool percentageNotification;

  @HiveField(3)
  int percentageThreshold;

  @HiveField(4)
  int numberOfAlerts;

  SettingsData({
    required this.priceMistake,
    required this.frontpageNotification,
    required this.percentageNotification,
    required this.percentageThreshold,
    this.numberOfAlerts = 10,
  });

  Map<String, dynamic> toMap() {
    return {
      'priceMistake': priceMistake,
      'frontpageNotification': frontpageNotification,
      'percentageNotification': percentageNotification,
      'percentageThreshold': percentageThreshold,
      'numberOfAlerts': numberOfAlerts,
    };
  }

  Map<String, dynamic> toMapForUpdate(String? userId) {
    return {
      'user_id': userId ?? '',
      'price_mistake': priceMistake,
      'front_page_notif': frontpageNotification,
      'percentage_notification': percentageNotification,
      'percentage_threshold': percentageThreshold,
      'alerts_count': numberOfAlerts,
    };
  }

  Map<String, dynamic> toMapForCreate(String userId) {
    return {
      'user_id': userId,
      'price_mistake': priceMistake,
      'front_page_notif': frontpageNotification,
      'percentage_notification': percentageNotification,
      'percentage_threshold': percentageThreshold,
      'alerts_count': numberOfAlerts,
    };
  }

  set setPriceMistake(bool status) {
    priceMistake = status;
  }

  set setFrontpageNotification(bool status) {
    frontpageNotification = status;
  }

  set setPercentageNotification(bool status) {
    percentageNotification = status;
  }

  set setPercentageThreshold(int value) {
    percentageThreshold = value;
  }

  set setNumberOfAlerts(int value) {
    numberOfAlerts = value;
  }
}
