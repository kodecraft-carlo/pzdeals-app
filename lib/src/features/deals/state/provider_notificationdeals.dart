import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pzdeals/src/features/deals/models/index.dart';
import 'package:pzdeals/src/features/deals/services/search_products.dart';
import 'package:pzdeals/src/utils/queries/index.dart';

final notificationDealsProvider =
    ChangeNotifierProvider<NotificationDealsNotifier>(
        (ref) => NotificationDealsNotifier());

class NotificationDealsNotifier extends ChangeNotifier {
  final SearchProductService _searchproductService = SearchProductService();
  String _searchKey = '';
  String _boxName = '';
  String _dealType = '';
  int pageNumber = 1;
  bool _isLoading = false;
  String query = '';

  List<ProductDealcardData> _products = [];

  bool get isLoading => _isLoading;
  List<ProductDealcardData> get products => _products;
  String get searchKey => _searchKey;
  String get dealType => _dealType;

  void setDealType(String searchValue, String dealType) {
    _searchKey = searchValue;
    _dealType = dealType;
    _boxName = '${dealType}_deals';
    if (_dealType == 'percentage') {
      query =
          '${searchPercentageProductQuery(pageNumber)}&price_percentage_gt=$searchKey';
    } else if (_dealType == 'keyword') {
      query =
          // '${searchProductQuery(_searchKey, pageNumber)}&filter={"title": { "_icontains": "$_searchKey" }}';
          query = searchProductQuery(_searchKey, pageNumber);
    }
    if (searchKey.isNotEmpty) {
      loadProducts();
    }
  }

  Future<void> loadProducts() async {
    pageNumber = 1;
    _isLoading = true;
    notifyListeners();
    _products.clear();
    try {
      // debugPrint('searchProductWithCustomQuery query: $query');
      final serverProducts =
          await _searchproductService.searchProductWithCustomQuery(query);
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
      final serverProducts =
          await _searchproductService.searchProductWithCustomQuery(query);
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
