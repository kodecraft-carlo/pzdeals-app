import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pzdeals/src/features/deals/models/index.dart';
import 'package:pzdeals/src/features/deals/services/fetch_deals.dart';

final tabFrontPageProvider = ChangeNotifierProvider<TabFrontPageNotifier>(
    (ref) => TabFrontPageNotifier());

class TabFrontPageNotifier extends ChangeNotifier {
  final FetchProductDealService _productService = FetchProductDealService();
  final String _collectionName = 'Front Page';
  final String _boxName = 'frontpage'; // collection: front page
  // final String _boxName = 'alldeals';
  int pageNumber = 1;
  bool _isLoading = false;
  bool _isrefreshing = false;

  List<ProductDealcardData> _products = [];

  bool get isLoading => _isLoading;
  bool get isRefreshing => _isrefreshing;
  List<ProductDealcardData> get products => _products;

  TabFrontPageNotifier() {
    loadProducts();
  }

  Future<void> refresh() async {
    pageNumber = 1;
    _isrefreshing = true;
    notifyListeners();
    refreshDeals();
  }

  Future<void> refreshDeals() async {
    pageNumber = 1;
    try {
      final serverProducts = await _productService.fetchProductDeals(
          _collectionName, _boxName, pageNumber);
      _products = serverProducts;
      _isrefreshing = false;
      notifyListeners();
    } catch (e) {
      debugPrint("error loading products: $e");
    } finally {
      _isrefreshing = false;
      notifyListeners();
    }
  }

  Future<void> loadProducts() async {
    _isLoading = true;
    notifyListeners();

    try {
      _products = await _productService.getCachedProducts(_boxName);
      notifyListeners();

      // if (_products.isNotEmpty) return;

      final serverProducts = await _productService.fetchProductDeals(
          _collectionName, _boxName, pageNumber); // collection: front page
      // final serverProducts =
      //     await _productService.fetchProductDealsAll(_boxName, pageNumber);
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
