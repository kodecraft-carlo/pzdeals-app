import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:pzdeals/src/features/deals/models/index.dart';
import 'package:pzdeals/src/utils/data_mapper/index.dart';
import 'package:pzdeals/src/utils/http/http_client.dart';
import 'package:pzdeals/src/utils/queries/index.dart';

class FetchCollectionService {
  Future<List<CollectionData>> getCachedCollection(String boxName) async {
    debugPrint("getCachedCollection called for $boxName");
    final box = await Hive.openBox<CollectionData>(boxName);
    final collections = box.values.toList();
    await box.close();
    return collections;
  }

  Future<List<CollectionData>> fetchCollections(String boxName) async {
    ApiClient apiClient = ApiClient();
    // final authService = ref.watch(directusAuthServiceProvider);
    debugPrint("fetchCollections called");
    try {
      Response response = await apiClient.dio.get(getCollections('foryou')
          // options: Options(
          //   headers: {'Authorization': 'Bearer $accessToken'},
          // ),
          );
      if (response.statusCode == 200) {
        final responseData = response.data["data"];
        if (responseData == null || responseData.isEmpty) {
          throw Exception('No Data Found');
        }

        final collections =
            CollectionDataMapper.mapToCollectionDataList(responseData);
        await _cacheCollections(collections, boxName);
        return collections;
      } else {
        throw Exception('Failed to fetch directus collections list');
      }
    } on DioException catch (e) {
      debugPrint("DioExceptionw: ${e.message}");
      throw Exception('Failed to fetch directus collections list');
    } catch (e) {
      debugPrint('Error fetching collections: $e');
      throw Exception('Failed to fetch directus collections list');
    }
  }

  Future<void> _cacheCollections(
      List<CollectionData> collections, String boxName) async {
    debugPrint("Caching collections for $boxName");
    final box = await Hive.openBox<CollectionData>(boxName);
    await box.clear();
    for (final collection in collections) {
      box.put(collection.id, collection);
    }
  }

  Future<String> fetchCollectionIdAndName(String keyword) async {
    ApiClient apiClient = ApiClient();
    debugPrint("fetchCollectionIdAndName called for $keyword");
    try {
      Response response = await apiClient.dio.get('/items/collection'
          '?filter[keywords][_eq]=$keyword'
          // options: Options(
          //   headers: {'Authorization': 'Bearer $accessToken'},
          // ),
          );
      if (response.statusCode == 200) {
        final responseData = response.data["data"];
        if (responseData == null || responseData.isEmpty) {
          throw Exception('No Data Found');
        }
        return '${responseData[0]["id"]}~${responseData[0]["collection_name"]}';
      } else {
        throw Exception('Failed to fetch directus fetchCollectionIdAndName');
      }
    } on DioException catch (e) {
      debugPrint("DioExceptionw: ${e.message}");
      throw Exception('Failed to fetch directus fetchCollectionIdAndName');
    } catch (e) {
      debugPrint('Error fetching collection id and name: $e');
      throw Exception('Failed to fetch directus fetchCollectionIdAndName');
    }
  }
}
