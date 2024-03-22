import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:pzdeals/src/features/deals/models/index.dart';
import 'package:pzdeals/src/utils/data_mapper/store_mapper.dart';
import 'package:pzdeals/src/utils/http/http_client.dart';
import 'package:pzdeals/src/utils/queries/filters_querybuilder.dart';
import 'package:pzdeals/src/utils/queries/index.dart';

class FilterService {
  Future<List<PZStoreData>> getCachedStores(String boxName) async {
    debugPrint("getCachedStores called for $boxName");
    final box = await Hive.openBox<PZStoreData>(boxName);
    final stores = box.values.toList();
    await box.close();
    return stores;
  }

  Future<List<PZStoreData>> fetchStores(String boxName, int pageNumber) async {
    ApiClient apiClient = ApiClient();
    // final authService = ref.watch(directusAuthServiceProvider);
    debugPrint("fetchStores called for $boxName");

    try {
      Response response = await apiClient.dio.get(getStoresQuery(pageNumber)
          // options: Options(
          //   headers: {'Authorization': 'Bearer $accessToken'},
          // ),
          );
      if (response.statusCode == 200) {
        final responseData = response.data["data"];
        if (responseData == null || responseData.isEmpty) {
          throw Exception('No Data Found');
        }

        final stores = StoreDataMapper.mapToStoreDataList(responseData);
        await _cacheStores(stores, boxName);
        return stores;
      } else {
        throw Exception(
            'Failed to fetch directus stores list ${response.statusCode}');
      }
    } on DioException catch (e) {
      debugPrint("DioExceptionw: ${e.message}");
      throw Exception('Failed to fetch directus stores list');
    } catch (e) {
      debugPrint('Error fetching frontpage deals: $e');
      throw Exception('Failed to fetch directus stores list');
    }
  }

  Future<void> _cacheStores(List<PZStoreData> stores, String boxName) async {
    debugPrint("Caching stores for $boxName");
    final box = await Hive.openBox<PZStoreData>(boxName);
    await box.clear(); // Clear existing cache
    for (final store in stores) {
      box.put(store.id, store);
    }
  }
}
