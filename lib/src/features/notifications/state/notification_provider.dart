import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pzdeals/src/models/index.dart';
import 'package:pzdeals/src/services/notifications_service.dart';
import 'package:pzdeals/src/state/auth_user_data.dart';
import 'package:pzdeals/src/utils/formatter/date_formatter.dart';

final notificationsProvider =
    ChangeNotifierProvider<NotificationListNotifier>((ref) {
  final authState = ref.watch(authUserDataProvider);
  if (authState.isAuthenticated) {
    return NotificationListNotifier(userUID: authState.userData?.uid ?? '');
  } else {
    return NotificationListNotifier();
  }
});

class NotificationListNotifier extends ChangeNotifier {
  final NotificationService _notifService = NotificationService();

  String _boxName = 'notifications';
  int pageNumber = 1;
  bool _isLoading = false;
  String _userUID = '';
  int _unreadCount = 0;
  bool _hasNotification = false;

  List<NotificationData> _notifications = [];
  List<DocumentSnapshot> _notifData = [];
  List<NotificationData> _notificationForDeletion = [];

  bool get isLoading => _isLoading;
  List<NotificationData> get notifications => _notifications;
  int get unreadCount => _unreadCount;
  List<NotificationData> get notificationForDeletion =>
      _notificationForDeletion;
  bool get hasNotification => _hasNotification;

  void setUserUID(String uid) {
    debugPrint('setUserUID called with $uid');
    _userUID = uid;
    _boxName = '${_userUID}_notifications';
    // _loadBookmarks();
  }

  NotificationListNotifier({String userUID = ''}) {
    setUserUID(userUID);
    if (_userUID.isNotEmpty) {
      loadNotifications();
      getUnreadNotificationsCountFromStream(_userUID);
    }
  }

