import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';

Future<void> updateBadgeCount(int count) async {
  try {
    final bool isSupported = await FlutterAppBadger.isAppBadgeSupported();
    if (!isSupported) return;
    await FlutterAppBadger.updateBadgeCount(count);
  } catch (e) {
    debugPrint('error updating badge count: $e');
  }
}

Future<void> clearBadgeCount() async {
  try {
    final bool isSupported = await FlutterAppBadger.isAppBadgeSupported();
    if (!isSupported) return;
    await FlutterAppBadger.removeBadge();
  } catch (e) {
    debugPrint('error clearing badge count: $e');
  }
}
