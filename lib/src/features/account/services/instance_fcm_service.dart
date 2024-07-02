import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pzdeals/src/utils/http/http_client.dart';

class InstanceFcmService {
  Future<int> getFcmId(String userId) async {
    ApiClient apiClient = ApiClient();
    // final authService = ref.watch(directusAuthServiceProvider);
    try {
      Response response =
          await apiClient.dio.get('/items/users/?filter[user_id]=$userId'
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
            'Failed to fetch directus fcm id ${response.statusCode} ~ ${response.data}');
      }
    } on DioException catch (e) {
      debugPrint("DioExceptionw: ${e.message}");
      throw Exception('Failed to fetch directus fcm id');
    } catch (e) {
      debugPrint('Error fetching directus fcm id: $e');
      throw Exception('Failed to fetch directus fcm id');
    }
  }

  Future<void> deleteFcmToken(String instanceId) async {
    ApiClient apiClient = ApiClient();
    try {
      final int id = await getFcmId(instanceId);
      if (id == 0) {
        return;
      }

      Response response = await apiClient.dio.delete('/items/users/$id'
          // options: Options(
          //   headers: {'Authorization': 'Bearer $accessToken'},
          // ),
          );
      if (response.statusCode != 204) {
        throw Exception(
            'Unable to delete fcm id ${response.statusCode} ~ ${response.data}');
      }
    } on DioException catch (e) {
      debugPrint("DioException: ${e.message}");
      throw Exception('Failed to delete fcm id');
    } catch (e) {
      debugPrint('Error deleting fcm id: $e');
      throw Exception('Failed to delete fcm id');
    }
  }

  Future<void> updateInstanceFcmToken(String fcmToken, String? userId) async {
    debugPrint('Updating instance fcm token $fcmToken for user $userId');
    ApiClient apiClient = ApiClient();
    try {
      final int id = await getFcmId(userId!);
      if (id == 0) {
        await addInstanceFcmToken(fcmToken, userId);
        return;
      }

      Response response = await apiClient.dio.patch('/items/users/$id', data: {
        "user_id": userId,
        "fcm_token": fcmToken,
      }
          // options: Options(
          //   headers: {'Authorization': 'Bearer $accessToken'},
          // ),
          );
      if (response.statusCode != 200) {
        throw Exception(
            'Unable to update instance fcm token ${response.statusCode} ~ ${response.data}');
      }
    } on DioException catch (e) {
      debugPrint("DioException: ${e.message}");
      throw Exception('Failed to update instance fcm token');
    } catch (e) {
      debugPrint('Error updating instance fcm tokens: $e');
      throw Exception('Failed to instance fcm tokens');
    }
  }

  Future<void> addInstanceFcmToken(String fcmToken, String userId) async {
    ApiClient apiClient = ApiClient();
    try {
      Response response = await apiClient.dio.post('/items/users', data: {
        "user_id": userId,
        "fcm_token": fcmToken,
      }
          // options: Options(
          //   headers: {'Authorization': 'Bearer $accessToken'},
          // ),
          );
      if (response.statusCode != 200) {
        throw Exception(
            'Unable to add instance fcm token ${response.statusCode} ~ ${response.data}');
      }
    } on DioException catch (e) {
      debugPrint("DioException: ${e.message}");
      throw Exception('Failed to add instance fcm token');
    } catch (e) {
      debugPrint('Error adding instance fcm token: $e');
      throw Exception('Failed to add instance fcm token');
    }
  }
}
