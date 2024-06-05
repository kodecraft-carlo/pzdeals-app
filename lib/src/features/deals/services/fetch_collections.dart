import 'dart:convert';

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

  Future<List<Map<String, dynamic>>> getCachedSelectedCollection(
      String boxName) async {
    debugPrint("getCachedSelectedCollection called for $boxName");

    Box<Map<dynamic, dynamic>> box;
    if (Hive.isBoxOpen(boxName)) {
      box = Hive.box<Map<dynamic, dynamic>>(boxName);
    } else {
      box = await Hive.openBox<Map<dynamic, dynamic>>(boxName);
    }

    final collections = box.values.toList();
    List<Map<String, dynamic>> data =
        collections.map((map) => Map<String, dynamic>.from(map)).toList();
    // await box.close();
    return data;
  }

  Future<List<Map<String, dynamic>>> getForYouConfig(String userID) async {
    debugPrint('getForYouConfig called');
    ApiClient apiClient = ApiClient();
    try {
      Response response = await apiClient.dio.get(
          '/items/foryou_config/?fields[]=collections&filter[user_id]=$userID'
          // options: Options(
          //   headers: {'Authorization': 'Bearer $accessToken'},
          // ),
          );
      if (response.statusCode == 200) {
        final responseData = response.data["data"];
        if (responseData == null || responseData.isEmpty) {
          return [];
        }
        dynamic collections = responseData[0]["collections"];
        debugPrint('testtt $collections');
        List<Map<String, dynamic>> data = [];
        for (final collection in collections) {
          data.add(Map<String, dynamic>.from(collection));
        }
        return data;
      } else {
        throw Exception('Failed to fetch directus foryouconfig');
      }
    } on DioException catch (e) {
      debugPrint("DioExceptionw: ${e.message}");
      throw Exception('Failed to fetch for you config');
    } catch (e, stackTrace) {
      debugPrint('Error fetching for you config: $stackTrace');
      throw Exception('Failed to fetch for you config');
    }
  }

  Future<void> addForYouConfig(
      List<Map<String, dynamic>> selectedCollections, String userID) async {
    ApiClient apiClient = ApiClient();
    debugPrint("addForYouConfig called");
    try {
      List<String> data = [];
      for (final collection in selectedCollections) {
        data.add(collection['collection_id'].toString());
      }
      Response response = await apiClient.dio.post('/items/foryou_config',
          data: {"user_id": userID, "collections": selectedCollections});
      if (response.statusCode != 200) {
        throw Exception('Unable to add addForYouConfig ${response.statusCode}');
      }
    } on DioException catch (e) {
      debugPrint("DioExceptionw: ${e.message}");
      throw Exception('Failed to fetch directus addForYouConfig');
    } catch (e, stackTrace) {
      debugPrint('Error addForYouConfig $stackTrace');
      throw Exception('Failed to fetch directus addForYouConfig');
    }
  }

  Future<void> updateForYouConfig(
      List<Map<String, dynamic>> selectedCollections, String userID) async {
    ApiClient apiClient = ApiClient();
    try {
      final int id = await getForYouConfigId(userID);
      if (id == 0) {
        debugPrint('Adding new for you config');
        await addForYouConfig(selectedCollections, userID);
        return;
      }
      List<String> data = [];
      for (final collection in selectedCollections) {
        data.add(collection['collection_id'].toString());
      }
      Response response = await apiClient.dio.patch('/items/foryou_config/$id',
          data: {"collections": selectedCollections}
          // options: Options(
          //   headers: {'Authorization': 'Bearer $accessToken'},
          // ),
          );
      if (response.statusCode != 200) {
        throw Exception(
            'Unable to update foryouconfig ${response.statusCode} ~ ${response.data}');
      }
    } on DioException catch (e) {
      debugPrint("DioException: ${e.message}");
      throw Exception('Failed to update foryou config');
    } catch (e, stackTrace) {
      debugPrint('Error updating for you config: $stackTrace');
      throw Exception('Failed to update for you config');
    }
  }

  Future<int> getForYouConfigId(String userId) async {
    ApiClient apiClient = ApiClient();
    // final authService = ref.watch(directusAuthServiceProvider);
    try {
      Response response = await apiClient.dio
          .get('/items/foryou_config/?filter[user_id]=$userId'
              // options: Options(
              //   headers: {'Authorization': 'Bearer $accessToken'},
              // ),
              );
      if (response.statusCode == 200) {
        final responseData = response.data["data"];
        if (responseData == null ||
            responseData.isEmpty ||
            responseData.length <= 0) {
          debugPrint('No foryouconfig found');
          return 0;
        }
        return responseData[0]["id"];
      } else {
        throw Exception(
            'Failed to fetch directus foryouconfig id ${response.statusCode} ~ ${response.data}');
      }
    } on DioException catch (e) {
      debugPrint("DioExceptionw: ${e.message}");
      throw Exception('Failed to fetch directus foryouconfig id');
    } catch (e) {
      debugPrint('Error fetching directus foryouconfig id: $e');
      throw Exception('Failed to fetch directus foryouconfig id');
    }
  }

  Future<void> addSelectedCollectionToCache(
      List<Map<String, dynamic>> selectedCollections, String boxName) async {
    debugPrint("addSelectedCollectionToCache called for $boxName");
    Box<Map<dynamic, dynamic>> box;
    if (Hive.isBoxOpen(boxName)) {
      box = Hive.box<Map<dynamic, dynamic>>(boxName);
    } else {
      box = await Hive.openBox<Map<dynamic, dynamic>>(boxName);
    }
    await box.clear();
    for (final collection in selectedCollections) {
      box.put(collection['collection_id'], collection);
    }
  }

  Future<void> clearSelectedCollectionCache(String boxName) async {
    debugPrint("clearSelectedCollectionCache called for $boxName");
    Box<Map<dynamic, dynamic>> box;
    if (Hive.isBoxOpen(boxName)) {
      box = Hive.box<Map<dynamic, dynamic>>(boxName);
    } else {
      box = await Hive.openBox<Map<dynamic, dynamic>>(boxName);
    }
    await box.clear();
  }
}
