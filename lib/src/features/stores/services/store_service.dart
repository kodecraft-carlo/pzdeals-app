import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:pzdeals/src/models/index.dart';
import 'package:pzdeals/src/utils/data_mapper/store_mapper.dart';
import 'package:pzdeals/src/utils/http/http_client.dart';
import 'package:pzdeals/src/utils/queries/index.dart';

class StoreScreenService {
  Future<List<StoreData>> getCachedStores(String boxName) async {
    debugPrint("getCachedStores called for $boxName");
    final box = await Hive.openBox<StoreData>(boxName);
    final stores = box.values.toList();
    await box.close();
    return stores;
  }

  Future<List<StoreData>> fetchStoreCollection(
      String boxName, int pageNumber) async {
    ApiClient apiClient = ApiClient();
    // final authService = ref.watch(directusAuthServiceProvider);
    try {
      Response response =
          await apiClient.dio.get(getStoreCollectionQuery(pageNumber)
              // options: Options(
              //   headers: {'Authorization': 'Bearer $accessToken'},
              // ),
              );
      if (response.statusCode == 200) {
        final responseData = response.data["data"];
        if (responseData == null || responseData.isEmpty) {
          throw Exception('No Data Found');
        }
        final stores = StoreDataMapper.mapToStoreIconList(responseData);
        await _cacheStores(stores, boxName);
        return stores;
      } else {
        throw Exception('Failed to fetch directus stores list');
      }
    } on DioException catch (e) {
      debugPrint("DioExceptionw: ${e.message}");
      throw Exception('Failed to fetch directus stores list');
    } catch (e) {
      debugPrint('Error fetching stores: $e');
      throw Exception('Failed to fetch directus stores list');
    }
  }

  Future<void> _cacheStores(List<StoreData> stores, String boxName) async {
    debugPrint("Caching stores for $boxName");
    final box = await Hive.openBox<StoreData>(boxName);
    await box.clear(); // Clear existing cache
    for (final store in stores) {
      box.put(store.id, store);
    }
  }

  Future<StoreData> fetchStoreInfo(int storeId) async {
    ApiClient apiClient = ApiClient();
    // final authService = ref.watch(directusAuthServiceProvider);
    debugPrint("fetchStoreInfo Deals called for $storeId");

    try {
      Response response =
          await apiClient.dio.get(getStoreSpecificDetailsQuery(storeId)
              // options: Options(
              //   headers: {'Authorization': 'Bearer $accessToken'},
              // ),
              );
      if (response.statusCode == 200) {
        final responseData = response.data["data"];
        if (responseData == null || responseData.isEmpty) {
          throw Exception('No Data Found');
        }

        final stores = StoreDataMapper.mapToStoreData(responseData);
        return stores;
      } else {
        throw Exception('Failed to fetch directus store info');
      }
    } on DioException catch (e) {
      debugPrint("DioExceptionw: ${e.message}");
      throw Exception('Failed to fetch directus store info');
    } catch (e) {
      debugPrint('Error fetching getStoreSpecificDetailsQuery deals: $e');
      throw Exception('Failed to fetch directus store info');
    }
  }
}