  Future<void> refreshNotification() async {
    _notifications.clear();
    _notifData.clear();
    try {
      _notifData = await _notifService.getInitialNotifications(_boxName);
      _notifications = _notifData
          .map((doc) => NotificationData(
                id: doc["id"],
                title: doc["title"],
                body: doc["body"],
                timestamp: timestampToDateTime(doc["timestamp"]),
                isRead: doc["isRead"] as bool,
                data: doc["data"],
                imageUrl: doc["imageUrl"],
              ))
          .toList();
      getUnreadNotificationsCountFromStream(_userUID);
      notifyListeners();
    } catch (e) {
      debugPrint("error loading notifications: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadNotifications() async {
    _isLoading = true;
    notifyListeners();
    _notifications.clear();
    _notifData.clear();
    try {
      _notifData = await _notifService.getInitialNotifications(_boxName);
      _notifications = _notifData
          .map((doc) => NotificationData(
                id: doc["id"],
                title: doc["title"],
                body: doc["body"],
                timestamp: timestampToDateTime(doc["timestamp"]),
                isRead: doc["isRead"] as bool,
                data: doc["data"],
                imageUrl: doc["imageUrl"],
              ))
          .toList();
      // _unreadCount = await getUnreadNotificationsCount();
      notifyListeners();
    } catch (e) {
      debugPrint("error loading notifications: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMoreNotifications() async {
    _isLoading = true;
    notifyListeners();

    try {
      DocumentSnapshot lastDocument = _notifData[_notifData.length - 1];
      final moreNotif =
          await _notifService.getMoreNotifications(_boxName, lastDocument);
      _notifData.addAll(moreNotif);
      _notifications.addAll(moreNotif
          .map((doc) => NotificationData(
                id: doc["id"],
                title: doc["title"],
                body: doc["body"],
                timestamp: timestampToDateTime(doc["timestamp"]),
                isRead: doc["isRead"] as bool,
                data: doc["data"],
                imageUrl: doc["imageUrl"],
              ))
          .toList());
      // _unreadCount = await getUnreadNotificationsCount();
      notifyListeners();
    } catch (e) {
      debugPrint('error loading more notifications: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> removeNotification(String notifId) async {
    try {
      _notificationForDeletion
          .add(_notifications.firstWhere((element) => element.id == notifId));
      _notifications.removeWhere((element) => element.id == notifId);
      // _unreadCount = await getUnreadNotificationsCount();
      notifyListeners();

      await Future.delayed(const Duration(seconds: 5), () {
        removeNotificationFromFirestore();
      });
      // await _notifService.deleteNotification(notifId, _boxName);
    } catch (e, stackTrace) {
      debugPrintStack(stackTrace: stackTrace);
      debugPrint('error removeNotification: $e');
    }
  }

  Future<void> removeNotificationFromFirestore({bool isAll = false}) async {
    debugPrint('start removeNotificationFromFirestore');
    debugPrint('notifForDeletion: ${_notificationForDeletion.length}');
    if (_notificationForDeletion.isEmpty) return;

    try {
      if (isAll) {
        await _notifService.deleteAllNotifications(_boxName);
        _notifications.clear();
        _unreadCount = 0;
        notifyListeners();
      } else {
        for (final element in _notificationForDeletion) {
          await _notifService.deleteNotification(element.id, _boxName);
        }
      }
      _notificationForDeletion.clear();
    } catch (e) {
      debugPrint('error removeNotificationFromFirestore: $e');
    }
  }

  void removeNotificationIdFromDeletionList(String notifId) {
    debugPrint('removeNotificationIdFromDeletionList');
    _notificationForDeletion.removeWhere((element) => element.id == notifId);
  }

  void reinsertNotificationToNotificationList(String notifId) async {
    debugPrint('reinsertNotificationToNotificationList');
    debugPrint('notif count before: ${_notifications.length}');
    final notif =
        _notificationForDeletion.firstWhere((element) => element.id == notifId);
    _notifications.add(notif);
    debugPrint('notif count after: ${_notifications.length}');
    // _unreadCount = await getUnreadNotificationsCount();
  }

  void reinsertAllNotificationToNotificationList() async {
    debugPrint('reinsertAllNotificationToNotificationList');
    debugPrint('notif count before: ${_notifications.length}');
    _notifications.addAll(_notificationForDeletion);
    _notificationForDeletion.clear();
    getUnreadNotificationsCountFromStream(_userUID);
    debugPrint('notif count after: ${_notifications.length}');
    // _unreadCount = await getUnreadNotificationsCount();
  }

  Future<void> removeAllNotification() async {
    try {
      _notificationForDeletion.addAll(_notifications);
      _notifications.clear();
      _unreadCount = 0;
      // _unreadCount = await getUnreadNotificationsCount();
      notifyListeners();

      await Future.delayed(const Duration(seconds: 5), () {
        removeNotificationFromFirestore(isAll: true);
      });

      // await _notifService.deleteAllNotifications(_boxName);
      // _notifications.clear();
      // _unreadCount = 0;
      // notifyListeners();
    } catch (e) {
      debugPrint('error removeAllNotification: $e');
    }
  }

  Future<void> markAsRead(String notifId) async {
    try {
      final notif =
          _notifications.firstWhere((element) => element.id == notifId);
      notif.isRead = true;

      // _unreadCount = await getUnreadNotificationsCount();
      notifyListeners();
      await _notifService.updateNotifications(notif, notifId, _boxName);
    } catch (e) {
      debugPrint('error marking as read: $e');
    }
  }

  Future<void> markAllAsRead() async {
    try {
      await _notifService.markAllNotificationsAsRead(_boxName);
      _unreadCount = 0;
      for (var element in _notifications) {
        element.isRead = true;
      }
      notifyListeners();
    } catch (e) {
      debugPrint('error marking all as read: $e');
    }
  }

  void resetNotifications() {
    notifyListeners();
  }

  Future<int> getUnreadNotificationsCount() async {
    try {
      final unreadNotif =
          _notifications.where((element) => element.isRead == false).toList();
      return unreadNotif.length;
    } catch (e) {
      debugPrint('error getting unread notifications count: $e');
      return 0;
    }
  }

  void incrementNotificationCount() {
    _unreadCount++;
    notifyListeners();
  }

  void decrementNotificationCount() {
    _unreadCount--;
    notifyListeners();
  }

  void setUnreadCount(int count) {
    _unreadCount = count;
    notifyListeners();
  }

  //listen to firestore notifications
  // void listenToNotifications() {
  //   _notifService.listenToNotifications(_boxName).listen((event) {
  //     final notif = NotificationData(
  //       id: event.id,
  //       title: event["title"],
  //       body: event["body"],
  //       timestamp: timestampToDateTime(event["timestamp"]),
  //       isRead: event["isRead"] as bool,
  //       data: event["data"],
  //       imageUrl: event["imageUrl"],
  //     );
  //     _notifications.insert(0, notif);
  //     _unreadCount = _notifications.where((element) => element.isRead == false).length;
  //     notifyListeners();
  //   });
  // }

  void getUnreadNotificationsCountFromStream(String userId) {
    FirebaseFirestore.instance
        .collection('notifications')
        .doc(userId)
        .collection('notification')
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      _unreadCount = 0;
      if (snapshot.docs.isNotEmpty) {
        _hasNotification = true;
      }
      snapshot.docs.forEach((doc) {
        if (doc.exists && doc['isRead'] == false) {
          _unreadCount++;
        }
      });
      debugPrint('unread count: $_unreadCount');
      notifyListeners();
    });
  }
}
