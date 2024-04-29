import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pzdeals/src/features/deals/models/index.dart';
import 'package:pzdeals/src/features/deals/services/fetch_deals.dart';

final productCollectionProvider =
    ChangeNotifierProvider<ProductCollectionNotifier>(
        (ref) => ProductCollectionNotifier());

class ProductCollectionNotifier extends ChangeNotifier {
  final FetchProductDealService _productService = FetchProductDealService();
  String _collectionName = '';
  String _boxName = '';
  int pageNumber = 1;
  bool _isLoading = false;

  List<ProductDealcardData> _products = [];

  bool get isLoading => _isLoading;
  List<ProductDealcardData> get products => _products;

  void setBoxCollectionName(String collectionName, String boxName) {
    _collectionName = collectionName.replaceAll('&', '%26');
    _boxName = boxName;

    _loadProducts();
  }

  Future<void> refreshDeals() async {
    pageNumber = 1;

    try {
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

  Future<void> _loadProducts() async {
    _isLoading = true;
    pageNumber = 1;
    notifyListeners();
    _products.clear();
    try {
      _products = await _productService.getCachedProducts(_boxName);
      notifyListeners();

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
