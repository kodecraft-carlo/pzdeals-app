import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pzdeals/src/models/notification_data.dart_v2';
import 'package:pzdeals/src/utils/formatter/date_formatter.dart';

final notificationStreamProvider =
    StreamProvider.autoDispose<List<NotificationData>>((ref) {
  final firebaseAuth = FirebaseAuth.instance.currentUser;
  return FirebaseFirestore.instance
      .collection('notifications')
      .doc(firebaseAuth?.uid)
      .collection('notification')
      .orderBy('timestamp', descending: true)
      .snapshots()
      .map((snapshot) => snapshot.docs
          .where((doc) => doc.data().containsKey('isDismissed')
              ? doc["isDismissed"] == false
              : true)
          .map(
            (doc) => NotificationData(
              id: doc["id"],
              title: doc["title"],
              body: doc["body"],
              timestamp: timestampToDateTime(doc["timestamp"]),
              isRead: doc["isRead"] as bool,
              data: doc["data"],
              imageUrl: doc["imageUrl"],
              isDismissed: doc.data().containsKey('isDismissed')
                  ? doc["isDismissed"] as bool
                  : false,
            ),
          )
          .toList());
});
