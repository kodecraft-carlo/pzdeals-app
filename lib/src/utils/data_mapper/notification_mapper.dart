import 'package:flutter/material.dart';
import 'package:pzdeals/src/models/index.dart';

class NotificationMapper {
  static NotificationData mapToNotificationData(dynamic payload) {
    try {
      final json = payload;
      String imageSrc = '';
      if (json.data["image_url"] != null) {
        imageSrc = json.data["image_url"] ?? '';
      } else if (json.notification.android != null) {
        imageSrc = json.notification.android.imageUrl ?? '';
      } else if (json.notification.apple != null) {
        imageSrc = json.notification.apple.imageUrl ?? '';
      }
      return NotificationData(
        id: json.messageId,
        title: json.notification.title ?? 'Notification',
        body: json.notification.body ?? '',
        imageUrl: imageSrc,
        timestamp: DateTime.now(),
        isRead: false,
        data: json.data,
      );
    } catch (e) {
      debugPrint('Error in mapToNotificationData: $e');
      throw ('Error in mapToNotificationData $e');
    }
  }
}
