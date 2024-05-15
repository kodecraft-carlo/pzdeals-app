import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:pzdeals/src/features/deals/models/index.dart';
import 'package:pzdeals/src/utils/data_mapper/index.dart';
import 'package:pzdeals/src/utils/http/http_client.dart';
import 'package:pzdeals/src/utils/queries/deals_querybuilder.dart';
import 'package:pzdeals/src/utils/queries/index.dart';

class FetchProductDealService {
  Future<List<ProductDealcardData>> getCachedProducts(String boxName) async {
    debugPrint("getCachedProducts called for $boxName");
    final box = await Hive.openBox<ProductDealcardData>(boxName);
    final products = box.values.toList();
    await box.close();
    return products;
  }

  Future<List<ProductDealcardData>> fetchProductDealsAll(
      String boxName, int pageNumber) async {
    ApiClient apiClient = ApiClient();
    // final authService = ref.watch(directusAuthServiceProvider);
    debugPrint("fetchProductDealsAll called");

    try {
      Response response = await apiClient.dio.get(getProductsAll(pageNumber)
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
        await _cacheProducts(products, boxName);
        return products;
      } else {
        throw Exception(
            'Failed to fetch directus product list ${response.statusCode}');
      }
    } on DioException catch (e) {
      debugPrint("DioExceptionw: ${e.message}");
      throw Exception('Failed to fetch directus product list');
    } catch (e) {
      debugPrint('Error fetching frontpage deals: $e');
      throw Exception('Failed to fetch directus product list');
    }
  }

  Future<List<ProductDealcardData>> fetchProductDeals(
      String pageName, String boxName, int pageNumber) async {
    ApiClient apiClient = ApiClient();
    // final authService = ref.watch(directusAuthServiceProvider);
    debugPrint("fetchProduct Deals called for $pageName");

    try {
      Response response = await apiClient.dio
          .get(getProductsByCollectionQuery(pageName, pageNumber)
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
        await _cacheProducts(products, boxName);
        return products;
      } else {
        throw Exception(
            'Failed to fetch directus product list ${response.statusCode}');
      }
    } on DioException catch (e) {
      debugPrint("DioExceptionw: ${e.message}");
      throw Exception('Failed to fetch directus product list');
    } catch (e, stackTrace) {
      debugPrint(stackTrace.toString());
      debugPrint('Error fetching frontpage deals: $e');
      throw Exception('Failed to fetch directus product list');
    }
  }

  Future<void> _cacheProducts(
      List<ProductDealcardData> products, String boxName) async {
    debugPrint("Caching products for $boxName");
    final box = await Hive.openBox<ProductDealcardData>(boxName);
    // await box.clear();
    // box.addAll(products);
    for (final product in products) {
      box.put(product.productId, product);
    }
  }

  Future<ProductDealcardData> getCachedProductInfo(String boxName) async {
    debugPrint("getCachedProductInfo called for $boxName");
    final box = await Hive.openBox<ProductDealcardData>(boxName);
    final productInfo = box.values.toSet().first;
    debugPrint('cached $boxName product info: $productInfo');
    await box.close();
    return productInfo;
  }

  Future<ProductDealcardData> fetchProductInfo(int productId) async {
    ApiClient apiClient = ApiClient();
    // final authService = ref.watch(directusAuthServiceProvider);
    debugPrint("fetchProductInfo Deals called for $productId");

    try {
      Response response =
          await apiClient.dio.get(getProductSpecificDetailsQuery(productId)
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
            ProductMapper.mapToProductDealcardData(responseData['data']);
        return products;
      } else {
        throw Exception('Failed to fetch directus product info');
      }
    } on DioException catch (e) {
      debugPrint("DioExceptionw: ${e.message}");
      throw Exception('Failed to fetch directus product info');
    } catch (e) {
      debugPrint('Error fetching fetchProductInfo deals: $e');
      throw Exception('Failed to fetch directus product info');
    }
  }

  Future<void> _cacheProductInfo(
      ProductDealcardData product, String boxName) async {
    debugPrint("Caching product info for $boxName");
    final box = await Hive.openBox<ProductDealcardData>(boxName);
    await box.clear(); // Clear existing cache
    box.add(product);
  }
}
