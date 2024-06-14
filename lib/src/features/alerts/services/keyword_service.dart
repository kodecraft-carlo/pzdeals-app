import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:pzdeals/src/features/alerts/models/index.dart';
import 'package:pzdeals/src/utils/data_mapper/index.dart';
import 'package:pzdeals/src/utils/http/http_client.dart';
import 'package:pzdeals/src/utils/queries/alerts_querybuilder.dart';
import 'package:pzdeals/src/utils/queries/index.dart';

class KeywordService {
  Future<List<KeywordData>> fetchSavedKeywords(
      String boxName, int pageNumber, String userId) async {
    ApiClient apiClient = ApiClient();
    // final authService = ref.watch(directusAuthServiceProvider);
    try {
      Response response = await apiClient.dio.get(getSavedKeywordsQuery(userId)
          // options: Options(
          //   headers: {'Authorization': 'Bearer $accessToken'},
          // ),
          );
      if (response.statusCode == 200) {
        final responseData = response.data["keywords"];
        if (responseData == null || responseData.isEmpty) {
          throw Exception('No Data Found');
        }

        final keywords =
            KeywordDataMapper.mapToKeywordList(responseData, 'saved');
        await _cacheKeywords(keywords, boxName);
        return keywords;
      } else {
        throw Exception('Failed to fetch directus keywords list');
      }
    } on DioException catch (e) {
      debugPrint("DioExceptionw: ${e.message}");
      throw Exception('Failed to fetch directus keywords list');
    } catch (e) {
      debugPrint('Error fetching keywords list: $e');
      throw Exception('Failed to fetch directus keywords list');
    }
  }

  Future<List<KeywordData>> fetchPopularKeyword(String boxName, int limit,
      List<String> excludedKeywords, int pageNumber) async {
    ApiClient apiClient = ApiClient();
    // final authService = ref.watch(directusAuthServiceProvider);
    try {
      Response response = await apiClient.dio
          .get(getPopularKeywordsQuery(limit, excludedKeywords, pageNumber)
              // options: Options(
              //   headers: {'Authorization': 'Bearer $accessToken'},
              // ),
              );
      if (response.statusCode == 200) {
        final responseData = response.data["data"];
        if (responseData == null || responseData.isEmpty) {
          throw Exception('No Data Found');
        }

        final keywords =
            KeywordDataMapper.mapToKeywordList(responseData, 'popular');
        await _cacheKeywords(keywords, boxName);
        return keywords;
      } else {
        throw Exception('Failed to fetch directus popular keywords list');
      }
    } on DioException catch (e) {
      debugPrint("DioExceptionw: ${e.message}");
      throw Exception('Failed to fetch directus popular keywords list');
    } catch (e) {
      debugPrint('Error fetching stores: $e');
      throw Exception('Failed to fetch directus popular keywords list');
    }
  }

  Future<List<String>> fetchCategoryKeywords() async {
    ApiClient apiClient = ApiClient();
    // final authService = ref.watch(directusAuthServiceProvider);
    try {
      Response response = await apiClient.dio.get(getCategoryKeywordsQuery()
          // options: Options(
          //   headers: {'Authorization': 'Bearer $accessToken'},
          // ),
          );
      if (response.statusCode == 200) {
        final responseData = response.data["data"];
        if (responseData == null || responseData.isEmpty) {
          throw Exception('No Data Found');
        }

        final List<String> categories = responseData
            .map((e) => e["keyword"].toString())
            .toList()
            .cast<String>();
        return categories;
      } else {
        throw Exception('Failed to fetch directus category keywords list');
      }
    } on DioException catch (e) {
      debugPrint("DioExceptionw: ${e.message}");
      throw Exception('Failed to fetch directus category keywords list');
    } catch (e, stackTrace) {
      debugPrint('Error fetching category keywords: $stackTrace ~ $e');
      throw Exception('Failed to fetch directus category keywords list');
    }
  }

  Future<List<KeywordData>> getCachedKeywords(String boxName) async {
    debugPrint("getCachedKeywords called for $boxName");
    final box = await Hive.openBox<KeywordData>(boxName);
    final keywords = box.values.toList();
    await box.close();
    return keywords;
  }

  Future<KeywordData> addKeyword(
      String keyword, String userId, String boxName) async {
    ApiClient apiClient = ApiClient();
    try {
      Response response = await apiClient.dio.post(saveKeywordQuery(), data: {
        "keyword": keyword,
        "user_id": userId,
      }
          // options: Options(
          //   headers: {'Authorization': 'Bearer $accessToken'},
          // ),
          );
      if (response.statusCode != 200) {
        throw Exception('Unable to add keyword ${response.statusCode}');
      }
      final responseData =
          KeywordData(keyword: keyword, id: response.data["keywordId"]);
      // final keywordData = KeywordDataMapper.mapToKeywordData(response.data);
      await addKeywordToCache(responseData, boxName);
      return responseData;
    } on DioException catch (e) {
      debugPrint("DioException: ${e.message}");
      throw Exception('Failed to add keyword');
    } catch (e) {
      debugPrint('Error adding keyword: $e');
      throw Exception('Failed to add keyword');
    }
  }

  Future<void> _cacheKeywords(
      List<KeywordData> keywords, String boxName) async {
    debugPrint("Caching keywords for $boxName");
    final box = await Hive.openBox<KeywordData>(boxName);
    await box.clear(); // Clear existing cache
    for (final keyword in keywords) {
      box.put(keyword.keyword, keyword);
    }
  }

  Future<void> deleteKeyword(
      String keyword, String userId, String boxName) async {
    ApiClient apiClient = ApiClient();
    try {
      debugPrint('deleteKeyword called for $keyword ~ ${deleteKeywordQuery()}');
      Response response = await apiClient.dio.post(deleteKeywordQuery(), data: {
        "keyword": keyword,
        "user_id": userId,
      });
      if (response.statusCode != 200) {
        throw Exception('Unable to delete keyword ${response.statusCode}');
      }
    } on DioException catch (e) {
      debugPrint("DioException: ${e.message}");
      throw Exception('Failed to delete keyword');
    } catch (e) {
      debugPrint('Error deleting keyword: $e');
      throw Exception('Failed to delete keyword');
    }
  }

  Future<void> removeKeywordFromCache(String keyword, String boxName) async {
    debugPrint("Removing keyword with id $keyword from cache for $boxName");
    final box = await Hive.openBox<KeywordData>(boxName);
    box.delete(keyword);
    await box.close();
  }

  Future<void> removeKeywordFromCacheByKeywordName(
      String keyword, String boxName) async {
    debugPrint("Removing keyword with id $keyword from cache for $boxName");
    final box = await Hive.openBox<KeywordData>(boxName);
    final index = box.values.toList().indexWhere(
        (data) => data.keyword.toLowerCase() == keyword.toLowerCase());
    if (index != -1) {
      await box.deleteAt(index);
    }
    await box.close();
  }

  Future<void> addKeywordToCache(KeywordData keyword, String boxName) async {
    final box = await Hive.openBox<KeywordData>(boxName);
    box.put(keyword.keyword, keyword);
    await box.close();
  }

  Future<void> clearKeywordCache(String boxName) async {
    final box = await Hive.openBox<KeywordData>(boxName);
    await box.clear();
    await box.close();
  }
}
