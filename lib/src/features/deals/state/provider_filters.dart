import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pzdeals/src/features/deals/models/index.dart';
import 'package:pzdeals/src/features/deals/services/fetch_collections.dart';
import 'package:pzdeals/src/features/deals/services/filter_service.dart';
import 'package:pzdeals/src/utils/queries/filters_querybuilder.dart';

final searchFilterProvider = ChangeNotifierProvider<SearchFilterNotifier>(
    (ref) => SearchFilterNotifier());

class SearchFilterNotifier extends ChangeNotifier {
  final FilterService _filterService = FilterService();
  final FetchCollectionService _collectionService = FetchCollectionService();

  bool _isFilterApplied = false;
  bool _hasAnyFilterSelected = false;
  bool get isFilterApplied => _isFilterApplied;
  String _filters = '';
  String get filters => _filters;
//stores
  List<PZStoreData> _stores = [];
  final List<Map<String, dynamic>> _selectedStoreIds = [];
  final List<Map<String, dynamic>> _storesMap = [];
  bool _isStoreSelectionApplied = false;
  bool _isStoreLoading = false;
  final String _storeBox = 'filter_stores';
  int storePageNumber = 1;

  List<PZStoreData> get stores => _stores;
  List<Map<String, dynamic>> get selectedStoreIds => _selectedStoreIds;
  List<Map<String, dynamic>> get storesMap => _storesMap;
  bool get isSelectionApplied => _isStoreSelectionApplied;
  bool get isStoreLoading => _isStoreLoading;

//collections
  List<CollectionData> _collections = [];
  final List<Map<String, dynamic>> _selectedCollectionIds = [];
  final List<Map<String, dynamic>> _collectionsMap = [];
  bool _isCollectionSelectionApplied = false;
  bool _isCollectionLoading = false;
  final String _collectionBox = 'filter_collections';

  List<CollectionData> get collections => _collections;
  List<Map<String, dynamic>> get selectedCollectionIds =>
      _selectedCollectionIds;
  List<Map<String, dynamic>> get collectionsMap => _collectionsMap;
  bool get isCollectionApplied => _isCollectionSelectionApplied;
  bool get isCollectionLoading => _isCollectionLoading;
  bool get hasAnyFilterSelected => _hasAnyFilterSelected;

  //amount
  int _minAmount = 0;
  int _maxAmount = 0;

  int get minAmount => _minAmount;
  int get maxAmount => _maxAmount;

  SearchFilterNotifier() {
    _loadStores();
    _loadCollections();
  }

  Future<void> _loadStores() async {
    _isStoreLoading = true;
    notifyListeners();

    try {
      _stores = await _filterService.getCachedStores(_storeBox);
      notifyListeners();

      final serverStores =
          await _filterService.fetchStores(_storeBox, storePageNumber);
      _stores = serverStores;
      notifyListeners();
    } catch (e) {
      debugPrint("error loading stores: $e");
    } finally {
      _isStoreLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMoreStores() async {
    storePageNumber++;
    _isStoreLoading = true;
    notifyListeners();

    try {
      final serverStores =
          await _filterService.fetchStores(_storeBox, storePageNumber);
      _stores.addAll(serverStores);
      notifyListeners();
    } catch (e) {
      storePageNumber--;
      debugPrint('error loading more stores: $e');
    } finally {
      _isStoreLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadCollections() async {
    _isCollectionLoading = true;
    notifyListeners();

    try {
      _collections =
          await _collectionService.getCachedCollection(_collectionBox);
      notifyListeners();

      final serverCollections =
          await _collectionService.fetchCollections(_collectionBox);
      _collections = serverCollections;
      notifyListeners();
    } catch (e) {
      debugPrint("error loading collections: $e");
    } finally {
      _isCollectionLoading = false;
      notifyListeners();
    }
  }

  void toggleStoreMap(int storeId, String tagName, String storeName) {
    _isStoreSelectionApplied = false;
    int index = _storesMap.indexWhere((map) => map['store_id'] == storeId);

    if (index != -1) {
      _storesMap.removeAt(index);
    } else {
      _storesMap.add(
          {'store_id': storeId, 'tag_name': tagName, 'store_name': storeName});
    }
    _hasAnyFilterSelected = isAnyFilterSelected() ? true : false;
    notifyListeners();
  }

  void toggleCollectionMap(int collectionId, String collectionName) {
    _isCollectionSelectionApplied = false;
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
    _hasAnyFilterSelected = isAnyFilterSelected() ? true : false;
    notifyListeners();
  }

  bool isStoreIdExisting(int storeId) {
    bool exists = _storesMap.any((map) => map['store_id'] == storeId);
    return exists;
  }

  bool isCollectionIdExisting(int collectionId) {
    bool exists =
        _collectionsMap.any((map) => map['collection_id'] == collectionId);
    return exists;
  }

  void applySelectedStores() {
    _selectedStoreIds.clear();
    _storesMap.sort((a, b) => a['store_id'].compareTo(b['store_id']));

    _selectedStoreIds.addAll(_storesMap);
    debugPrint('selectedStoreIds: $_selectedStoreIds');
    _isStoreSelectionApplied = true;
    notifyListeners();
  }

  void applySelectedCollection() {
    _selectedCollectionIds.clear();
    _collectionsMap
        .sort((a, b) => a['collection_id'].compareTo(b['collection_id']));

    _selectedCollectionIds.addAll(_collectionsMap);
    debugPrint('selectedCollectionIds: $_selectedCollectionIds');
    _isCollectionSelectionApplied = true;
    notifyListeners();
  }

  void applyFilter() {
    applySelectedStores();
    applySelectedCollection();
    String filterStoresQuery = '';
    String filterCollectionsQuery = '';
    String filterAmountQuery = '';
    if (_selectedStoreIds.isNotEmpty) {
      filterStoresQuery = filterByStoresQuery(
          _selectedStoreIds.map((map) => map['tag_name']).toList());
    }

    if (_selectedCollectionIds.isNotEmpty) {
      filterCollectionsQuery = filterByCollectionsQuery(
          _selectedCollectionIds.map((map) => map['collection_id']).toList());
    }

    if (minAmount != 0 && maxAmount != 0) {
      debugPrint('minAmount: $minAmount, maxAmount: $maxAmount  ');
      filterAmountQuery = filterByAmountQuery(minAmount, maxAmount);
    }

    _filters = filterStoresQuery + filterCollectionsQuery + filterAmountQuery;
    _isFilterApplied = true;
    notifyListeners();
  }

  void resetFilter() {
    debugPrint('reset filter');
    _storesMap.clear();
    _selectedStoreIds.clear();
    _isStoreSelectionApplied = false;

    _collectionsMap.clear();
    _selectedCollectionIds.clear();
    _isCollectionSelectionApplied = false;

    _minAmount = 0;
    _maxAmount = 0;

    _isFilterApplied = false;
    _hasAnyFilterSelected = false;
    _filters = '';
    notifyListeners();
  }

  void setMinAmount(int min) {
    _minAmount = min;
    _hasAnyFilterSelected = isAnyFilterSelected() ? true : false;
    notifyListeners();
  }

  void setMaxAmount(dynamic max) {
    _maxAmount = max == '~' ? 100000000000 : max;
    _hasAnyFilterSelected = isAnyFilterSelected() ? true : false;
    notifyListeners();
  }

  bool isAnyFilterSelected() {
    return _storesMap.isNotEmpty ||
        _collectionsMap.isNotEmpty ||
        _minAmount != 0 ||
        _maxAmount != 0;
  }
}
