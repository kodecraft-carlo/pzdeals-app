import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pzdeals/main.dart';
import 'package:pzdeals/src/features/navigationwidget.dart';
import 'package:pzdeals/src/services/notifications_service.dart';
import 'package:pzdeals/src/utils/data_mapper/index.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class FirebaseMessagingApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  final _androidChannel = const AndroidNotificationChannel(
    'high_importance_channel',
    'PzDeals Important Notifications',
    description:
        'This channel is used for important notifications from PZ Deals',
    importance: Importance.max,
  );

  final _localNotifications = FlutterLocalNotificationsPlugin();

  void handleMessage(RemoteMessage? message) {
    if (message == null) return;
    // storeNotification(message);
    final dynamic notifdata = message.toMap();
    navigateToScreens(notifdata);
  }

  Future showNotification(
      {required int notificationId,
      required String title,
      required String body,
      required String payload}) async {
    // debugPrint('showNotification data: ${payload.toString()}');

    NotificationDetails notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
          _androidChannel.id, _androidChannel.name,
          channelDescription: _androidChannel.description,
          icon: '@drawable/ic_launcher',
          importance: _androidChannel.importance),
      iOS: const DarwinNotificationDetails(
        presentAlert: true,
        presentSound: true,
      ),
    );
    await _localNotifications.show(
        notificationId, title, body, notificationDetails,
        payload: payload);
  }

  Future initPushNotifications() async {
    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
        alert: true, badge: true, sound: true);
    _firebaseMessaging.subscribeToTopic('manual_alerts');
    _firebaseMessaging.subscribeToTopic('price_mistake');
    _firebaseMessaging.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    FirebaseMessaging.onMessage.listen((message) {
      final notification = message.notification;
      if (notification == null) return;
      debugPrint('notification data: ${message.toMap()}');
      showNotification(
          notificationId: notification.hashCode,
          title: notification.title ?? '',
          body: notification.body ?? '',
          payload: jsonEncode(message.toMap()));
      storeNotification(message);
    });
  }

  Future initLocalNotifications() async {
    final iOS = DarwinInitializationSettings(
      requestSoundPermission: true,
      requestAlertPermission: true,
      onDidReceiveLocalNotification: (id, title, body, payload) {
        return;
      },
    );
    const android = AndroidInitializationSettings('@drawable/ic_launcher');
    final settings = InitializationSettings(android: android, iOS: iOS);

    await _localNotifications.initialize(settings,
        onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) async {
      final String? payload = notificationResponse.payload;
      if (notificationResponse.payload != null) {
        final dynamic message = jsonDecode(payload!);
        navigateToScreens(message);
      }
    });

    final platform = _localNotifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()!;
    await platform.createNotificationChannel(_androidChannel);

    tz.initializeTimeZones();
  }

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    initPushNotifications();
    initLocalNotifications();
  }

  Future<void> storeNotification(dynamic message) async {
    NotificationService notifService = NotificationService();
    notifService.addNotification(
        NotificationMapper.mapToNotificationData(message), 'notifications');
    debugPrint('Notification added');
  }

  void navigateToScreens(dynamic message) {
    final data = message["data"];
    if (navigatorKey.currentState != null) {
      if (data['alert_type'] == 'keyword') {
        navigatorKey.currentState!
            .pushReplacementNamed('/keyword-deals', arguments: {
          'title': message["notification"]["title"],
          'keyword': data['value'],
          'product_id': data['item_id'] ?? ''
        });
      } else if (data['alert_type'] == 'percentage') {
        navigatorKey.currentState!
            .pushReplacementNamed('/percentage-deals', arguments: {
          'title': message["notification"]["title"],
          'value': data['value'],
          'product_id': data['item_id'] ?? ''
        });
      } else {
        navigatorKey.currentState!.pushReplacement(
          MaterialPageRoute(
            builder: (context) => const NavigationWidget(
              initialPageIndex: 2,
            ),
          ),
        );
      }
    }
  }
}
