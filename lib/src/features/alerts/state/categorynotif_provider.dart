import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pzdeals/src/features/alerts/services/categorynotif_service.dart';
import 'package:pzdeals/src/features/deals/models/index.dart';
import 'package:pzdeals/src/features/deals/services/fetch_collections.dart';
import 'package:pzdeals/src/state/auth_user_data.dart';

final categorySettingsProvider =
    ChangeNotifierProvider<CategorySettingsNotifier>(
        (ref) => CategorySettingsNotifier(ref));

class CategorySettingsNotifier extends ChangeNotifier {
  Ref ref;
  CategorySettingsNotifier(this.ref) : super();
  final CategoryNotifService _settingsService = CategoryNotifService();
  final FetchCollectionService _collectionService = FetchCollectionService();
  final _firebaseMessaging = FirebaseMessaging.instance;

  String _boxName = '';
  final String _collectionListBoxName = 'category_alerts_list';
  bool _isLoading = false;
  String _userUID = '';
  bool _isCollectionLoading = false;

  List<dynamic> _settingsData = [];
  List<CollectionData> _collections = [];

  bool get isLoading => _isLoading;
  List? get settingsData => _settingsData;
  List get collections => _collections;
  bool get isCollectionLoading => _isCollectionLoading;

  void setUserUID(String uid) {
    if (uid.isEmpty) return;
    debugPrint('SettingsNotifier setUserUID called with $uid');
    _userUID = uid;
    _boxName = '${_userUID}_user_category_settings';
    loadUserSettings();
  }

  Future<void> loadCollections() async {
    try {
      final cachedCollections =
          await _collectionService.getCachedCollection(_collectionListBoxName);
      _collections = cachedCollections;
      if (settingsData != null) {
        for (int i = 0; i < _collections.length; i++) {
          final collection = _collections[i];
          final isSubscribed = settingsData!
              .contains(formatToValidTopic(collection.keyword ?? ''));
          collection.isSubscribed = isSubscribed;
        }
      }
      notifyListeners();

      final serverCollection =
          await _collectionService.fetchCollections(_collectionListBoxName);
      _collections = serverCollection;
      //check for occurence of tag in settingsData to update isSubscribed to true/false
      if (settingsData != null) {
        for (int i = 0; i < _collections.length; i++) {
          final collection = _collections[i];
          final isSubscribed = settingsData!
              .contains(formatToValidTopic(collection.keyword ?? ''));
          collection.isSubscribed = isSubscribed;
        }
      }
      notifyListeners();
    } catch (e, stackTrace) {
      debugPrint("error loading collections: $stackTrace");
    } finally {
      _isCollectionLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadUserSettings() async {
    _isLoading = true;
    notifyListeners();
    final authUserDataState = ref.watch(authUserDataProvider);
    if (authUserDataState.userData == null) {
      loadCollections();
      return;
    }

    final userId = authUserDataState.userData!.uid;
    _boxName = '${userId}_user_category_settings';
    try {
      _settingsData =
          await _settingsService.getCachedCategorySettings(_boxName, userId);
      if (_settingsData.isNotEmpty) {
        debugPrint('fetching user settings from cache');
        loadCollections();
      } else {
        debugPrint('fetching user settings from server');
        final serverSettings =
            await _settingsService.fetchUserCategorySettings(_boxName, userId);

        if (serverSettings.isNotEmpty) {
          _settingsData = serverSettings;
        }
        loadCollections();
      }
    } catch (e, stackTrace) {
      debugPrint("error loading user settings: $stackTrace");
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

    topicName = formatToValidTopic(topicName);
    debugPrint('updateSettingsLocally: $value, $topicName');
    if (value == true) {
      debugPrint('subscribing to $topicName');
      //add collectionTitle to _settingsData
      _settingsData.add(topicName);
      debugPrint('added to _settingsData: $_settingsData');
      _firebaseMessaging.subscribeToTopic(topicName);
      _collections
          .firstWhere((element) =>
              formatToValidTopic(element.keyword ?? '') == topicName)
          .isSubscribed = true;
    } else {
      //remove collectionTitle from _settingsData
      _settingsData.remove(topicName);
      _firebaseMessaging.unsubscribeFromTopic(topicName);
      _collections
          .firstWhere((element) =>
              formatToValidTopic(element.keyword ?? '') == topicName)
          .isSubscribed = false;
    }
    notifyListeners();
    removeDuplicates();
    debugPrint('updateSettingsLocally: $_settingsData');

    try {
      _settingsService.updateUserCategorySettings(
          _boxName, userId, _settingsData);

      // notifyListeners();
    } catch (e, stackTrace) {
      debugPrint('error updating settings: $stackTrace');
      _firebaseMessaging.unsubscribeFromTopic(topicName.toLowerCase());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  String formatToValidTopic(String topic) {
    //remove special characters and convert to lowercase
    //convert home & kitchen to home_kitchen
    topic = topic.replaceAll(RegExp(r'[\W\s]+'), '_');
    return topic.toLowerCase();
  }

  bool isSubscribed(String topicName) {
    return _settingsData.isNotEmpty &&
        _settingsData.contains(topicName.toLowerCase());
  }

  void removeDuplicates() {
    _settingsData = _settingsData.toSet().toList();
    notifyListeners();
  }
}
