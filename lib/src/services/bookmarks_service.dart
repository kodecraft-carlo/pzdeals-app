import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:pzdeals/src/features/deals/models/index.dart';
import 'package:pzdeals/src/utils/data_mapper/index.dart';
import 'package:pzdeals/src/utils/http/http_client.dart';
import 'package:pzdeals/src/utils/queries/index.dart';

class BookmarksService {
  Future<List<ProductDealcardData>> fetchProductDeals(
      List<int> productIds, String boxName, int pageNumber) async {
    ApiClient apiClient = ApiClient();
    // final authService = ref.watch(directusAuthServiceProvider);
    debugPrint("fetchProduct by ID called for $boxName");

    try {
      Response response = await apiClient.dio
          .get(getProductsByProductIdsQuery(productIds, pageNumber)
              // options: Options(
              //   headers: {'Authorization': 'Bearer $accessToken'},
              // ),
              );
      if (response.statusCode == 200) {
        final responseData = response.data;
        if (responseData == null || responseData.isEmpty) {
          throw Exception('No Data Found');
        }

        final products =
            ProductMapper.mapToProductDealcardDataList(responseData['data']);
        // await _cacheProducts(products, boxName);
        return products;
      } else {
        throw Exception('Failed to fetch directus product list');
      }
    } on DioException catch (e) {
      debugPrint("DioExceptionw: ${e.message}");
      throw Exception('Failed to fetch directus product list');
    } catch (e) {
      debugPrint('Error fetching frontpage deals: $e');
      throw Exception('Failed to fetch directus product list');
    }
  }

  Future<List<int>> getCachedBookmarks(String boxName) async {
    debugPrint("getCachedBookmarks called for $boxName");
    final box = await Hive.openBox<int>(boxName);
    final bookmarks = box.values.toList();
    await box.close();
    debugPrint('cached bookmarks: $bookmarks');
    return bookmarks;
  }

  Future removeProducts(String boxName, List<int> bookmarkedIds) async {
    debugPrint("removeCachedProducts called for $boxName");
    final box = await Hive.openBox<ProductDealcardData>(boxName);
    try {
      List<ProductDealcardData> items = box.values.toList();

      for (var item in items) {
        int itemId = item.productId;

        if (!bookmarkedIds.contains(itemId)) {
          await box.delete(item.productId);
          debugPrint('Item with ID $itemId has been removed from the box.');
        }
      }
    } catch (e) {
      debugPrint('Error removing items: $e');
    } finally {
      await box.close();
    }
  }

  Future removeBookmarkFromCache(String boxName, int productId) async {
    debugPrint("removeBookmarkFromCache called for $boxName");
    final box = await Hive.openBox<int>(boxName);
    try {
      List<int> items = box.values.toList();

      if (!items.contains(productId)) {
        await box.delete(productId);
        debugPrint('Bookmark $productId has been removed from the box.');
      }
    } catch (e) {
      debugPrint('Error removing items: $e');
    } finally {
      await box.close();
    }
  }

  Future<List<ProductDealcardData>> getCachedProducts(String boxName) async {
    debugPrint("getCachedProducts called for $boxName");
    final box = await Hive.openBox<ProductDealcardData>(boxName);
    final products = box.values.toList();
    await box.close();
    return products;
  }

  Future<void> _cacheProducts(
      List<ProductDealcardData> products, String boxName) async {
    debugPrint("Caching products for $boxName");
    final box = await Hive.openBox<ProductDealcardData>(boxName);
    await box.clear(); // Clear existing cache
    for (final product in products) {
      box.put(product.productId, product);
    }
  }

  Future<void> _cacheBookmark(List<int> bookmarks, String boxName) async {
    final box = await Hive.openBox<int>(boxName);
    await box.clear(); // Clear existing cache
    for (final bookmark in bookmarks) {
      box.put(bookmark, bookmark);
    }
    // for (final product in products) {
    //   box.put(product.productId, product);
    // }
  }

  Future<List<int>> getBookmarks(String boxName, String uuid) async {
    try {
      final serverBookmarks = await FirebaseFirestore.instance
          .collection("bookmarks")
          .doc(uuid)
          .get();
      if (serverBookmarks.exists) {
        final data = serverBookmarks.data() as Map<String, dynamic>;
        final productIds = List<int>.from(data['productIds'] ?? []);
        return productIds;
      }
      return [];
    } catch (e) {
      debugPrint("Error fetching bookmarks data: $e");
    }
    throw Exception('getBookmarks error');
  }

  Future<void> updateBookmarks(
      List<int> bookmarks, String boxName, String uuid) async {
    try {
      bookmarks = bookmarks.toSet().toList();

      await FirebaseFirestore.instance
          .collection('bookmarks')
          .doc(uuid)
          .set({'productIds': bookmarks});

      _cacheBookmark(bookmarks, boxName);
    } catch (e) {
      debugPrint("Error updating bookmarks data: $e");
      throw Exception('Error updating bookmarks data');
    }
  }

  Future addBookmark(int productId, String boxName, String uuid) async {
    try {
      final bookmarks = await getBookmarks(boxName, uuid);
      bookmarks.add(productId);
      await updateBookmarks(bookmarks, boxName, uuid);
    } catch (e) {
      debugPrint("Error adding bookmark: $e");
      throw Exception('Error adding bookmark');
    }
  }

  Future removeBookmark(int productId, String boxName, String uuid) async {
    try {
      final bookmarks = await getBookmarks(boxName, uuid);
      bookmarks.remove(productId);
      await removeBookmarkFromCache(boxName, productId);
      await updateBookmarks(bookmarks, boxName, uuid);
    } catch (e) {
      debugPrint("Error removing bookmark: $e");
      throw Exception('Error removing bookmark');
    }
  }
}
