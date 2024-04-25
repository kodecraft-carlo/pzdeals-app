import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pzdeals/src/features/deals/models/index.dart';
import 'package:pzdeals/src/features/deals/services/search_products.dart';

final searchproductProvider = ChangeNotifierProvider<SearchProductNotifier>(
    (ref) => SearchProductNotifier());

class SearchProductNotifier extends ChangeNotifier {
  final SearchProductService _searchproductService = SearchProductService();
  String _searchKey = '';
  int pageNumber = 1;
  bool _isLoading = false;
  String _filters = '';

  List<ProductDealcardData> _products = [];
  List<SearchDiscoveryData> _searchDiscovery = [];

  bool get isLoading => _isLoading;
  List<ProductDealcardData> get products => _products;
  List<SearchDiscoveryData> get searchDiscovery => _searchDiscovery;
  String get searchKey => _searchKey;

  void setSearchKey(String searchKey) {
    _searchKey = searchKey;
    if (searchKey.isNotEmpty) {
      loadProducts();
    }
  }

  SearchProductNotifier() {
    loadSearchDiscovery();
  }

  Future<void> loadSearchDiscovery() async {
    try {
      _searchDiscovery = await _searchproductService.fetchSearchDiscovery();
      notifyListeners();
    } catch (e) {
      debugPrint('error loading search discovery: $e');
    }
  }

  Future<void> loadProducts() async {
    pageNumber = 1;
    _isLoading = true;
    notifyListeners();
    _products.clear();
    try {
      final serverProducts = await _searchproductService.searchProduct(
          _searchKey, pageNumber, _filters);
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
      final serverProducts = await _searchproductService.searchProduct(
          _searchKey, pageNumber, _filters);
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

  void setFilters(String filters) {
    _filters = filters;
  }
}
