import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pzdeals/src/models/notification_data.dart';
import 'package:pzdeals/src/state/auth_user_data.dart';
import 'package:pzdeals/src/utils/formatter/date_formatter.dart';
import 'package:pzdeals/src/utils/helpers/appbadge.dart';

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
  final _firestoreDb = FirebaseFirestore.instance;

  List<String> notificationIdsForDismissal = [];
  List<NotificationData> _notificationList = [];

  int pageNumber = 1;
  String _userUID = '';
  int _unreadCount = 0;
  bool _hasNotification = false;
  bool _undoDismissAll = false;

  int get unreadCount => _unreadCount;
  bool get hasNotification => _hasNotification;
  List<NotificationData> get notificationList => _notificationList;

  void setUserUID(String uid) {
    debugPrint('setUserUID called with $uid');
    _userUID = uid;
  }

  NotificationListNotifier({String userUID = ''}) {
    setUserUID(userUID);
    if (_userUID.isNotEmpty) {
      // getUnreadNotificationsCountFromStream(_userUID);
      getNotificationsFromStream(_userUID);
    }
  }

  Future<void> setDismissed(String notifId, bool isDismissed) async {
    await _firestoreDb
        .collection('notifications')
        .doc(_userUID)
        .collection('notification')
        .where('id', isEqualTo: notifId)
        .get()
        .then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        ds.reference.set({'isDismissed': isDismissed}, SetOptions(merge: true));
      }
    });
    if (isDismissed == true) {
      notificationIdsForDismissal.add(notifId);
      await Future.delayed(const Duration(seconds: 5), () {
        removeAllForDismissal();
      });
    } else {
      notificationIdsForDismissal.remove(notifId);
    }
  }

  Future<void> dismissAll() async {
    //set all notifications as dismissed
    for (var element in _notificationList) {
      notificationIdsForDismissal.add(element.id);
      element.isDismissed = true;
    }
    notifyListeners();
    _firestoreDb
        .collection('notifications')
        .doc(_userUID)
        .collection('notification')
        .get()
        .then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        ds.reference.set({'isDismissed': true}, SetOptions(merge: true));
        notificationIdsForDismissal.add(ds['id']);
      }
    });

    await Future.delayed(const Duration(seconds: 5), () {
      removeAllForDismissal();
    });
  }

  Future<void> undoDismissAll() async {
    _undoDismissAll = true;
    for (var element in _notificationList) {
      notificationIdsForDismissal.add(element.id);
      element.isDismissed = false;
    }
    notifyListeners();
    for (var notifId in notificationIdsForDismissal) {
      _firestoreDb
          .collection('notifications')
          .doc(_userUID)
          .collection('notification')
          .where('id', isEqualTo: notifId)
          .get()
          .then((snapshot) {
        for (DocumentSnapshot ds in snapshot.docs) {
          ds.reference.set({'isDismissed': false}, SetOptions(merge: true));
        }
      });
    }
    notificationIdsForDismissal.clear();
  }

  Future<void> setAsRead(String notifId) async {
    final notif =
        _notificationList.firstWhere((element) => element.id == notifId);
    notif.isRead = true;
    notifyListeners();
    _firestoreDb
        .collection('notifications')
        .doc(_userUID)
        .collection('notification')
        .where('id', isEqualTo: notifId)
        .get()
        .then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        ds.reference.set({'isRead': true}, SetOptions(merge: true));
      }
    });
  }

  Future<void> setAllAsRead() async {
    for (var element in _notificationList) {
      notificationIdsForDismissal.add(element.id);
      element.isRead = true;
    }
    notifyListeners();
    _firestoreDb
        .collection('notifications')
        .doc(_userUID)
        .collection('notification')
        .where('isRead', isEqualTo: false)
        .get()
        .then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        ds.reference.set({'isRead': true}, SetOptions(merge: true));
      }
    });
  }

  Future<void> removeAllForDismissal() async {
    var idsToRemove =
        _undoDismissAll ? [] : List.from(notificationIdsForDismissal);

    debugPrint(
        'removing all for dismissal called ~ ${idsToRemove.length} items');
    _undoDismissAll = false;
    if (idsToRemove.isEmpty) return;
    for (var notifId in idsToRemove) {
      await _firestoreDb
          .collection('notifications')
          .doc(_userUID)
          .collection('notification')
          .where('id', isEqualTo: notifId)
          .get()
          .then((snapshot) {
        for (DocumentSnapshot ds in snapshot.docs) {
          ds.reference.delete();
        }
      });
    }
    notificationIdsForDismissal.clear();
    clearBadgeCount();
    _unreadCount = 0;
  }

  // void getUnreadNotificationsCountFromStream(String userId) {
  //   FirebaseFirestore.instance
  //       .collection('notifications')
  //       .doc(userId)
  //       .collection('notification')
  //       .snapshots()
  //       .listen((QuerySnapshot snapshot) {
  //     _unreadCount = 0;
  //     if (snapshot.docs.isNotEmpty) {
  //       _hasNotification = true;
  //     } else {
  //       _hasNotification = false;
  //     }
  //     for (var doc in snapshot.docs) {
  //       if (doc.exists && doc['isRead'] == false) {
  //         _unreadCount++;
  //       }
  //     }

  //     updateBadgeCount(_unreadCount);

  //     debugPrint('unread count: $_unreadCount');
  //     notifyListeners();
  //   });
  // }

  void getNotificationsFromStream(String userId) {
    debugPrint('getNotificationsFromStream called');
    FirebaseFirestore.instance
        .collection('notifications')
        .doc(userId)
        .collection('notification')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      _unreadCount = 0;
      debugPrint('snapshot length: ${snapshot.docs.length}');
      _notificationList = snapshot.docs
          .where((doc) =>
              doc['isDismissed'] != null ? doc["isDismissed"] == false : true)
          .map((doc) => NotificationData(
                id: doc["id"],
                title: doc["title"],
                body: doc["body"],
                timestamp: timestampToDateTime(doc["timestamp"]),
                isRead: doc["isRead"] as bool,
                data: doc["data"],
                imageUrl: doc["imageUrl"],
                isDismissed: doc['isDismissed'] != null
                    ? doc["isDismissed"] as bool
                    : false,
              ))
          .toList();
      if (snapshot.docs.isNotEmpty) {
        _hasNotification = true;
      } else {
        _hasNotification = false;
      }
      for (var doc in snapshot.docs) {
        if (doc.exists && doc['isRead'] == false) {
          _unreadCount++;
        }
      }

      updateBadgeCount(_unreadCount);

      debugPrint('unread count: $_unreadCount');
      notifyListeners();
    });
  }
}
