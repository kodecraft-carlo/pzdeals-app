import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/admob/v1.dart';
import 'package:hive/hive.dart';
import 'package:pzdeals/config.dart';
import 'package:pzdeals/src/utils/helpers/image_asset.dart';
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

  Future<bool> addToReportedProducts(
      int productId,
      String status,
      String userId,
      String deviceId,
      String productImage,
      String productName) async {
    ApiClient apiClient = ApiClient();
    debugPrint('addToReportedProducts called with $productId and $status');

    try {
      if (await isUserAlreadyReported(productId, userId) == false) {
        String imageUid = getImageUidFromUrl(productImage);
        if (imageUid.isEmpty) {
          imageUid = await getProductImageUid(productImage, productName);
          await linkImageUidToProduct(productId, imageUid);
        }
        final request = {
          "product": productId,
          "status": "unchecked",
          "is_soldout": status.toLowerCase() == 'sold-out' ? true : false,
          "type": status,
          "device_id": deviceId,
          "product_image": imageUid,
          "user_id": userId,
        };
        debugPrint('request: $request');
        Response response =
            await apiClient.dio.post('/items/reported_products', data: request
                // options: Options(
                //   headers: {'Authorization': 'Bearer $accessToken'},
                // ),
                );
        if (response.statusCode != 200) {
          throw Exception(
              'Unable to addToReportedProducts ${response.statusCode} ~ ${response.data}');
        }
        return true;
      } else {
        debugPrint('Device already reported for this product');
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

  Future<bool> isDeviceAlreadyReported(int productId, String deviceId) async {
    ApiClient apiClient = ApiClient();
    debugPrint('isDeviceAlreadyReported called with $productId and $deviceId');
    try {
      debugPrint(
          'query: /items/reported_products?filter[device_id][_eq]=$deviceId&filter[product][_eq]=$productId');
      Response response = await apiClient.dio.get(
          '/items/reported_products?filter[device_id][_eq]=$deviceId&filter[product][_eq]=$productId'
          // options: Options(
          //   headers: {'Authorization': 'Bearer $accessToken'},
          // ),
          );
      if (response.statusCode != 200) {
        throw Exception(
            'Unable to isDeviceAlreadyReported ${response.statusCode} ~ ${response.data}');
      }
      return response.data["data"].length > 0;
    } on DioException catch (e) {
      debugPrint("DioException: ${e.message}");
      throw Exception('Failed to isDeviceAlreadyReported');
    } catch (e) {
      debugPrint('Error isDeviceAlreadyReported: $e');
      throw Exception('Failed to isDeviceAlreadyReported');
    }
  }

  Future<bool> isUserAlreadyReported(int productId, String userId) async {
    ApiClient apiClient = ApiClient();
    debugPrint('isUserAlreadyReported called with $productId and $userId');
    try {
      debugPrint(
          'query: /items/reported_products?filter[user_id][_eq]=$userId&filter[product][_eq]=$productId');
      Response response = await apiClient.dio.get(
          '/items/reported_products?filter[user_id][_eq]=$userId&filter[product][_eq]=$productId'
          // options: Options(
          //   headers: {'Authorization': 'Bearer $accessToken'},
          // ),
          );
      if (response.statusCode != 200) {
        throw Exception(
            'Unable to isUserAlreadyReported ${response.statusCode} ~ ${response.data}');
      }
      return response.data["data"].length > 0;
    } on DioException catch (e) {
      debugPrint("DioException: ${e.message}");
      throw Exception('Failed to isUserAlreadyReported');
    } catch (e, stackTrace) {
      debugPrint('Error isDeviceAlreadyReported: $stackTrace');
      throw Exception('Failed to isUserAlreadyReported');
    }
  }

  Future<String> getProductImageUid(
    String productUrl,
    String productName,
  ) async {
    ApiClient apiClient = ApiClient();
    debugPrint('getProductImageUid called with $productUrl and $productName');
    final request = {
      "url": productUrl,
      "data": {
        "title": productName,
        "storage": AppConfig.directusStorage,
        "folder": AppConfig.directusProductImagesDirectory
      }
    };
    debugPrint('request: $request');
    try {
      Response response =
          await apiClient.dio.post('/files/import', data: request
              // options: Options(
              //   headers: {'Authorization': 'Bearer $accessToken'},
              // ),
              );
      if (response.statusCode != 200) {
        throw Exception(
            'Unable to getProductImageUid ${response.statusCode} ~ ${response.data}');
      }
      //get the image uid from the response
      return response.data["data"]["id"];
    } on DioException catch (e) {
      debugPrint("DioException: ${e.message}");
      throw Exception('Failed to getProductImageUid');
    } catch (e, stackTrace) {
      debugPrint('Error getProductImageUid: $stackTrace');
      throw Exception('Failed to getProductImageUid');
    }
  }

  Future<void> linkImageUidToProduct(int productId, String imageUid) async {
    ApiClient apiClient = ApiClient();
    debugPrint('linkImageUidToProduct called with $productId and $imageUid');
    final request = {
      "product": productId,
      "local_image": imageUid,
    };
    debugPrint('request: $request');
    try {
      Response response =
          await apiClient.dio.patch('/items/products/$productId', data: request
              // options: Options(
              //   headers: {'Authorization': 'Bearer $accessToken'},
              // ),
              );
      if (response.statusCode != 200) {
        throw Exception(
            'Unable to linkImageUidToProduct ${response.statusCode} ~ ${response.data}');
      }
    } on DioException catch (e) {
      debugPrint("DioException: ${e.message}");
      throw Exception('Failed to linkImageUidToProduct');
    } catch (e, stackTrace) {
      debugPrint('Error linkImageUidToProduct: $stackTrace');
      throw Exception('Failed to linkImageUidToProduct');
    }
  }
}
