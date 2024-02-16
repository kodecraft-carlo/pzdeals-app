class NotificationData {
  final String title;
  final String description;
  final String timeStamp;
  final String imageUrl;

  NotificationData({
    required this.title,
    required this.description,
    required this.timeStamp,
    this.imageUrl = '',
  });
}
