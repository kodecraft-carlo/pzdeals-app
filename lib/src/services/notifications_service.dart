import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:pzdeals/src/models/index.dart';

class NotificationService {
  final _firestoreDb = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;

  Future<List<DocumentSnapshot>> getInitialNotifications(String boxName) async {
    try {
      if (user != null) {
        debugPrint('getInitialNotifications: User is logged in ~ ${user?.uid}');
        final snapshot = await _firestoreDb
            .collection('notifications')
            .doc(user?.uid)
            .collection('notification')
            .orderBy('timestamp', descending: true)
            .limit(10)
            .get();
        if (snapshot.docs.isNotEmpty) {
          // _cacheNotifications(snapshot.docs, boxName);
          return snapshot.docs;
        }
        return [];
      } else {
        debugPrint('getInitialNotifications: User is not logged in');
      }
      return [];
    } catch (e) {
      debugPrint("Error fetching notifications data: $e");
    }
    throw Exception('getInitialNotifications error');
  }

  Future<List<DocumentSnapshot>> getMoreNotifications(
      String boxName, DocumentSnapshot lastDoc) async {
    try {
      if (user != null) {
        final snapshot = await _firestoreDb
            .collection('notifications')
            .doc(user?.uid)
            .collection('notification')
            .orderBy('timestamp', descending: true)
            .startAfterDocument(lastDoc)
            .limit(10)
            .get();
        if (snapshot.docs.isNotEmpty) {
          // _cacheNotifications(snapshot.docs, boxName);
          return snapshot.docs;
        }
        return [];
      } else {
        debugPrint('getMoreNotifications: User is not logged in');
      }
      return [];
    } catch (e) {
      debugPrint("Error fetching getMoreNotifications data: $e");
    }
    throw Exception('getMoreNotifications error');
  }

  Future<void> updateNotifications(
      NotificationData notif, String notifId, String boxName) async {
    try {
      if (user != null) {
        // await _firestoreDb
        //     .collection('notifications')
        //     .doc(user?.uid)
        //     .collection('notification')
        //     .doc(notifId)
        //     .set(notif.toMap());

        await _firestoreDb
            .collection('notifications')
            .doc(user?.uid)
            .collection('notification')
            .where('id', isEqualTo: notifId)
            .get()
            .then((snapshot) {
          for (DocumentSnapshot ds in snapshot.docs) {
            ds.reference.set(notif.toMap());
          }
        });
      } else {
        debugPrint('updateNotifications: User is not logged in');
      }
    } catch (e) {
      debugPrint("Error updating notification data: $e");
      throw Exception('Error updating notification data');
    }
  }

  Future addNotification(NotificationData notification, String boxName) async {
    try {
      if (user != null) {
        debugPrint('addNotification: User is logged in ~ ${user?.uid}');
        await _firestoreDb
            .collection('notifications')
            .doc(user?.uid)
            .collection('notification')
            .add(notification.toMap());
      } else {
        debugPrint('addNotification: User is not logged in');
      }
    } catch (e) {
      debugPrint("Error adding notification data: $e");
      throw Exception('Error adding notification data');
    }
  }

  Future deleteNotification(String notifId, String boxName) async {
    try {
      if (user != null) {
        await _firestoreDb
            .collection('notifications')
            .doc(user?.uid)
            .collection('notification')
            .where('id', isEqualTo: notifId)
            .get()
            .then((snapshot) {
          for (DocumentSnapshot ds in snapshot.docs) {
            ds.reference.delete();
          }
        });
      } else {
        debugPrint('deleteNotification: User is not logged in');
      }
    } catch (e) {
      debugPrint("Error deleting notification data: $e");
      throw Exception('Error deleting notification data');
    }
  }

  Future deleteAllNotifications(String boxName) async {
    try {
      if (user != null) {
        await _firestoreDb
            .collection('notifications')
            .doc(user?.uid)
            .collection('notification')
            .get()
            .then((snapshot) {
          for (DocumentSnapshot ds in snapshot.docs) {
            ds.reference.delete();
          }
        });
      } else {
        debugPrint('deleteAllNotifications: User is not logged in');
      }
    } catch (e) {
      debugPrint("Error deleting all notification data: $e");
      throw Exception('Error deleting all notification data');
    }
  }

  Future<NotificationData> getNotification(
      String notifId, String boxName) async {
    try {
      if (user != null) {
        final snapshot = await _firestoreDb
            .collection('notifications')
            .doc(user?.uid)
            .collection('notification')
            .doc(notifId)
            .get();
        if (snapshot.exists) {
          final notification = NotificationData(
            id: snapshot["id"],
            title: snapshot["title"],
            body: snapshot["body"],
            timestamp: snapshot["timestamp"],
            isRead: snapshot["isRead"] as bool,
            imageUrl: snapshot["imageUrl"],
          );
          return notification;
        }
        throw Exception('Notification not found');
      } else {
        debugPrint('getNotification: User is not logged in');
      }
      throw Exception('Notification not found');
    } catch (e) {
      debugPrint("Error fetching notification data: $e");
      throw Exception('Error fetching notification data');
    }
  }

  Future<List<DocumentSnapshot>> getCachedNotifications(String boxName) async {
    debugPrint("getCachedNotifications called for $boxName");
    final box = await Hive.openBox<DocumentSnapshot>(boxName);
    final notifications = box.values.toList();
    await box.close();
    return notifications;
  }

  Future<void> _cacheNotifications(
      List<DocumentSnapshot> notifications, String boxName) async {
    debugPrint("Caching notifications for $boxName");
    final box = await Hive.openBox<DocumentSnapshot>(boxName);
    await box.clear(); // Clear existing cache
    for (final notif in notifications) {
      box.put(notif['id'], notif);
    }
  }

  Future removeNotificationFromCache(String boxName, String notifId) async {
    debugPrint("removeCachedProducts called for $boxName");
    final box = await Hive.openBox<DocumentSnapshot>(boxName);
    try {
      List<DocumentSnapshot> items = box.values.toList();

      for (var item in items) {
        String itemId = item['id'];

        if (notifId == itemId) {
          await box.delete(item.id);
          debugPrint(
              'Notification with ID $itemId has been removed from the box.');
        }
      }
    } catch (e) {
      debugPrint('Error removing items: $e');
    } finally {
      await box.close();
    }
  }
}
