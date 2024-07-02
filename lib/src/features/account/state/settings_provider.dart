import 'dart:async';
import 'package:firebase_installations/firebase_installations.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pzdeals/src/features/account/models/settings_data.dart';
import 'package:pzdeals/src/features/account/services/instance_fcm_service.dart';
import 'package:pzdeals/src/features/account/services/settings_service.dart';
import 'package:pzdeals/src/features/notifications/state/notification_provider.dart';
import 'package:pzdeals/src/state/auth_user_data.dart';

final settingsProvider =
    ChangeNotifierProvider<SettingsNotifier>((ref) => SettingsNotifier(ref));

class SettingsNotifier extends ChangeNotifier {
  Ref ref;
  SettingsNotifier(this.ref) : super() {
    debugPrint('SettingsNotifier initialized');
    // Listen to changes in authUserDataProvider
    ref.listen<AuthUserData?>(authUserDataProvider, (_, authUserData) async {
      if (authUserData?.userData?.uid != null) {
        // User logged in, use UID as unique identifier
        setUserUID(authUserData!.userData!.uid);
        // Attempt to link settings from Firebase Instance ID to UID
        await linkSettingsToUID(authUserData.userData!.uid);
      } else {
        // User not logged in, use Firebase Instance ID
        setUserUID("");
        updateTopicSubscriptions();
        setFirebaseInstanceIdAsIdentifier();
      }
    });
  }
  final UserSettingsService _settingsService = UserSettingsService();
  final InstanceFcmService _instanceFcmService = InstanceFcmService();
  final _firebaseMessaging = FirebaseMessaging.instance;

  String _boxName = '';
  bool _isLoading = false;
  String _userUID = '';
  String? _instanceID = '';
  int _numberOfAlerts = 0;
  String? _fcmToken = '';
  bool isUserLoggedIn = false;

  SettingsData? _settingsData;

  bool get isLoading => _isLoading;
  SettingsData? get settingsData => _settingsData;
  int get numberOfAlerts => _numberOfAlerts;

  void setUserUID(String uid) {
    if (_userUID.isNotEmpty) {
      _boxName = '${_userUID}_user_settings';
      isUserLoggedIn = true;
    }
    debugPrint('SettingsNotifier setUserUID called with $uid');
    _userUID = uid;

    loadUserSettings();
  }

  Future<void> setFirebaseInstanceIdAsIdentifier() async {
    isUserLoggedIn = false;
    _instanceID = await FirebaseInstallations.id;
    _fcmToken = await _firebaseMessaging.getToken();
    debugPrint('instanceID: $_instanceID');
    _boxName = '${_instanceID}_user_settings';
    loadUserSettings();
  }

  Future<void> linkSettingsToUID(String uid) async {
    _instanceID = await FirebaseInstallations.id;
    _fcmToken = await _firebaseMessaging.getToken();
    final instanceIdBoxName = '${_instanceID}_user_settings';
    final uidBoxName = '${uid}_user_settings';

    // Fetch settings by Firebase Instance ID
    final instanceIdSettings = await _settingsService.getCachedSettings(
        instanceIdBoxName, _instanceID!);
    if (instanceIdSettings != null) {
      // Update settings with UID and clear cached settings associated with Firebase Instance ID
      await _settingsService.updateUserSettings(
          uidBoxName, uid, instanceIdSettings);
      await _settingsService.clearCachedSettings(instanceIdBoxName);
      await _settingsService.deleteInstanceSetting(_instanceID!);
      await _instanceFcmService.deleteFcmToken(_instanceID!);
      // Load the newly linked settings
      _boxName = uidBoxName;
      loadUserSettings();
    }
    ref.read(notificationsProvider).mergeNotifications(uid, _instanceID!);
  }

  Future<void> loadUserSettings() async {
    _isLoading = true;
    notifyListeners();
    _instanceID = await FirebaseInstallations.id;
    if (_userUID.isEmpty) {
      _userUID = _instanceID!;
    }

    _boxName = '${_userUID}_user_settings';
    try {
      _settingsData =
          await _settingsService.getCachedSettings(_boxName, _userUID);
      if (_settingsData != null) {
        notifyListeners();
      } else {
        final serverSettings =
            await _settingsService.fetchUserSettings(_boxName, _userUID);

        _settingsData = serverSettings;
        notifyListeners();
      }
      updateTopicSubscriptions();
    } catch (e, stackTrace) {
      debugPrint("error loading user settings: $stackTrace");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void updateSettingsLocally(dynamic setting, String settingType) async {
    if (_userUID.isEmpty) {
      _userUID = _instanceID!;
    }
    // final authUserDataState = ref.watch(authUserDataProvider);
    // final userId = authUserDataState.userData!.uid;
    _boxName = '${_userUID}_user_settings';
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
      _settingsService.updateUserSettings(_boxName, _userUID, _settingsData!);
      notifyListeners();
      if (!isUserLoggedIn) {
        _fcmToken = await _firebaseMessaging.getToken();
        _instanceFcmService.updateInstanceFcmToken(_fcmToken!, _userUID);
      }
    } catch (e) {
      debugPrint('error updating settings: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void resetTopics() {
    debugPrint('resetTopics called');
    _firebaseMessaging.unsubscribeFromTopic('price_mistake');
    _firebaseMessaging.unsubscribeFromTopic('front_page');
    _firebaseMessaging.unsubscribeFromTopic('percent_off');
  }

  void updateTopicSubscriptions() {
    resetTopics();
    debugPrint('updateTopicSubscriptions called');
    if (_settingsData?.priceMistake == true) {
      _firebaseMessaging.subscribeToTopic('price_mistake');
      debugPrint('Subscribed to price_mistake topic');
    }
    if (_settingsData?.frontpageNotification == true) {
      _firebaseMessaging.subscribeToTopic('front_page');
      debugPrint('Subscribed to front_page topic');
    }
    if (_settingsData?.percentageNotification == true) {
      _firebaseMessaging.subscribeToTopic('percent_off');
      debugPrint('Subscribed to percent_off topic');
    }
  }
}
