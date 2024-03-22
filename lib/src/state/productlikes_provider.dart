import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pzdeals/src/services/products_service.dart';

final likedproductsProvider =
    ChangeNotifierProvider.autoDispose<LikedProductsNotifier>(
        (ref) => LikedProductsNotifier());

class LikedProductsNotifier extends ChangeNotifier {
  final ProductService _productService = ProductService();

  final String _likeBox = 'product_likes';
  final String _dislikeBox = 'product_dislikes';

  bool _isLoading = false;

  List<int> _likedProducts = [];
  List<int> _dislikedProducts = [];

  bool get isLoading => _isLoading;
  List<int> get likedProducts => _likedProducts;
  List<int> get dislikedProducts => _dislikedProducts;

  LikedProductsNotifier() {
    _loadLikedProductsFromCache();
    _loadDislikedProductsFromCache();
  }

  Future<void> _loadLikedProductsFromCache() async {
    _isLoading = true;
    notifyListeners();

    try {
      _likedProducts = await _productService.getCachedProducts(_likeBox);
      notifyListeners();
    } catch (e) {
      debugPrint("error loading liked products: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadDislikedProductsFromCache() async {
    _isLoading = true;
    notifyListeners();

    try {
      _dislikedProducts = await _productService.getCachedProducts(_dislikeBox);
      notifyListeners();
    } catch (e) {
      debugPrint("error loading disliked products: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void addToCachedProducts(int productId, String buttonAction) {
    if (buttonAction == 'like') {
      if (_dislikedProducts.contains(productId)) {
        removeFromDislikedProducts(productId);
      }

      if (_likedProducts.contains(productId)) {
        removeFromLikedProducts(productId);
      } else {
        addToLikedProducts(productId);
      }
    } else {
      if (_likedProducts.contains(productId)) {
        removeFromLikedProducts(productId);
      }
      if (_dislikedProducts.contains(productId)) {
        removeFromDislikedProducts(productId);
      } else {
        addToDislikedProducts(productId);
      }
    }
  }

  void removeFromDislikedProducts(int productId) {
    _dislikedProducts.remove(productId);
    _dislikedProducts = _dislikedProducts.toSet().toList();
    _productService.cacheProduct(_dislikedProducts, _dislikeBox);
    notifyListeners();
  }

  void removeFromLikedProducts(int productId) {
    _likedProducts.remove(productId);
    _likedProducts = _likedProducts.toSet().toList();
    _productService.cacheProduct(_likedProducts, _likeBox);
    notifyListeners();
  }

  void addToLikedProducts(int productId) {
    _likedProducts.add(productId);
    _likedProducts = _likedProducts.toSet().toList();
    _productService.cacheProduct(_likedProducts, _likeBox);
    notifyListeners();
  }

  void addToDislikedProducts(int productId) {
    _dislikedProducts.add(productId);
    _dislikedProducts = _dislikedProducts.toSet().toList();
    _productService.cacheProduct(_dislikedProducts, _dislikeBox);
    notifyListeners();
  }

  bool isLiked(int productId) {
    return _likedProducts.contains(productId);
  }

  bool isDisliked(int productId) {
    return _dislikedProducts.contains(productId);
  }
}
