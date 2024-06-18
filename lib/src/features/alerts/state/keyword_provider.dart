import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pzdeals/src/features/alerts/models/index.dart';
import 'package:pzdeals/src/features/alerts/services/keyword_service.dart';
import 'package:pzdeals/src/state/auth_user_data.dart';
import 'package:pzdeals/src/utils/helpers/convert_string.dart';

final keywordsProvider =
    ChangeNotifierProvider<KeywordsNotifier>((ref) => KeywordsNotifier(ref));

class KeywordsNotifier extends ChangeNotifier {
  final KeywordService _keywordService = KeywordService();
  final _firebaseMessaging = FirebaseMessaging.instance;
  Ref ref;
  KeywordsNotifier(this.ref) : super() {
    setUserUID();
    loadCategoryKeywords();
    if (ref.watch(authUserDataProvider).userData != null) {
      loadSavedKeywords();
    }
  }
  String _boxName = '';
  final String _boxNamePopular = 'popular_keywords';
  int pageNumber = 1;
  int popularPageNumber = 1;
  int popularLimit = 9;
  bool _isLoading = false;
  String _userUID = '';

  List<KeywordData> _savedkeywords = [];
  List<KeywordData> _popularKeywords = [];
  List<String> categoryKeywords = [];

  bool get isLoading => _isLoading;
  List<KeywordData> get savedkeywords => _savedkeywords;
  List<KeywordData> get popularKeywords => _popularKeywords;

  void setUserUID() {
    final authDataState = ref.watch(authUserDataProvider);
    if (authDataState.userData == null) return;
    debugPrint('setUserUID called with ${authDataState.userData!.uid}');
    _userUID = authDataState.userData!.uid;
    _boxName = '${_userUID}_keywords';
  }

  Future<void> loadCategoryKeywords() async {
    try {
      final List<String> keywords =
          await _keywordService.fetchCategoryKeywords();
      categoryKeywords = keywords;
    } catch (e) {
      debugPrint('error loading category keywords: $e');
    }
  }

