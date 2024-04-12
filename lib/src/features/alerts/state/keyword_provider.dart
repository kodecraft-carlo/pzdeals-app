import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pzdeals/src/features/alerts/models/index.dart';
import 'package:pzdeals/src/features/alerts/services/keyword_service.dart';
import 'package:pzdeals/src/state/auth_user_data.dart';

final keywordsProvider =
    ChangeNotifierProvider<KeywordsNotifier>((ref) => KeywordsNotifier(ref));

class KeywordsNotifier extends ChangeNotifier {
  final KeywordService _keywordService = KeywordService();
  Ref ref;
  KeywordsNotifier(this.ref) : super() {
    setUserUID();
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

  bool get isLoading => _isLoading;
  List<KeywordData> get savedkeywords => _savedkeywords;
  List<KeywordData> get popularKeywords => _popularKeywords;

  void setUserUID() {
    final authDataState = ref.watch(authUserDataProvider);
    debugPrint('setUserUID called with ${authDataState.userData!.uid}');
    _userUID = authDataState.userData!.uid;
    _boxName = '${_userUID}_keywords';
  }

  Future<void> loadSavedKeywords() async {
    _isLoading = true;
    notifyListeners();

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
      _popularKeywords =
          await _keywordService.getCachedKeywords(_boxNamePopular);
      _popularKeywords = sortKeywordsDescending(_popularKeywords);
      notifyListeners();

      final List<String> excludedKeywords =
          _savedkeywords.map((e) => e.keyword).toList();

      final serverKeywords = await _keywordService.fetchPopularKeyword(
          _boxNamePopular, 100, excludedKeywords, pageNumber);
      _popularKeywords = sortKeywordsDescending(serverKeywords);
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
          _savedkeywords.map((e) => e.keyword).toList();
      final serverKeywords = await _keywordService.fetchPopularKeyword(
          _boxNamePopular, 100, excludedKeywords, pageNumber);
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
    if (_savedkeywords.any((data) =>
        data.keyword.trim().toLowerCase() ==
        keyword.keyword.trim().toLowerCase())) {
      return false;
    }
    addKeyword(keyword);
    _savedkeywords.insert(0, keyword);
    _savedkeywords = _savedkeywords.toSet().toList();
    notifyListeners();
    Future.delayed(const Duration(seconds: 1), () {
      if (_popularKeywords.any((data) =>
          data.keyword.toLowerCase() == keyword.keyword.toLowerCase())) {
        _popularKeywords.removeWhere((data) =>
            data.keyword.toLowerCase() == keyword.keyword.toLowerCase());
        _popularKeywords = _popularKeywords.toSet().toList();
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
        return b.id.compareTo(a.id);
      });
  }

  List<KeywordData> removeSavedFromPopularList(
      List<KeywordData> savedKeywords, List<KeywordData> popularKeywords) {
    List<KeywordData> sortedKeywords = popularKeywords
        .where((element) => !savedKeywords.any((saved) =>
            saved.keyword.toLowerCase() == element.keyword.toLowerCase()))
        .toList();

    return sortKeywordsDescending(sortedKeywords);
  }
}
