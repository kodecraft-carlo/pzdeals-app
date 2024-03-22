import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pzdeals/src/utils/http/http_client.dart';
import 'package:pzdeals/src/utils/queries/index.dart';

class FcmTokenService {
  Future<void> addUserFcmToken(String userUID, String fcmToken) async {
    ApiClient apiClient = ApiClient();
    debugPrint('addUserFcmToken called with $userUID and $fcmToken');
    try {
      Response response = await apiClient.dio.post('/items/users', data: {
        "user_id": userUID,
        "fcm_token": fcmToken,
      }
          // options: Options(
          //   headers: {'Authorization': 'Bearer $accessToken'},
          // ),
          );

      if (response.statusCode != 200) {
        throw Exception(
            'Failed to add user fcm token ${response.statusCode} ~ ${response.data}');
      }
    } on DioException catch (e) {
      debugPrint("DioException: ${e.message}");
      throw Exception('Failed to add user fcm token');
    } catch (e) {
      debugPrint('Error adding user fcm token: $e');
      throw Exception('Failed to add user fcm token');
    }
  }

  Future<void> updateUserFcmToken(String userUID, String fcmToken) async {
    ApiClient apiClient = ApiClient();
    debugPrint('updateUserFcmToken called with $userUID and $fcmToken');
    try {
      final int id = await getId(userUID);
      if (id == 0) {
        await addUserFcmToken(userUID, fcmToken);
        return;
      }
      Response response = await apiClient.dio.patch('/items/users/$id', data: {
        "user_id": userUID,
        "fcm_token": fcmToken,
      }
          // options: Options(
          //   headers: {'Authorization': 'Bearer $accessToken'},
          // ),
          );
      if (response.statusCode != 200) {
        throw Exception(
            'Unable to update user fcm token ${response.statusCode} ~ ${response.data}');
      }
    } on DioException catch (e) {
      debugPrint("DioException: ${e.message}");
      throw Exception('Failed to update user fcm token');
    } catch (e) {
      debugPrint('Error updating user fcm token: $e');
      throw Exception('Failed to update user fcm token');
    }
  }

  Future<int> getId(String userUID) async {
    ApiClient apiClient = ApiClient();
    // final authService = ref.watch(directusAuthServiceProvider);
    debugPrint('getId called with $userUID');
    try {
      Response response = await apiClient.dio.get(getDirectusUserId(userUID)
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
            'Failed to fetch directus user id ${response.statusCode} ~ ${response.data}');
      }
    } on DioException catch (e) {
      debugPrint("DioExceptionw: ${e.message}");
      throw Exception('Failed to fetch directus user id');
    } catch (e) {
      debugPrint('Error fetching directus user id: $e');
      throw Exception('Failed to fetch directus user id');
    }
  }
}
