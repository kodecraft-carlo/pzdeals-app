import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive/hive.dart';
import 'package:pzdeals/main.dart';
import 'package:pzdeals/src/constants/index.dart';
import 'package:pzdeals/src/features/navigationwidget.dart';
import 'package:pzdeals/src/services/notifications_service.dart';
import 'package:pzdeals/src/utils/data_mapper/index.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class FirebaseMessagingApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  // // Define a Hive box for storing notification-related data
  // late Box _notificationBox;

  // // Notification limit and last reset timestamp
  // late int _notificationLimit;
  // late DateTime _lastResetTimestamp;

  // // Notification counti
  // late int _notificationCount;

  // FirebaseMessagingApi() {
  //   // Initialize Hive box for notification data
  //   Hive.openBox('notificationBox').then((box) {
  //     _notificationBox = box;
  //     _initializeNotifications();
  //   });
  // }
  // void _initializeNotifications() {
  //   // Retrieve notification limit and last reset timestamp from the cache
  //   _notificationLimit =
  //       _notificationBox.get('notificationLimit', defaultValue: 10);
  //   _lastResetTimestamp = _notificationBox.get('lastResetTimestamp',
  //       defaultValue: DateTime.now());

  //   // Retrieve notification count from the cache
  //   _notificationCount =
  //       _notificationBox.get('notificationCount', defaultValue: 0);
  // }

  final _androidChannel = const AndroidNotificationChannel(
    'high_importance_channel',
    '${Wordings.appName} Important Notifications',
    description:
        'This channel is used for important notifications from ${Wordings.appName}',
    importance: Importance.max,
  );

  final _localNotifications = FlutterLocalNotificationsPlugin();

  void handleMessage(RemoteMessage? message) {
    if (message == null) return;
    // storeNotification(message);
    // Check if the current timestamp exceeds the last reset timestamp
    // if (DateTime.now()
    //     .isAfter(_lastResetTimestamp.add(const Duration(days: 1)))) {
    //   // Reset the notification count and update the last reset timestamp
    //   _notificationCount = 0;
    //   _lastResetTimestamp = DateTime.now();
    //   _notificationBox.put('notificationCount', _notificationCount);
    //   _notificationBox.put('lastResetTimestamp', _lastResetTimestamp);
    // }

    // Increment the notification count
    // _notificationCount++;
    // _notificationBox.put('notificationCount', _notificationCount);

    // Check if the notification count exceeds the limit
    // if (_notificationCount > _notificationLimit) {
    //   return;
    // }

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
      final newTitle = addNotificationTypeToTitle(
          message.data['alert_type'] ?? '', notification.title ?? '');
      // if (!notificationCountExceedsLimit(_notificationLimit)) {
      showNotification(
        notificationId: notification.hashCode,
        // title: addNotificationTypeToTitle(notification),
        title: newTitle,
        body: notification.body ?? '',
        payload: jsonEncode(message.toMap()),
      );
      storeNotification(message);
      // }
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

  // bool notificationCountExceedsLimit(int limit) {
  //   // Implement your logic to check if the notification count exceeds the limit
  //   // For example, you can retrieve the stored notification count from another Hive box
  //   int storedNotificationCount = _notificationCount;
  //   return storedNotificationCount >= limit;
  // }

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
      } else if (data['alert_type'] == 'price_mistake') {
        navigatorKey.currentState!.pushReplacementNamed('/deals', arguments: {
          'type': 'price_mistake',
          'product_id': data['id'] ?? ''
        });
      } else if (data['alert_type'] == 'category') {
        navigatorKey.currentState!.pushNamed('/deal-collections', arguments: {
          'value': data['value'],
          'product_id': data['id'] ?? ''
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

  String addNotificationTypeToTitle(String type, String title) {
    if (type == 'keyword') {
      return 'Keyword Alert: $title';
    } else if (type == 'percentage') {
      return 'Percentage Off Alert: $title';
    } else if (type == 'price_mistake') {
      return 'Price Mistake Alert: $title';
    } else if (type == 'category') {
      return 'Category Alert: $title';
    } else {
      return title;
    }
  }
}
