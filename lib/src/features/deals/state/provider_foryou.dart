import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pzdeals/src/features/deals/models/index.dart';
import 'package:pzdeals/src/features/deals/services/fetch_collections.dart';

final tabForYouProvider =
    ChangeNotifierProvider<TabForYouNotifier>((ref) => TabForYouNotifier());

class TabForYouNotifier extends ChangeNotifier {
  final FetchCollectionService _collectionService = FetchCollectionService();

  final String _boxName = 'foryoucollections';
  bool _isLoading = false;
  List<CollectionData> _collections = [];
  final List<Map<String, dynamic>> _selectedCollectionIds = [];
  final List<Map<String, dynamic>> _collectionsMap = [];
  bool _isSelectionApplied = false;
  final List<Map<String, dynamic>> _defaultCollections = [
    {'collection_id': 4, 'collection_name': 'Flash'},
    {'collection_id': 8, 'collection_name': 'Tech'},
    {'collection_id': 10, 'collection_name': 'Home'}
  ];

  bool get isLoading => _isLoading;
  List<CollectionData> get collections => _collections;
  List<Map<String, dynamic>> get selectedCollectionIds =>
      _selectedCollectionIds;
  List<Map<String, dynamic>> get collectionsMap => _collectionsMap;
  bool get isSelectionApplied => _isSelectionApplied;
  List<Map<String, dynamic>> get defaultCollections => _defaultCollections;

  TabForYouNotifier() {
    _loadCollections();
  }

  Future<void> _loadCollections() async {
    _isLoading = true;
    notifyListeners();

    try {
      _collections = await _collectionService.getCachedCollection(_boxName);
      notifyListeners();

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

  void applySelectedCollections() {
    _selectedCollectionIds.clear();
    _collectionsMap
        .sort((a, b) => a['collection_id'].compareTo(b['collection_id']));

    _selectedCollectionIds.addAll(_collectionsMap);
    _isSelectionApplied = true;
    notifyListeners();
  }
}
