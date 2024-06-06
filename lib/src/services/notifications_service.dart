import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:pzdeals/src/models/index.dart';
import 'package:pzdeals/src/utils/formatter/index.dart';
import 'package:pzdeals/src/utils/http/http_client.dart';

class NotificationService {
  final _firestoreDb = FirebaseFirestore.instance;
  User? user;
  final _firebaseMessaging = FirebaseMessaging.instance;
  final _firebaseAuth = FirebaseAuth.instance.currentUser;
  DocumentSnapshot? lastDoc;
  NotificationService() {
    FirebaseAuth.instance.authStateChanges().listen((User? currentUser) {
      debugPrint(
          'NotificationService: User is logged in ~ ${currentUser?.uid}');
      user = currentUser;
    });
  }

  Future<List<NotificationData>> getInitialNotifications(String boxName) async {
    try {
      if (user != null) {
        debugPrint('getInitialNotifications: User is logged in ~ ${user?.uid}');
        final snapshot = await _firestoreDb
            .collection('notifications')
            .doc(user?.uid)
            .collection('notification')
            .orderBy('timestamp', descending: true)
            .limit(20)
            .get();
        if (snapshot.docs.isNotEmpty) {
          debugPrint(
              'getInitialNotifications: ${snapshot.docs.length} notifications');
          _cacheNotifications(snapshot.docs, boxName);
          lastDoc = snapshot.docs.last;
          return snapshot.docs
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
        } else {
          debugPrint('getInitialNotifications: No notifications found');
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

  Future<List<NotificationData>> getMoreNotifications(String boxName) async {
    debugPrint('getMoreNotifications called for $boxName');
    try {
      if (user != null) {
        final snapshot = await _firestoreDb
            .collection('notifications')
            .doc(user?.uid)
            .collection('notification')
            .orderBy('timestamp', descending: true)
            .startAfterDocument(lastDoc as DocumentSnapshot)
            .limit(20)
            .get();
        if (snapshot.docs.isNotEmpty) {
          // _cacheNotifications(snapshot.docs, boxName);
          lastDoc = snapshot.docs.last;
          return snapshot.docs
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
        }
        debugPrint('list is empty');
        return [];
      } else {
        debugPrint('getMoreNotifications: User is not logged in');
      }
      return [];
    } catch (e, stackTrace) {
      debugPrint("Error fetching getMoreNotifications data: $stackTrace");
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

  Future<void> markAllNotificationsAsRead(String boxName) async {
    try {
      if (user != null) {
        await _firestoreDb
            .collection('notifications')
            .doc(user?.uid)
            .collection('notification')
            .get()
            .then((snapshot) {
          for (DocumentSnapshot ds in snapshot.docs) {
            ds.reference.update({'isRead': true});
          }
        });
      } else {
        debugPrint('markAllNotificationsAsRead: User is not logged in');
      }
    } catch (e) {
      debugPrint("Error marking all notifications as read: $e");
      throw Exception('Error marking all notifications as read');
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

        //update notification received info only when data['alert_type'] is 'front-page'
        if (notification.data['alert_type'] == 'front-page') {
          await updateFrontPageNotificationReceivedInfo(user?.uid);
        }
      } else if (_firebaseAuth?.uid != null) {
        await _firestoreDb
            .collection('notifications')
            .doc(_firebaseAuth?.uid)
            .collection('notification')
            .add(notification.toMap());

        //update notification received info only when data['alert_type'] is 'front-page'
        if (notification.data['alert_type'] == 'front-page') {
          await updateFrontPageNotificationReceivedInfo(_firebaseAuth?.uid);
        }
        debugPrint(
            'addNotification: User from snapshot is logged in ~ ${_firebaseAuth?.uid}');
      } else {
        debugPrint('addNotification: User is not logged in');
      }
    } catch (e) {
      debugPrint("Error adding notification data: $e");
      throw Exception('Error adding notification data');
    }
  }

//update notificationreceivedcount and lastnotificationreceivedtimestamp
  Future<void> updateFrontPageNotificationReceivedInfo(String? userId) async {
    ApiClient apiClient = ApiClient();
    try {
      final int id = await getSettingsId(userId!);
      if (id == 0) return;

      //fetch notification count and notification received timestamp via userid
      final Response notifInfoResponse = await apiClient.dio.get(
        '/items/notification_settings/$id',
        // options: Options(
        //   headers: {'Authorization': 'Bearer $accessToken'},
        // ),
      );

      if (notifInfoResponse.statusCode == 200) {
        final notifInfoResponseData = notifInfoResponse.data["data"];
        int notificationReceivedCount =
            notifInfoResponseData['deliveredNotificationCount'] ?? 0;
        int frontpageNotificationAlertsLimit =
            notifInfoResponseData['alerts_count'] ?? 10;

        notificationReceivedCount = notificationReceivedCount + 1;
        //unsubscribe user if notification received count is greater than frontpageNotificationAlertsLimit
        if (frontpageNotificationAlertsLimit < 30) {
          if (notificationReceivedCount >= frontpageNotificationAlertsLimit) {
            _firebaseMessaging.unsubscribeFromTopic('front_page');
          }
        }
        final Response response = await apiClient.dio.patch(
          '/items/notification_settings/$id',
          data: {
            'deliveredNotificationCount': notificationReceivedCount,
            'lastNotificationReceivedOn': DateTime.now().toIso8601String()
          },
          // options: Options(
          //   headers: {'Authorization': 'Bearer $accessToken'},
          // ),
        );

        if (response.statusCode != 200) {
          throw Exception(
              'Unable to update user settings ${response.statusCode} ~ ${response.data}');
        }
      }
    } on DioException catch (e) {
      debugPrint("DioException: ${e.message}");
      throw Exception('Failed to update user settings');
    } catch (e) {
      debugPrint('Error updating user settings: $e');
      throw Exception('Failed to update user settings');
    }
  }

  Future<void> resetNotificationReceivedInfo() async {
    ApiClient apiClient = ApiClient();
    try {
      if (user != null) {
        final userId = user?.uid;
        final int id = await getSettingsId(userId!);
        if (id == 0) return;

        final Response response = await apiClient.dio.patch(
          '/items/notification_settings/$id',
          data: {
            'deliveredNotificationCount': 0,
            'lastNotificationReceivedOn': DateTime.now().toIso8601String()
          },
          // options: Options(
          //   headers: {'Authorization': 'Bearer $accessToken'},
          // ),
        );
        _firebaseMessaging.subscribeToTopic('front_page');

        if (response.statusCode != 200) {
          throw Exception(
              'Unable to update user settings ${response.statusCode} ~ ${response.data}');
        }
      } else {
        debugPrint('addNotification: User is not logged in');
      }
    } on DioException catch (e) {
      debugPrint("DioException: ${e.message}");
      throw Exception('Failed to update user settings');
    } catch (e) {
      debugPrint('Error updating user settings: $e');
      throw Exception('Failed to update user settings');
    }
  }

  Future<int> getSettingsId(String userId) async {
    ApiClient apiClient = ApiClient();
    // final authService = ref.watch(directusAuthServiceProvider);
    try {
      Response response = await apiClient.dio
          .get('/items/notification_settings/?filter[user_id]=$userId'
              // options: Options(
              //   headers: {'Authorization': 'Bearer $accessToken'},
              // ),
              );
      if (response.statusCode == 200) {
        final responseData = response.data["data"];
        if (responseData == null ||
            responseData.isEmpty ||
            responseData.length <= 0) {
          return 0;
        }
        return responseData[0]["id"];
      } else {
        throw Exception(
            'Failed to fetch directus settings id ${response.statusCode} ~ ${response.data}');
      }
    } on DioException catch (e) {
      debugPrint("DioExceptionw: ${e.message}");
      throw Exception('Failed to fetch directus settings id');
    } catch (e) {
      debugPrint('Error fetching directus settings id: $e');
      throw Exception('Failed to fetch directus settings id');
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
    List<NotificationData> notifications0 = notifications
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
    Box<NotificationData> box;
    if (Hive.isBoxOpen(boxName)) {
      box = Hive.box<NotificationData>(boxName);
    } else {
      box = await Hive.openBox<NotificationData>(boxName);
    }
    await box.clear();
    box.addAll(notifications0);
  }

  Future<List<NotificationData>> getNotificationFromCache(
      String boxName) async {
    debugPrint("getNotificationFromCache called for $boxName");
    Box<NotificationData> box;
    if (Hive.isBoxOpen(boxName)) {
      box = Hive.box<NotificationData>(boxName);
    } else {
      box = await Hive.openBox<NotificationData>(boxName);
    }
    List<NotificationData> cachedNotifications = box.values.toList();
    return cachedNotifications;
  }

  Future removeAllNotificationFromCache(String boxName) async {
    debugPrint("removeAllNotificationFromCache called for $boxName");
    Box<NotificationData> box;
    if (Hive.isBoxOpen(boxName)) {
      box = Hive.box<NotificationData>(boxName);
    } else {
      box = await Hive.openBox<NotificationData>(boxName);
    }
    try {
      await box.clear();
      debugPrint('All notifications have been removed from the box.');
    } catch (e) {
      debugPrint('Error removing items: $e');
    } finally {
      await box.close();
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
  //listen to notification changes
}
