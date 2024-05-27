import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:pzdeals/src/features/deals/models/index.dart';
import 'package:pzdeals/src/utils/data_mapper/index.dart';
import 'package:pzdeals/src/utils/http/http_client.dart';
import 'package:pzdeals/src/utils/queries/index.dart';

class FetchForYouService {
  // Future<List<ProductDealcardData>> getCachedProductCollections(
  //     String boxName) async {
  //   debugPrint("getCachedProductCollections called for $boxName");
  //   final box = await Hive.openBox<ProductDealcardData>(boxName);
  //   final products = box.values.toList();
  //   await box.close();
  //   return products;
  // }

  Future<List<ProductDealcardData>> getCachedProductCollections(
      String boxName) async {
    debugPrint("getCachedProducts called for $boxName");
    final box = await Hive.openBox<List<dynamic>>(boxName);
    List<dynamic> cachedProductsDynamic = box.get(boxName) ?? [];
    await box.close();
    return cachedProductsDynamic
        .map((item) => item as ProductDealcardData)
        .toList();
  }

  Future<List<ProductDealcardData>> fetchForYouDeals(
      int collectionId, int limit, String boxName) async {
    final apiClient = ApiClient();

    try {
      // final box = await Hive.openBox<ProductDealcardData>(boxName);

      // if (Hive.isBoxOpen(boxName) && box.isNotEmpty) {
      //   final products = box.values.toList();
      //   await box.close();
      //   return products;
      // }

      final response = await apiClient.dio.get(
        getProductsByCollectionIdQuery(collectionId, limit),
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        if (responseData == null || responseData.isEmpty) {
          throw Exception('No Data Found');
        }

        final products =
            ProductMapper.mapToProductDealcardDataList(responseData["data"]);

        await _cacheProductCollections(products, boxName);

        return products;
      } else {
        throw Exception('Failed to fetch fetchForYouDeals');
      }
    } on DioException catch (e) {
      debugPrint("DioError: ${e.message}");
      throw Exception('Failed to fetch fetchForYouDeals');
    } catch (e) {
      debugPrint('Error fetching for you deals: $e');
      throw Exception('Failed to fetch fetchForYouDeals');
    }
  }
  // Future<List> fetchForYouDeals(
  //     int collectionId, int limit, String boxName) async {
  //   ApiClient apiClient = ApiClient();
  //   // final authService = ref.watch(directusAuthServiceProvider);
  //   debugPrint("fetchForYouDeals called for $collectionId");

  //   try {
  //     Box box = await Hive.openBox<ProductDealcardData>(boxName);
  //     if (Hive.isBoxOpen(boxName)) {
  //       if (box.isNotEmpty) {
  //         final products = box.values.toList();
  //         await box.close();
  //         return products;
  //       }
  //     }
  //     Response response = await apiClient.dio
  //         .get(getProductsByCollectionIdQuery(collectionId, limit)
  //             // options: Options(
  //             //   headers: {'Authorization': 'Bearer $accessToken'},
  //             // ),
  //             );
  //     if (response.statusCode == 200) {
  //       final responseData = response.data["data"];
  //       if (responseData == null || responseData.isEmpty) {
  //         throw Exception('No Data Found');
  //       }

  //       final products =
  //           ProductMapper.mapToProductDealcardDataList(responseData);
  //       await _cacheProductCollections(products, boxName);
  //       return products;
  //     } else {
  //       throw Exception('Failed to fetch fetchForYouDeals');
  //     }
  //   } on DioException catch (e) {
  //     debugPrint("DioExceptionw: ${e.message}");
  //     throw Exception('Failed to fetch fetchForYouDeals');
  //   } catch (e) {
  //     debugPrint('Error fetching frontpage deals: $e');
  //     throw Exception('Failed to fetch fetchForYouDeals');
  //   }
  // }

  // Future<void> _cacheProductCollections(
  //     List<ProductDealcardData> collections, String boxName) async {
  //   debugPrint("Caching productcollections for $boxName");
  //   final box = await Hive.openBox<ProductDealcardData>(boxName);
  //   await box.clear();
  //   for (final collection in collections) {
  //     box.add(collection);
  //   }
  // }

  Future<void> _cacheProductCollections(
      List<ProductDealcardData> products, String boxName) async {
    debugPrint("Caching products for $boxName");
    final box = await Hive.openBox<dynamic>(boxName);

    // Get the existing cached products.
    List<ProductDealcardData> cachedProducts =
        box.get(boxName)?.cast<ProductDealcardData>() ?? [];

    // Append the new products to the cached products, if they're not already in the cache.
    products = products.reversed.toList();
    for (var product in products) {
      if (!cachedProducts.any(
          (cachedProduct) => cachedProduct.productId == product.productId)) {
        cachedProducts.insert(0, product);
      }
    }

    // Store the combined list back in the cache.
    await box.put(boxName, cachedProducts);
    await box.close();
  }

  Future<void> cacheCollectionSelectionStatus(
      bool hasCollection, String boxName) async {
    final box = await Hive.openBox<bool>(boxName);
    await box.clear();
    box.add(hasCollection);
  }

  Future<bool> getCachedCollectionSelectionStatus(String boxName) async {
    final box = await Hive.openBox<bool>(boxName);
    final hasCollection = box.values.first;
    await box.close();
    return hasCollection;
  }
}
