import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pzdeals/src/features/deals/models/index.dart';
import 'package:pzdeals/src/features/deals/services/fetch_deals.dart';

final tabPzPicksProvider =
    ChangeNotifierProvider<TabPzPicksNotifier>((ref) => TabPzPicksNotifier());

class TabPzPicksNotifier extends ChangeNotifier {
  final FetchProductDealService _productService = FetchProductDealService();
  final String _collectionName = 'flash';
  final String _boxName = 'flashdeals';
  bool _isLoading = false;
  bool _isrefreshing = false;
  int pageNumber = 1;
  List<ProductDealcardData> _products = [];

  bool get isLoading => _isLoading;
  bool get isRefreshing => _isrefreshing;
  List<ProductDealcardData> get products => _products;

  TabPzPicksNotifier() {
    _loadProducts();
  }

  Future<void> refreshDeals() async {
    _isLoading = true;
    _isrefreshing = true;
    notifyListeners();
    pageNumber = 1;
    try {
      final serverProducts = await _productService.fetchProductDeals(
          _collectionName, _boxName, pageNumber);
      _products = serverProducts;
      _isLoading = false;
      _isrefreshing = false;
      notifyListeners();
    } catch (e) {
      debugPrint("error loading products: $e");
    } finally {
      _isLoading = false;
      _isrefreshing = false;
      notifyListeners();
    }
  }

  Future<void> _loadProducts() async {
    _isLoading = true;
    notifyListeners();

    try {
      _products = await _productService.getCachedProducts(_boxName);
      notifyListeners();

      // if (_products.isNotEmpty) return;

      final serverProducts = await _productService.fetchProductDeals(
          _collectionName, _boxName, pageNumber);
      _products = serverProducts;
      notifyListeners();
    } catch (e) {
      debugPrint("error loading products: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMoreProducts() async {
    pageNumber++;
    _isLoading = true;
    notifyListeners();

    try {
      final serverProducts = await _productService.fetchMoreProductDeals(
          _collectionName, _boxName, pageNumber);
      _products.addAll(serverProducts);
      notifyListeners();
    } catch (e) {
      pageNumber--;
      debugPrint('error loading more products: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
