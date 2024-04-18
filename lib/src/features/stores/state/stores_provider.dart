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
    _loadStores();
  }

  Future<void> refreshStores() async {
    try {
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

  Future<void> _loadStores() async {
    _isLoading = true;
    notifyListeners();

    try {
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
    _filteredStores = _stores
        .where((store) =>
            store.storeName.toLowerCase().contains(query.toLowerCase()))
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