  Future<void> loadSavedKeywords() async {
    _isLoading = true;
    notifyListeners();

    if (_userUID.isEmpty) {
      return;
    }
    try {
      _savedkeywords = sortKeywordsDescending(
          await _keywordService.getCachedKeywords(_boxName));
      notifyListeners();
      final serverKeywords = await _keywordService.fetchSavedKeywords(
          _boxName, pageNumber, _userUID);
      _savedkeywords = sortKeywordsDescending(serverKeywords);
      notifyListeners();
    } catch (e) {
      debugPrint("error loading keywords: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMoreSavedKeywords() async {
    pageNumber++;
    _isLoading = true;
    notifyListeners();

    try {
      final serverKeywords = await _keywordService.fetchSavedKeywords(
          _boxName, pageNumber, _userUID);
      _savedkeywords.addAll(sortKeywordsDescending(serverKeywords));
      notifyListeners();
    } catch (e) {
      debugPrint('error loading more keywords: $e');
      pageNumber--;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadPopularKeywords() async {
    _isLoading = true;
    notifyListeners();

    try {
      // _popularKeywords =
      //     await _keywordService.getCachedKeywords(_boxNamePopular);
      // _popularKeywords = sortKeywordsDescending(_popularKeywords);
      // notifyListeners();

      final List<String> excludedKeywords = _userUID.isEmpty
          ? []
          : _savedkeywords.map((e) => urlEncodeAmpersand(e.keyword)).toList();

      final serverKeywords = await _keywordService.fetchPopularKeyword(
          _boxNamePopular, 500, excludedKeywords, pageNumber);

      if (_userUID.isEmpty) {
        _popularKeywords = sortKeywordsDescending(serverKeywords);
      } else {
        _popularKeywords =
            removeSavedFromPopularList(_savedkeywords, serverKeywords);
      }

      notifyListeners();
    } catch (e) {
      debugPrint("error loading popular keywords: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMorePopularKeywords() async {
    _isLoading = true;
    notifyListeners();

    try {
      _popularKeywords =
          await _keywordService.getCachedKeywords(_boxNamePopular);
      _popularKeywords = sortKeywordsDescending(_popularKeywords);
      notifyListeners();

      final List<String> excludedKeywords =
          _savedkeywords.map((e) => urlEncodeAmpersand(e.keyword)).toList();
      final serverKeywords = await _keywordService.fetchPopularKeyword(
          _boxNamePopular, 500, excludedKeywords, pageNumber);
      _popularKeywords = sortKeywordsDescending(serverKeywords);
      notifyListeners();
    } catch (e) {
      debugPrint("error loading popular keywords: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addKeyword(KeywordData keyword) async {
    try {
      final newKeyword =
          await _keywordService.addKeyword(keyword.keyword, _userUID, _boxName);
      // Check if any existing keyword matches the new keyword
      if (_savedkeywords.any((data) =>
          data.keyword.toLowerCase() == newKeyword.keyword.toLowerCase())) {
        _savedkeywords.removeWhere((data) =>
            data.keyword.toLowerCase() == newKeyword.keyword.toLowerCase());
        _savedkeywords.insert(0, newKeyword);
        _savedkeywords = _savedkeywords.toSet().toList();
        notifyListeners();
      }

      notifyListeners();
    } catch (e) {
      debugPrint('error adding keyword: $e');
    }
  }

  Future<void> removeKeyword(KeywordData keyword) async {
    try {
      await _keywordService.deleteKeyword(keyword.keyword, _userUID, _boxName);
      notifyListeners();
    } catch (e) {
      debugPrint('error removing keyword: $e');
    }
  }

  bool addKeywordLocally(KeywordData keyword, String addType) {
    debugPrint('addKeywordLocally called with ${keyword.keyword}');
    if (_savedkeywords.any((data) =>
        data.keyword.trim().toLowerCase() ==
        keyword.keyword.trim().toLowerCase())) {
      return false;
    }
    addKeyword(keyword);
    _savedkeywords.insert(0, keyword);
    _savedkeywords = _savedkeywords.toSet().toList();
    notifyListeners();
    //check first if the keyword is present in categorykeywords list:
    if (categoryKeywords.any((element) =>
        element.trim().toLowerCase() == keyword.keyword.trim().toLowerCase())) {
      debugPrint(
          'subscribing to ${keyword.keyword} ~ ${formatToValidTopic(keyword.keyword)}');
      String topicName = formatToValidTopic(keyword.keyword);
      _firebaseMessaging.subscribeToTopic(topicName);
    }

    Future.delayed(const Duration(seconds: 1), () {
      if (_popularKeywords.any((data) =>
          data.keyword.toLowerCase() == keyword.keyword.toLowerCase())) {
        _popularKeywords.removeWhere((data) =>
            data.keyword.toLowerCase() == keyword.keyword.toLowerCase());
        _popularKeywords = _popularKeywords.toSet().toList();
        _keywordService.removeKeywordFromCacheByKeywordName(
            keyword.keyword, _boxNamePopular);
      }
      notifyListeners();
    });

    return true;
  }

  void removeKeywordLocally(KeywordData keyword) {
    removeKeyword(keyword);
    _keywordService.removeKeywordFromCache(keyword.keyword, _boxName);
    _keywordService.removeKeywordFromCacheByKeywordName(
        keyword.keyword, _boxNamePopular);
    _savedkeywords.remove(keyword);
    _savedkeywords = _savedkeywords.toSet().toList();
    //check first if the keyword is present in categorykeywords list:
    if (categoryKeywords.any((element) =>
        element.trim().toLowerCase() == keyword.keyword.trim().toLowerCase())) {
      debugPrint(
          'unsubscribing from ${keyword.keyword} ~ ${formatToValidTopic(keyword.keyword)}');
      String topicName = formatToValidTopic(keyword.keyword);
      _firebaseMessaging.unsubscribeFromTopic(topicName);
    }
    notifyListeners();
  }

  void dispose() {
    _savedkeywords.clear();
    _popularKeywords.clear();
  }

  void resetPageNumber() {
    pageNumber = 1;
  }

  List<KeywordData> sortKeywordsDescending(List<KeywordData> keywords) {
    return keywords
      ..sort((a, b) {
        // Compare by type first, 'category' keywords come first
        int typeComparison =
            _typePriority(a.type).compareTo(_typePriority(b.type));
        if (typeComparison != 0) {
          return typeComparison;
        }
        // If types are the same, then compare by id in descending order
        return b.id.compareTo(a.id);
      });
  }

// Helper function to prioritize 'category' type
  int _typePriority(String type) {
    return type == 'category' ? 0 : 1;
  }

  List<KeywordData> removeSavedFromPopularList(
      List<KeywordData> savedKeywords, List<KeywordData> popularKeywords) {
    List<KeywordData> sortedKeywords = popularKeywords
        .where((element) => !savedKeywords.any((saved) =>
            saved.keyword.toLowerCase() == element.keyword.toLowerCase()))
        .toList();

    return sortKeywordsDescending(sortedKeywords);
  }

  String formatToValidTopic(String topic) {
    //remove the word 'deals' from the topic
    topic = topic.replaceAll(RegExp(r'deals'), '');
    //remove trailing and leading spaces
    topic = topic.trim();
    //remove special characters and convert to lowercase
    //convert home & kitchen to home_kitchen
    topic = topic.replaceAll(RegExp(r'[\W\s]+'), '_');
    return topic.toLowerCase();
  }
}
