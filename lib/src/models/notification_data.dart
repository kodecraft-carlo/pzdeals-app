import 'package:hive/hive.dart';

part 'notification_data.g.dart';

@HiveType(typeId: 5)
class NotificationData {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final DateTime timestamp;

  @HiveField(2)
  final String title;

  @HiveField(3)
  final String body;

  @HiveField(4)
  bool isRead;

  @HiveField(5)
  final String imageUrl;

  @HiveField(6)
  final dynamic data;

  NotificationData({
    required this.id,
    required this.timestamp,
    required this.title,
    required this.body,
    this.isRead = false,
    this.imageUrl = '',
    this.data,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'timestamp': timestamp,
      'title': title,
      'body': body,
      'isRead': isRead,
      'imageUrl': imageUrl,
      'data': data,
    };
  }

  set isReadStatus(bool status) {
    isRead = status;
  }
}
