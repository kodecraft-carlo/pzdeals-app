import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_installations/firebase_installations.dart';
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
  bool _disposed = false; // Step 1: Track the disposal state

  @override
  void dispose() {
    _disposed = true; // Set the disposed flag to true when disposed
    super.dispose();
  }

  final _firestoreDb = FirebaseFirestore.instance;

  List<String> notificationIdsForDismissal = [];
  List<NotificationData> _notificationList = [];

  int pageNumber = 1;
  String _userUID = '';
  int _unreadCount = 0;
  bool _hasNotification = false;
  bool _undoDismissAll = false;
  String? _instanceID = '';

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
    } else {
      debugPrint('User not logged in. using instanceID instead');
      setInstanceId();
    }
  }
  void setInstanceId() async {
    _instanceID = await FirebaseInstallations.id;
    _userUID = _instanceID!;
    debugPrint('Instance ID: $_instanceID');
    getNotificationsFromStream(_instanceID!);
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
      if (_disposed) return;
      _unreadCount = 0;
      debugPrint('snapshot length: ${snapshot.docs.length}');
      _notificationList = snapshot.docs
          .map((doc) {
            final data = doc.data() as Map<String, dynamic>? ?? {};
            final bool isDismissed = data['isDismissed'] == true;
            final bool isRead = data['isRead'] == true;
            return NotificationData(
              id: doc["id"],
              title: data['title'] ?? 'No Title',
              body: data['body'] ?? 'No Body',
              timestamp: timestampToDateTime(doc["timestamp"]),
              isRead: isRead,
              data: data['data'],
              imageUrl: data['imageUrl'],
              isDismissed: isDismissed,
            );
          })
          .where((notification) => !notification.isDismissed)
          .toList();

      _hasNotification = _notificationList.isNotEmpty;

      _unreadCount = _notificationList
          .where((notification) => !notification.isRead)
          .length;

      updateBadgeCount(_unreadCount);

      debugPrint('unread count: $_unreadCount');
      notifyListeners();
    });
  }

  Future<void> mergeNotifications(String userDoc, String instanceDoc) async {
    debugPrint(
        'mergeNotifications called userDoc: $userDoc, instanceDoc: $instanceDoc');
    // final collectionRef =
    //     FirebaseFirestore.instance.collection('notifications');

    // // Fetch both documents
    // final userDocSnapshot =
    //     await collectionRef.doc(userDoc).collection('notification').get();
    // final instanceDocSnapshot =
    //     await collectionRef.doc(instanceDoc).collection('notification').get();

    // debugPrint('userDataSnapshot exists: ${userDocSnapshot.docs.isNotEmpty}');
    // debugPrint(
    //     'instanceDataSnapshot exists: ${instanceDocSnapshot.docs.isNotEmpty}');
    // if (!userDocSnapshot.docs.isNotEmpty ||
    //     !instanceDocSnapshot.docs.isNotEmpty) {
    //   debugPrint('One or both documents do not exist');
    //   return;
    // }

    // // Assuming you want to merge all notifications from both users into a single user's document
    // List<Map<String, dynamic>> combinedNotifications = [];

    // // Iterate over the documents in the first user's notification collection
    // for (var doc in userDocSnapshot.docs) {
    //   combinedNotifications.add(doc.data());
    // }

    // // Iterate over the documents in the second user's notification collection
    // for (var doc in instanceDocSnapshot.docs) {
    //   combinedNotifications.add(doc.data());
    // }
    // for (var notification in combinedNotifications) {
    //   await collectionRef
    //       .doc(userDoc)
    //       .collection('notification')
    //       .doc()
    //       .set(notification);
    // }

    // // Optionally, delete the other document if it's no longer needed
    // await collectionRef.doc(instanceDoc).get().then((doc) {
    //   if (doc.exists) {
    //     doc.reference.delete();
    //   }
    // });
  }
}
