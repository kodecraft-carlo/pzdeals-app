import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pzdeals/src/features/account/models/settings_data.dart';
import 'package:pzdeals/src/features/account/services/settings_service.dart';
import 'package:pzdeals/src/state/auth_user_data.dart';

final settingsProvider =
    ChangeNotifierProvider<SettingsNotifier>((ref) => SettingsNotifier(ref));

class SettingsNotifier extends ChangeNotifier {
  Ref ref;
  SettingsNotifier(this.ref) : super();
  final UserSettingsService _settingsService = UserSettingsService();
  final _firebaseMessaging = FirebaseMessaging.instance;

  String _boxName = '';
  bool _isLoading = false;
  String _userUID = '';
  int _numberOfAlerts = 0;

  SettingsData? _settingsData;

  bool get isLoading => _isLoading;
  SettingsData? get settingsData => _settingsData;
  int get numberOfAlerts => _numberOfAlerts;

  void setUserUID(String uid) {
    debugPrint('SettingsNotifier setUserUID called with $uid');
    _userUID = uid;
    _boxName = '${_userUID}_user_settings';
    loadUserSettings();
  }

  Future<void> loadUserSettings() async {
    _isLoading = true;
    notifyListeners();
    final authUserDataState = ref.watch(authUserDataProvider);
    final userId = authUserDataState.userData!.uid;
    _boxName = '${userId}_user_settings';
    try {
      _settingsData =
          await _settingsService.getCachedSettings(_boxName, userId);
      if (_settingsData != null) {
        notifyListeners();
      } else {
        final serverSettings =
            await _settingsService.fetchUserSettings(_boxName, userId);

        _settingsData = serverSettings;
        notifyListeners();
      }
    } catch (e, stackTrace) {
      debugPrint("error loading user settings: $stackTrace");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void updateSettingsLocally(dynamic setting, String settingType) async {
    final authUserDataState = ref.watch(authUserDataProvider);
    final userId = authUserDataState.userData!.uid;
    _boxName = '${userId}_user_settings';
    _isLoading = true;
    notifyListeners();
    _settingsData ??= SettingsData(
        priceMistake: false,
        frontpageNotification: false,
        percentageNotification: false,
        percentageThreshold: 0,
        numberOfAlerts: 0);
    try {
      switch (settingType) {
        case 'priceMistake':
          _settingsData?.setPriceMistake = setting;
          if (setting == true) {
            _firebaseMessaging.subscribeToTopic('price_mistake');
          } else {
            _firebaseMessaging.unsubscribeFromTopic('price_mistake');
          }
          break;
        case 'frontPage':
          dynamic alertCount = setting['alertCount'];
          if (setting['frontPage'] == true) {
            _settingsData?.setNumberOfAlerts =
                alertCount == 0 ? 10 : alertCount.round();
            _firebaseMessaging.subscribeToTopic('front_page');
          } else {
            _settingsData?.setNumberOfAlerts = 0;
            _firebaseMessaging.unsubscribeFromTopic('front_page');
          }
          _numberOfAlerts = _settingsData!.numberOfAlerts;
          _settingsData?.setFrontpageNotification = setting['frontPage'];
          break;
        case 'percentOff':
          dynamic threshold = setting['threshold'];
          if (setting['percentOff'] == true) {
            _settingsData?.setPercentageThreshold =
                int.parse(threshold) == 0 ? 50 : int.parse(threshold);
            _firebaseMessaging.subscribeToTopic('percent_off');
          } else {
            _settingsData?.setPercentageThreshold = 0;
            _firebaseMessaging.unsubscribeFromTopic('percent_off');
          }
          _settingsData?.setPercentageNotification = setting['percentOff'];
          break;
      }
      _settingsService.updateUserSettings(_boxName, userId, _settingsData!);

      notifyListeners();
    } catch (e) {
      debugPrint('error updating settings: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
