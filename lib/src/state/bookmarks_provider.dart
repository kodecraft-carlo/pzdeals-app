import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pzdeals/src/features/deals/models/index.dart';
import 'package:pzdeals/src/services/bookmarks_service.dart';

class BookmarkedProductsNotifier extends ChangeNotifier {
  final BookmarksService _bookmarkService = BookmarksService();

  String _boxName = '';
  String _bookmarkedProductsBox = '';
  int pageNumber = 1;
  bool _isLoading = false;
  bool _isProductLoading = false;
  String _userUID = '';

  List<int> _bookmarks = [];
  List<ProductDealcardData> _products = [];

  bool get isLoading => _isLoading;
  bool get isProductLoading => _isProductLoading;
  List<int> get booksmarks => _bookmarks;
  List<ProductDealcardData> get products => _products;

  void setUserUID(String uid) {
    debugPrint('setUserUID called with $uid');
    _userUID = uid;
    _boxName = '${_userUID}_bookmarks';
    _bookmarkedProductsBox = '${_userUID}_bookmarked_products';
    // _loadBookmarks();
  }

  Future<void> loadCachedBookmarks() async {
    _isLoading = true;
    notifyListeners();

    try {
      _bookmarks = await _bookmarkService.getCachedBookmarks(_boxName);
      notifyListeners();
    } catch (e) {
      debugPrint("error loading cached bookmarks: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadBookmarks() async {
    _isLoading = true;
    notifyListeners();

    try {
      _bookmarks = await _bookmarkService.getCachedBookmarks(_boxName);
      notifyListeners();
      final serverBookmarks =
          await _bookmarkService.getBookmarks(_boxName, _userUID);
      _bookmarks = serverBookmarks;
      notifyListeners();
    } catch (e) {
      debugPrint("error loading bookmarks: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadProducts() async {
    _isProductLoading = true;
    notifyListeners();
    _products.clear();
    try {
      await _loadBookmarks();

      if (_bookmarks.isEmpty) {
        await _bookmarkService.removeProducts(
            _bookmarkedProductsBox, _bookmarks);
        notifyListeners();
      }
      final serverProducts = await _bookmarkService.fetchProductDeals(
          _bookmarks, _bookmarkedProductsBox, pageNumber);
      _products = serverProducts;
      notifyListeners();
    } catch (e) {
      debugPrint("error loading products: $e");
    } finally {
      _isProductLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMoreProducts() async {
    pageNumber++;
    _isProductLoading = true;
    notifyListeners();

    try {
      final serverProducts = await _bookmarkService.fetchProductDeals(
          _bookmarks, _bookmarkedProductsBox, pageNumber);
      _products.addAll(serverProducts);
      notifyListeners();
    } catch (e) {
      debugPrint('error loading more products: $e');
      pageNumber--;
    } finally {
      _isProductLoading = false;
      notifyListeners();
    }
  }

  Future<void> addBookmark(int productId) async {
    try {
      await _bookmarkService.addBookmark(productId, _boxName, _userUID);
      _bookmarks.add(productId);
      _bookmarks = _bookmarks.toSet().toList();
      notifyListeners();
    } catch (e) {
      debugPrint('error adding bookmark: $e');
    }
  }

  Future<void> removeBookmark(int productId) async {
    try {
      await _bookmarkService.removeBookmark(productId, _boxName, _userUID);
      _bookmarks.remove(productId);

      notifyListeners();
    } catch (e) {
      debugPrint('error removing bookmark: $e');
    }
  }

  void removeFromProductList(int productId) {
    _products.removeWhere((element) => element.productId == productId);
    notifyListeners();
  }

//initially add to local state then update firestore
  void addBookmarkLocally(int productId) {
    addBookmark(productId);
    _bookmarks.add(productId);
    _bookmarks = _bookmarks.toSet().toList();

    notifyListeners();
  }

//initially remove from local state then update firestore
  void removeBookmarkLocally(int productId) {
    removeBookmark(productId);
    _bookmarks.remove(productId);
    _bookmarks = _bookmarks.toSet().toList();
    notifyListeners();
    removeFromProductList(productId);
  }

  bool isBookmarked(int productId) {
    return _bookmarks.contains(productId);
  }

  void resetPageNumber() {
    pageNumber = 1;
  }
}
