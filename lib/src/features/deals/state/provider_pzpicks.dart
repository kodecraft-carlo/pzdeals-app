import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pzdeals/src/features/deals/models/index.dart';
import 'package:pzdeals/src/features/deals/services/fetch_deals.dart';

final tabPzPicksProvider =
    ChangeNotifierProvider<TabPzPicksNotifier>((ref) => TabPzPicksNotifier());

class TabPzPicksNotifier extends ChangeNotifier {
  final FetchProductDealService _productService = FetchProductDealService();
  final String _collectionName = 'Flash Deals';
  final String _boxName = 'flashdeals';
  bool _isLoading = false;
  int pageNumber = 1;
  List<ProductDealcardData> _products = [];

  bool get isLoading => _isLoading;
  List<ProductDealcardData> get products => _products;

  TabPzPicksNotifier() {
    _loadProducts();
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
      final serverProducts = await _productService.fetchProductDeals(
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
