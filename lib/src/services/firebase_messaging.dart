import 'dart:convert';
import 'dart:io' show Platform;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pzdeals/main.dart';
import 'package:pzdeals/src/constants/index.dart';
import 'package:pzdeals/src/features/navigationwidget.dart';
import 'package:pzdeals/src/services/notifications_service.dart';
import 'package:pzdeals/src/utils/data_mapper/index.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class FirebaseMessagingApi {
  final _firebaseMessaging = FirebaseMessaging.instance;
  NotificationService notifService = NotificationService();

  final _androidChannel = const AndroidNotificationChannel(
    'high_importance_channel',
    '${Wordings.appName} Important Notifications',
    description:
        'This channel is used for important notifications from ${Wordings.appName}',
    importance: Importance.max,
  );

  final _localNotifications = FlutterLocalNotificationsPlugin();

  final AppLifecycleState _appLifecycleState = AppLifecycleState.resumed;

  void handleMessage(RemoteMessage? message) {
    debugPrint('handleMessage called with message: $message');
    if (message == null) return;
    debugPrint('handleMessage called with message: $message');
    // storeNotification(message);

    final dynamic notifdata = message.toMap();
    navigateToScreens(notifdata);
  }

  Future showNotification(
      {required int notificationId,
      required String title,
      required String body,
      required String payload,
      required String fcmNotifId}) async {
    NotificationDetails notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
          _androidChannel.id, _androidChannel.name,
          channelDescription: _androidChannel.description,
          icon: '@drawable/ic_launcher',
          importance: _androidChannel.importance),
      iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentSound: true,
          presentBanner: true,
          attachments: [DarwinNotificationAttachment('')]),
    );

    //add fcmNotifId to payload
    payload = jsonEncode({'fcmNotifId': fcmNotifId, 'payload': payload});

    await _localNotifications.show(
        notificationId, title, body, notificationDetails,
        payload: payload);
  }

  Future initPushNotifications() async {
    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
        alert: true, badge: true, sound: true);
    _firebaseMessaging.subscribeToTopic('manual_alerts');
    // _firebaseMessaging.subscribeToTopic('price_mistake');
    _firebaseMessaging.subscribeToTopic(
        'scheduled_reminder'); //for resetting notification received info
    _firebaseMessaging.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    FirebaseMessaging.onMessage.listen((message) {
      final notification = message.notification;
      debugPrint('message: ${message.toMap()}');
      if (notification == null) {
        debugPrint('message: ${message.toMap()}');
        if (message.data['alert_type'] == 'scheduled_reminder' &&
            message.data['value'] == 'front_page') {
          debugPrint('scheduled reminder received');
          notifService.resetNotificationReceivedInfo();
        }
      } else {
        final newTitle = addNotificationTypeToTitle(
            message.data['alert_type'] ?? '', notification.title ?? '');

        //add platform check
        if (Platform.isAndroid) {
          debugPrint('foreground notification received on android');
          showNotification(
            notificationId: message.hashCode,
            title: newTitle,
            body: message.notification!.body ?? '',
            payload: jsonEncode(message.data),
            fcmNotifId: message.messageId ?? '',
          );
        } else {
          if (_appLifecycleState != AppLifecycleState.resumed) {
            debugPrint('foreground notification received on ios');
            showNotification(
              notificationId: message.hashCode,
              title: newTitle,
              body: message.notification!.body ?? '',
              payload: jsonEncode(message.data),
              fcmNotifId: message.messageId ?? '',
            );
          }
        }
        storeNotification(message);
      }
    });
  }

  Future initLocalNotifications() async {
    final iOS = DarwinInitializationSettings(
      requestSoundPermission: true,
      requestAlertPermission: true,
      onDidReceiveLocalNotification: (id, title, body, payload) {
        debugPrint('onDidReceiveLocalNotification called');
        // if (payload != null) {
        //   final dynamic message = jsonDecode(payload);
        //   debugPrint('MESSAGE RECEIVED: $message');
        //   navigateToScreens(message);
        // }
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
        navigateToScreens(message, isForeground: true);
      }
    });

    final platform = _localNotifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (platform != null) {
      await platform.createNotificationChannel(_androidChannel);
    }

    tz.initializeTimeZones();
  }

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    initPushNotifications();
    initLocalNotifications();
  }

  Future<void> storeNotification(dynamic message) async {
    await Firebase.initializeApp();
    notifService.addNotification(
        NotificationMapper.mapToNotificationData(message), 'notifications');
    debugPrint('Notification added');
  }

  void navigateToScreens(dynamic message, {bool isForeground = false}) {
    debugPrint('navigateToScreens called with message: $message');
    dynamic data;

    if (isForeground) {
      final payload = jsonDecode(message['payload']);
      final newData = jsonEncode(
          {"item_id": payload["item_id"], "messageId": message['fcmNotifId']});
      data = jsonDecode(newData);
    } else {
      final itemId = message['data']['item_id'] ?? message['data']['id'];
      final newData =
          jsonEncode({"item_id": itemId, "messageId": message['messageId']});
      data = jsonDecode(newData);
    }
    if (navigatorKey.currentState != null) {
      // if (data['alert_type'] == 'keyword') {
      //   navigatorKey.currentState!
      //       .pushReplacementNamed('/keyword-deals', arguments: {
      //     'title': message["notification"]["title"],
      //     'keyword': data['value'],
      //     'product_id': data['item_id'] ?? ''
      //   });
      // } else if (data['alert_type'] == 'percentage') {
      //   navigatorKey.currentState!
      //       .pushReplacementNamed('/percentage-deals', arguments: {
      //     'title': message["notification"]["title"],
      //     'value': data['value'],
      //     'product_id': data['item_id'] ?? ''
      //   });
      // } else if (data['alert_type'] == 'price-mistake' ||
      //     data['alert_type'] == 'front-page' ||
      //     data['alert_type'] == 'front_page') {
      //   navigatorKey.currentState!.pushReplacementNamed('/deals', arguments: {
      //     'type': data['alert_type'],
      //     'product_id': data['id'] ?? ''
      //   });
      // } else if (data['alert_type'] == 'category') {
      //   navigatorKey.currentState!.pushNamed('/deal-collections', arguments: {
      //     'value': data['value'],
      //     'product_id': data['id'] ?? ''
      //   });
      // } else {
      // navigatorKey.currentState!.pushNamed('/notification-screen', arguments: {
      //   'title': message["notification"]["title"],
      //   'value': data['value'],
      //   'product_id': data['item_id'] ?? '',
      //   'notification_id': message["messageId"]
      // });

      //not working yet

      navigatorKey.currentState!.pushReplacement(
        MaterialPageRoute(
          builder: (context) =>
              NavigationWidget(initialPageIndex: 2, arguments: {
            // 'title': message["notification"]["title"],
            // 'type': data['alert_type'],
            // 'value': data['value'],
            'product_id': data['item_id'] ?? '',
            'notification_id': data["messageId"]
          }),
        ),
      );
      //end
      // navigatorKey.currentState!.pushReplacement(
      //   MaterialPageRoute(
      //     builder: (context) => const NavigationWidget(
      //       initialPageIndex: 2,
      //     ),
      //   ),
      // );
      // }
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
