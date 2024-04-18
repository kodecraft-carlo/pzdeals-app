import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pzdeals/src/features/alerts/services/categorynotif_service.dart';
import 'package:pzdeals/src/state/auth_user_data.dart';

final categorySettingsProvider =
    ChangeNotifierProvider<CategorySettingsNotifier>(
        (ref) => CategorySettingsNotifier(ref));

class CategorySettingsNotifier extends ChangeNotifier {
  Ref ref;
  CategorySettingsNotifier(this.ref) : super();
  final CategoryNotifService _settingsService = CategoryNotifService();
  final _firebaseMessaging = FirebaseMessaging.instance;

  String _boxName = '';
  bool _isLoading = false;
  String _userUID = '';

  List? _settingsData;

  bool get isLoading => _isLoading;
  List? get settingsData => _settingsData;

  void setUserUID(String uid) {
    debugPrint('SettingsNotifier setUserUID called with $uid');
    _userUID = uid;
    _boxName = '${_userUID}_user_category_settings';
    loadUserSettings();
  }

  Future<void> loadUserSettings() async {
    _isLoading = true;
    notifyListeners();
    final authUserDataState = ref.watch(authUserDataProvider);
    final userId = authUserDataState.userData!.uid;
    _boxName = '${userId}_user_category_settings';
    try {
      _settingsData =
          await _settingsService.getCachedCategorySettings(_boxName, userId);
      if (_settingsData != null) {
        notifyListeners();
      } else {
        final serverSettings =
            await _settingsService.fetchUserCategorySettings(_boxName, userId);

        _settingsData = serverSettings;
        notifyListeners();
      }
    } catch (e) {
      debugPrint("error loading user settings: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void updateSettingsLocally(
      bool value, String collectionTitle, String topicName) async {
    final authUserDataState = ref.watch(authUserDataProvider);
    final userId = authUserDataState.userData!.uid;
    _boxName = '${userId}_user_category_settings';
    _isLoading = true;
    notifyListeners();

    debugPrint('updateSettingsLocally: $value, $topicName');
    if (value == true) {
      //add collectionTitle to _settingsData
      _settingsData?.add(topicName.toLowerCase());
      _firebaseMessaging.subscribeToTopic(topicName.toLowerCase());
    } else {
      //remove collectionTitle from _settingsData
      _settingsData?.remove(topicName.toLowerCase());
      _firebaseMessaging.unsubscribeFromTopic(topicName.toLowerCase());
    }
    removeDuplicates();
    debugPrint('updateSettingsLocally: $_settingsData');

    try {
      _settingsService.updateUserCategorySettings(
          _boxName, userId, _settingsData!);

      notifyListeners();
    } catch (e) {
      debugPrint('error updating settings: $e');
      _firebaseMessaging.unsubscribeFromTopic(topicName.toLowerCase());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  bool isSubscribed(String topicName) {
    return _settingsData?.contains(topicName.toLowerCase()) ?? false;
  }

  void removeDuplicates() {
    _settingsData = _settingsData?.toSet().toList();
    notifyListeners();
  }
}
