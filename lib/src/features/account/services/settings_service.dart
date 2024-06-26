import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:pzdeals/src/features/account/models/settings_data.dart';
import 'package:pzdeals/src/utils/data_mapper/index.dart';
import 'package:pzdeals/src/utils/http/http_client.dart';
import 'package:pzdeals/src/utils/queries/index.dart';

class UserSettingsService {
  Future<SettingsData> fetchUserSettings(String boxName, String? userId) async {
    ApiClient apiClient = ApiClient();
    // final authService = ref.watch(directusAuthServiceProvider);
    try {
      Response response = await apiClient.dio.get(getUserSettings(userId!)
          // options: Options(
          //   headers: {'Authorization': 'Bearer $accessToken'},
          // ),
          );
      if (response.statusCode == 200) {
        final responseData = response.data["data"];
        if (responseData == null || responseData.isEmpty) {
          throw Exception('No Data Found');
        }

        final settings = UserSettingsMapper.mapToSettingsData(responseData);
        await _cacheSettings(settings, boxName, userId);
        return settings;
      } else {
        throw Exception('Failed to fetch user settings');
      }
    } on DioException catch (e) {
      debugPrint("DioExceptionw: ${e.message}");
      throw Exception('Failed to fetch user settings');
    } catch (e) {
      debugPrint('Error fetching stores: $e');
      throw Exception('Failed to fetch user settings');
    }
  }

  Future<void> updateUserSettings(
      String boxName, String? userId, SettingsData settings) async {
    ApiClient apiClient = ApiClient();
    try {
      final int id = await getSettingsId(userId!);
      if (id == 0) {
        await addUserSettings(boxName, userId, settings);
        return;
      }

      Response response = await apiClient.dio.patch(
          '/items/notification_settings/$id',
          data: settings.toMapForUpdate(userId)
          // options: Options(
          //   headers: {'Authorization': 'Bearer $accessToken'},
          // ),
          );
      if (response.statusCode != 200) {
        throw Exception(
            'Unable to update user settings ${response.statusCode} ~ ${response.data}');
      }
      await _cacheSettings(settings, boxName, userId);
      await _cacheNumberOfAlerts(settings.numberOfAlerts);
    } on DioException catch (e) {
      debugPrint("DioException: ${e.message}");
      throw Exception('Failed to update user settings');
    } catch (e) {
      debugPrint('Error updating user settings: $e');
      throw Exception('Failed to update user settings');
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
            'Failed to fetch directus settings id ${response.statusCode} ~ ${response.data}');
      }
    } on DioException catch (e) {
      debugPrint("DioExceptionw: ${e.message}");
      throw Exception('Failed to fetch directus settings id');
    } catch (e) {
      debugPrint('Error fetching directus settings id: $e');
      throw Exception('Failed to fetch directus settings id');
    }
  }

  Future<void> addUserSettings(
      String boxName, String userId, SettingsData settings) async {
    ApiClient apiClient = ApiClient();
    try {
      Response response = await apiClient.dio.post(
          '/items/notification_settings',
          data: settings.toMapForCreate(userId)
          // options: Options(
          //   headers: {'Authorization': 'Bearer $accessToken'},
          // ),
          );
      if (response.statusCode != 200) {
        throw Exception(
            'Unable to add user settings ${response.statusCode} ~ ${response.data}');
      }
      await _cacheSettings(settings, boxName, userId);
      await _cacheNumberOfAlerts(settings.numberOfAlerts);
    } on DioException catch (e) {
      debugPrint("DioException: ${e.message}");
      throw Exception('Failed to add user settings');
    } catch (e) {
      debugPrint('Error adding user settings: $e');
      throw Exception('Failed to add user settings');
    }
  }

  Future<bool> isCachedUserSettingsExist(String boxName, String userId) async {
    final cachedSettings = await getCachedSettings(boxName, userId);
    return cachedSettings != null;
  }

  Future<bool> isUserSettingsExist(String userId) async {
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

  Future<SettingsData?> getCachedSettings(
      String boxName, String? userId) async {
    Box<SettingsData> box;
    if (Hive.isBoxOpen(boxName)) {
      debugPrint('Box is already open');
      box = Hive.box<SettingsData>(boxName);
    } else {
      debugPrint('Opening box');
      box = await Hive.openBox<SettingsData>(boxName);
    }
    final settings = box.get('settings_$userId');
    // await box.close();
    return settings;
  }

  Future<void> _cacheSettings(
      SettingsData userSetting, String boxName, String userId) async {
    debugPrint(
        'Caching settings for $boxName ~ settings: ${userSetting.toMap()}');
    final box = await Hive.openBox<SettingsData>(boxName);
    await box.clear();
    box.put('settings_$userId', userSetting);
  }

  Future<void> _cacheNumberOfAlerts(int numberOfAlerts) async {
    Hive.openBox('notificationSettingsBox').then((box) {
      box.clear();
      box.put('numberOfAlerts', numberOfAlerts);
    });
  }
}
