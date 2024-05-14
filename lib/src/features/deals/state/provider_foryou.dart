import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pzdeals/src/features/deals/models/index.dart';
import 'package:pzdeals/src/features/deals/services/fetch_collections.dart';
import 'package:pzdeals/src/features/deals/services/fetch_foryou.dart';

final tabForYouProvider =
    ChangeNotifierProvider<TabForYouNotifier>((ref) => TabForYouNotifier());

class TabForYouNotifier extends ChangeNotifier {
  final FetchCollectionService _collectionService = FetchCollectionService();
  final FetchForYouService _forYouService = FetchForYouService();

  final String _boxName = 'foryoucollections';
  bool _isLoading = false;
  bool _isForYouLoading = false;
  bool _isForYouCollectionProductsLoading = false;
  List<CollectionData> _collections = [];
  final List<Map<String, dynamic>> _selectedCollectionIds = [];
  final List<Map<String, dynamic>> _collectionsMap = [];
  bool _isSelectionApplied = false;
  final List<Map<String, dynamic>> _defaultCollections = [
    {'collection_id': 4, 'collection_name': 'Flash'},
    {'collection_id': 8, 'collection_name': 'Tech'},
    {'collection_id': 10, 'collection_name': 'Home'}
  ];
  List<ProductDealcardData> _foryouProducts = [];

  //List of collections with their respective products
  final List<Map<String, dynamic>> _collectionProducts = [];

  bool get isLoading => _isLoading;
  bool get isForYouLoading => _isForYouLoading;
  List<CollectionData> get collections => _collections;
  List<Map<String, dynamic>> get selectedCollectionIds =>
      _selectedCollectionIds;
  List<Map<String, dynamic>> get collectionsMap => _collectionsMap;
  bool get isSelectionApplied => _isSelectionApplied;
  List<Map<String, dynamic>> get defaultCollections => _defaultCollections;
  List get foryouProducts => _foryouProducts;
  List<Map<String, dynamic>> get collectionProducts => _collectionProducts;
  bool get isForYouCollectionProductsLoading =>
      _isForYouCollectionProductsLoading;

  TabForYouNotifier() {
    loadCollections();
    getProductsFromSelectedCollection();
  }

  // Future<void> loadDataFromSelectedCollection() async {
  //   final selectedCollectionsfromcache = await _collectionService
  //       .getCachedSelectedCollection('selectedcollections');
  //   if (selectedCollections.isNotEmpty) {
  //     _selectedCollectionIds.clear();
  //     _selectedCollectionIds.addAll(selectedCollections);
  //     _isSelectionApplied = true;
  //     await getProductsFromSelectedCollection();
  //     notifyListeners();
  //   }
  // }

  Future<void> loadForYouProducts(
      int collectionId, int limit, String boxName) async {
    _isForYouLoading = true;
    notifyListeners();

    try {
      _foryouProducts =
          await _forYouService.getCachedProductCollections(boxName);
      notifyListeners();

      final serverProducts =
          await _forYouService.fetchForYouDeals(collectionId, limit, boxName);
      _foryouProducts = serverProducts;
      notifyListeners();
    } catch (e) {
      debugPrint("error loading loadForYouProducts: $e");
    } finally {
      _isForYouLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadCollections() async {
    _isLoading = true;
    notifyListeners();

    try {
      // _collections = await _collectionService.getCachedCollection(_boxName);
      // notifyListeners();

      final serverCollection =
          await _collectionService.fetchCollections(_boxName);
      _collections = serverCollection;
      notifyListeners();
    } catch (e) {
      debugPrint("error loading collections: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void toggleCollectionMap(int collectionId, String collectionName) {
    _isSelectionApplied = false;
    int index = _collectionsMap
        .indexWhere((map) => map['collection_id'] == collectionId);

    if (index != -1) {
      _collectionsMap.removeAt(index);
    } else {
      _collectionsMap.add({
        'collection_id': collectionId,
        'collection_name': collectionName,
      });
    }
    notifyListeners();
  }

  bool isCollectionIdExisting(int collectionId) {
    bool exists =
        _collectionsMap.any((map) => map['collection_id'] == collectionId);
    return exists;
  }

  void resetCollectionMap() {
    _collectionsMap.clear();
    if (_selectedCollectionIds.isNotEmpty) {
      _collectionsMap.addAll(_selectedCollectionIds);
    }
    notifyListeners();
  }

  void applySelectedCollections() async {
    _collectionService.clearSelectedCollectionCache('selectedcollections');
    _selectedCollectionIds.clear();
    _collectionsMap
        .sort((a, b) => a['collection_id'].compareTo(b['collection_id']));

    _selectedCollectionIds.addAll(_collectionsMap);
    _isSelectionApplied = true;
    await getProductsFromSelectedCollection();
    notifyListeners();
    _collectionService.addSelectedCollectionToCache(
        _selectedCollectionIds, 'selectedcollections');
  }

  Future<void> getProductsFromSelectedCollection() async {
    _isForYouCollectionProductsLoading = true;
    notifyListeners();

    if (_selectedCollectionIds.isEmpty) {
      final selectedCollectionsfromcache = await _collectionService
          .getCachedSelectedCollection('selectedcollections');
      if (selectedCollectionsfromcache.isNotEmpty) {
        _selectedCollectionIds.clear();
        _selectedCollectionIds.addAll(selectedCollectionsfromcache);
      } else {
        _selectedCollectionIds.addAll(_defaultCollections);
      }
    }
    try {
      _collectionProducts.clear();
      //check first if there are cached products
      for (var collection in _selectedCollectionIds) {
        final cachedProducts = _forYouService
            .getCachedProductCollections(collection['collection_name']);
        _collectionProducts.add({
          'collection_name': collection['collection_name'],
          'collection_id': collection['collection_id'],
          'products': cachedProducts
        });
      }
      notifyListeners();
      _collectionProducts.clear();
      for (var collection in _selectedCollectionIds) {
        final serverProducts = _forYouService.fetchForYouDeals(
            collection['collection_id'], 30, collection['collection_name']);
        _collectionProducts.add({
          'collection_name': collection['collection_name'],
          'collection_id': collection['collection_id'],
          'products': serverProducts
        });
      }
      notifyListeners();
    } catch (e) {
      debugPrint("error loading getProductsFromSelectedCollection: $e");
    } finally {
      _isForYouCollectionProductsLoading = false;
      notifyListeners();
    }
  }
}
