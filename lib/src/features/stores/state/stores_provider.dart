import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pzdeals/src/features/stores/services/store_service.dart';
import 'package:pzdeals/src/models/index.dart';

final storescreenProvider =
    ChangeNotifierProvider<StoreScreenProvider>((ref) => StoreScreenProvider());

class StoreScreenProvider extends ChangeNotifier {
  final StoreScreenService _storeSvc = StoreScreenService();
  final String _boxName = 'screen_pzstores';
  bool _isLoading = false;
  int pageNumber = 1;
  List<StoreData> _stores = [];
  List<StoreData> _filteredStores = [];
  List<String> _storeNames = [];

  bool get isLoading => _isLoading;
  List<StoreData> get stores => _stores;
  List<StoreData> get filteredStores => _filteredStores;
  List<String> get storeNames => _storeNames;

  StoreScreenProvider() {
    loadStores();
  }

  Future<void> refresh() async {
    loadStores();
  }

  Future<void> refreshStores() async {
    pageNumber = 1;
    try {
      _stores.clear();
      // _stores = await _storeSvc.getCachedStores(_boxName);
      // notifyListeners();

      final serverStores =
          await _storeSvc.fetchStoreCollection(_boxName, pageNumber);
      _stores = serverStores;
      setStoreNames();
      notifyListeners();
    } catch (e) {
      debugPrint("error loading stores: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadStores() async {
    _isLoading = true;
    pageNumber = 1;
    notifyListeners();

    try {
      _stores = await _storeSvc.getCachedStores(_boxName);
      notifyListeners();

      final serverStores =
          await _storeSvc.fetchStoreCollection(_boxName, pageNumber);
      _stores = serverStores;
      setStoreNames();
      notifyListeners();
    } catch (e) {
      debugPrint("error loading stores: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMoreStores() async {
    pageNumber++;
    _isLoading = true;
    notifyListeners();
    try {
      final serverStores =
          await _storeSvc.fetchStoreCollection(_boxName, pageNumber);
      _stores.addAll(serverStores);
      setStoreNames();
      notifyListeners();
    } catch (e) {
      pageNumber--;
      debugPrint('error loading more stores: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void filterStores(String query) {
    // Helper function to remove apostrophes and other special characters
    String sanitizeString(String str) {
      return str.replaceAll(RegExp("[^a-zA-Z0-9]"), "").toLowerCase();
    }

    _filteredStores = _stores
        .where((store) =>
            sanitizeString(store.storeName).contains(sanitizeString(query)))
        .toList();
    notifyListeners();
  }

  void clearFilter() {
    _filteredStores = _stores;
    notifyListeners();
  }

  void setStoreNames() {
    _storeNames = _stores.map((store) => store.storeName).toList();
    notifyListeners();
  }
}
