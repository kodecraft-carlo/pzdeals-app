import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:pzdeals/src/utils/http/http_client.dart';
import 'package:pzdeals/src/utils/queries/index.dart';

class CategoryNotifService {
  Future<List> fetchUserCategorySettings(String boxName, String? userId) async {
    ApiClient apiClient = ApiClient();
    // final authService = ref.watch(directusAuthServiceProvider);
    try {
      Response response = await apiClient.dio.get('/items/notification_settings'
          '?fields[]=category_notifications&filter[user_id][_eq]=$userId'
          // options: Options(
          //   headers: {'Authorization': 'Bearer $accessToken'},
          // ),
          );
      if (response.statusCode == 200) {
        final responseData = response.data["data"];
        if (responseData == null || responseData.isEmpty) {
          throw Exception('No Data Found');
        }
        final categorySettings = responseData[0]["category_notifications"];
        await _cacheCategorySettings(categorySettings, boxName, userId!);
        return categorySettings;
      } else {
        throw Exception('Failed to fetch user categorySettings');
      }
    } on DioException catch (e) {
      debugPrint("DioExceptionw: ${e.message}");
      throw Exception('Failed to fetch user categorySettings');
    } catch (e) {
      debugPrint('Error fetching stores: $e');
      throw Exception('Failed to fetch user categorySettings');
    }
  }

  Future<void> updateUserCategorySettings(
      String boxName, String? userId, List categorySettings) async {
    ApiClient apiClient = ApiClient();
    try {
      final int id = await getSettingsId(userId!);
      if (id == 0) {
        await addCategorySettings(boxName, userId, categorySettings);
        return;
      }

      Response response = await apiClient.dio.patch(
          '/items/notification_settings/$id',
          data: {"category_notifications": categorySettings}
          // options: Options(
          //   headers: {'Authorization': 'Bearer $accessToken'},
          // ),
          );
      if (response.statusCode != 200) {
        throw Exception(
            'Unable to update user categorySettings ${response.statusCode} ~ ${response.data}');
      }
      await _cacheCategorySettings(categorySettings, boxName, userId);
    } on DioException catch (e) {
      debugPrint("DioException: ${e.message}");
      throw Exception('Failed to update user categorySettings');
    } catch (e) {
      debugPrint('Error updating user settings: $e');
      throw Exception('Failed to update user categorySettings');
    }
  }

  Future<int> getSettingsId(String userId) async {
    ApiClient apiClient = ApiClient();
    // final authService = ref.watch(directusAuthServiceProvider);
    try {
      Response response = await apiClient.dio
          .get('/items/notification_settings/?filter[user_id]=$userId'
              // options: Options(
              //   headers: {'Authorization': 'Bearer $accessToken'},
              // ),
              );
      if (response.statusCode == 200) {
        final responseData = response.data["data"];
        if (responseData == null ||
            responseData.isEmpty ||
            responseData.length <= 0) {
          return 0;
        }
        return responseData[0]["id"];
      } else {
        throw Exception(
            'Failed to fetch directus categorySettings id ${response.statusCode} ~ ${response.data}');
      }
    } on DioException catch (e) {
      debugPrint("DioExceptionw: ${e.message}");
      throw Exception('Failed to fetch directus categorySettings id');
    } catch (e) {
      debugPrint('Error fetching directus settings id: $e');
      throw Exception('Failed to fetch directus categorySettings id');
    }
  }

  Future<void> addCategorySettings(
      String boxName, String userId, List categorySettings) async {
    ApiClient apiClient = ApiClient();
    try {
      Response response = await apiClient.dio.post(
          '/items/notification_settings',
          data: {"category_notifications": categorySettings}
          // options: Options(
          //   headers: {'Authorization': 'Bearer $accessToken'},
          // ),
          );
      if (response.statusCode != 200) {
        throw Exception(
            'Unable to add user categorySettings ${response.statusCode} ~ ${response.data}');
      }
      await _cacheCategorySettings(categorySettings, boxName, userId);
    } on DioException catch (e) {
      debugPrint("DioException: ${e.message}");
      throw Exception('Failed to add user categorySettings');
    } catch (e) {
      debugPrint('Error adding user settings: $e');
      throw Exception('Failed to add user categorySettings');
    }
  }

  Future<bool> isCachedCategorySettingsExist(
      String boxName, String userId) async {
    final cachedSettings = await getCachedCategorySettings(boxName, userId);
    return cachedSettings != null;
  }

  Future<bool> isCategorySettingsExist(String userId) async {
    ApiClient apiClient = ApiClient();
    try {
      Response response = await apiClient.dio.get(getUserSettings(userId)
          // options: Options(
          //   headers: {'Authorization': 'Bearer $accessToken'},
          // ),
          );
      if (response.statusCode == 200) {
        final responseData = response.data["data"];
        return responseData != null && responseData.isNotEmpty;
      } else {
        throw Exception('Failed to fetch user settings');
      }
    } on DioException catch (e) {
      debugPrint("DioException: ${e.message}");
      throw Exception('Failed to fetch user settings');
    } catch (e) {
      debugPrint('Error fetching stores: $e');
      throw Exception('Failed to fetch user settings');
    }
  }

  Future<List?> getCachedCategorySettings(
      String boxName, String? userId) async {
    final box = await Hive.openBox<List>(boxName);
    box.clear();
    // final settings = box.get('categorysettings_$userId');
    // debugPrint('cached categorysettings: $settings');
    await box.close();
    return null;
  }

  Future<void> _cacheCategorySettings(
      List categorySettings, String boxName, String userId) async {
    debugPrint(
        'Caching categorysettings_ for $boxName ~ settings: ${categorySettings.toString()}');
    final box = await Hive.openBox<List>(boxName);
    await box.clear();
    box.put('categorysettings_$userId', categorySettings);
  }
}
