import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pzdeals/src/models/index.dart';
import 'package:pzdeals/src/services/notifications_service.dart';
import 'package:pzdeals/src/utils/formatter/date_formatter.dart';

final notificationsProvider = ChangeNotifierProvider<NotificationListNotifier>(
    (ref) => NotificationListNotifier());

class NotificationListNotifier extends ChangeNotifier {
  final NotificationService _notifService = NotificationService();

  String _boxName = 'notifications';
  int pageNumber = 1;
  bool _isLoading = false;
  String _userUID = '';
  int _unreadCount = 0;

  List<NotificationData> _notifications = [];
  List<DocumentSnapshot> _notifData = [];

  bool get isLoading => _isLoading;
  List<NotificationData> get notifications => _notifications;
  int get unreadCount => _unreadCount;

  void setUserUID(String uid) {
    debugPrint('setUserUID called with $uid');
    _userUID = uid;
    _boxName = '${_userUID}_notifications';
    // _loadBookmarks();
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
      _unreadCount = await getUnreadNotificationsCount();
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
      _unreadCount = await getUnreadNotificationsCount();
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
      await _notifService.deleteNotification(notifId, _boxName);
      _notifications.removeWhere((element) => element.id == notifId);
      _unreadCount = await getUnreadNotificationsCount();
      notifyListeners();
    } catch (e) {
      debugPrint('error removing bookmark: $e');
    }
  }

  Future<void> removeAllNotification() async {
    try {
      await _notifService.deleteAllNotifications(_boxName);
      _notifications.clear();
      _unreadCount = 0;
      notifyListeners();
    } catch (e) {
      debugPrint('error removing bookmark: $e');
    }
  }

  Future<void> markAsRead(String notifId) async {
    try {
      final notif =
          _notifications.firstWhere((element) => element.id == notifId);
      notif.isRead = true;
      _unreadCount = await getUnreadNotificationsCount();

      await _notifService.updateNotifications(notif, notifId, _boxName);

      notifyListeners();
    } catch (e) {
      debugPrint('error marking as read: $e');
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
}
