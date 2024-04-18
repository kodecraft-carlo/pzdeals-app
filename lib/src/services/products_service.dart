import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:pzdeals/src/utils/http/http_client.dart';

class ProductService {
  Future<List<int>> getCachedProducts(String boxName) async {
    debugPrint("getCachedProducts called for $boxName");
    final box = await Hive.openBox<int>(boxName);
    final products = box.values.toList();
    await box.close();
    debugPrint('cached $boxName products: $products');
    return products;
  }

  Future<void> cacheProduct(List<int> products, String boxName) async {
    final box = await Hive.openBox<int>(boxName);
    await box.clear(); // Clear existing cache
    for (final product in products) {
      box.put(product, product);
    }
  }

  Future<bool> updateProductSoldoutStatus(int productId, String status) async {
    ApiClient apiClient = ApiClient();
    debugPrint('updateProductSoldoutStatus called with $productId and $status');
    try {
      Response response =
          await apiClient.dio.patch('/items/products/$productId', data: {
        "status": status,
      }
              // options: Options(
              //   headers: {'Authorization': 'Bearer $accessToken'},
              // ),
              );
      if (response.statusCode != 200) {
        throw Exception(
            'Unable to update product soldout status ${response.statusCode} ~ ${response.data}');
      }
      return true;
    } on DioException catch (e) {
      debugPrint("DioException: ${e.message}");
      throw Exception('Failed to update product soldout status');
    } catch (e) {
      debugPrint('Error updating product soldout status: $e');
      throw Exception('Failed to update product soldout status');
    }
  }

  Future<bool> addToReportedProducts(int productId, String status) async {
    ApiClient apiClient = ApiClient();
    debugPrint('addToReportedProducts called with $productId and $status');
    try {
      Response response = await apiClient.dio.post('/items/reported_products',
          data: {
            "product": productId,
            "status": "unchecked",
            "is_soldout": true
          }
          // options: Options(
          //   headers: {'Authorization': 'Bearer $accessToken'},
          // ),
          );
      if (response.statusCode != 200) {
        throw Exception(
            'Unable to addToReportedProducts ${response.statusCode} ~ ${response.data}');
      }
      return true;
    } on DioException catch (e) {
      debugPrint("DioException: ${e.message}");
      throw Exception('Failed to addToReportedProducts');
    } catch (e) {
      debugPrint('Error addToReportedProducts: $e');
      throw Exception('Failed to addToReportedProducts');
    }
  }
}
