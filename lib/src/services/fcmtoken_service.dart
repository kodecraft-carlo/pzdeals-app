import 'package:dio/dio.dart';
import 'package:firebase_installations/firebase_installations.dart';
import 'package:flutter/material.dart';
import 'package:pzdeals/src/utils/http/http_client.dart';
import 'package:pzdeals/src/utils/queries/index.dart';
import 'package:pzdeals/src/utils/queries/users_querybuilder.dart';

class FcmTokenService {
  String? instanceId;
  FcmTokenService() {
    setInstanceId();
  }
  Future<void> setInstanceId() async {
    instanceId = await FirebaseInstallations.id;
  }

  Future<void> addUserFcmToken(String userUID, String fcmToken) async {
    ApiClient apiClient = ApiClient();
    debugPrint('addUserFcmToken called with $userUID and $fcmToken');
    try {
      Response response = await apiClient.dio.post('/items/users', data: {
        "user_id": userUID,
        "fcm_token": fcmToken,
        "instance_id": instanceId,
      }
          // options: Options(
          //   headers: {'Authorization': 'Bearer $accessToken'},
          // ),
          );

      if (response.statusCode != 200) {
        debugPrint(
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
    const int maxRetryCount = 3;
    int retryCount = 0;
    Duration retryDelay = Duration(seconds: 2 * (1 << retryCount));

    while (retryCount < maxRetryCount) {
      try {
        debugPrint(
            'Attempt ${retryCount + 1}: updateUserFcmToken called with $userUID and $fcmToken');
        ApiClient apiClient = ApiClient();
        final int id = await getUserId(userUID);
        debugPrint('updateUserFcmToken id: $id');
        if (id == 0) {
          await addUserFcmToken(userUID, fcmToken);
          return;
        }
        Response response =
            await apiClient.dio.patch('/items/users/$id', data: {
          "user_id": userUID,
          "fcm_token": fcmToken,
          "instance_id": instanceId,
        });
        if (response.statusCode != 200) {
          throw Exception(
              'Unable to update user fcm token ${response.statusCode} ~ ${response.data}');
        }
        debugPrint('FCM token updated successfully');
        return; // Exit the loop if successful
      } catch (e, stackTrace) {
        debugPrint('Error updating user FCM token: $stackTrace');
        retryCount++;
        if (retryCount < maxRetryCount) {
          debugPrint('Retrying in ${retryDelay.inSeconds} seconds...');
          await Future.delayed(retryDelay);
        } else {
          throw Exception(
              'Failed to update user FCM token after $maxRetryCount attempts');
        }
      }
    }
  }

  Future<int> getIdWithInstanceId(String instanceID) async {
    ApiClient apiClient = ApiClient();
    // final authService = ref.watch(directusAuthServiceProvider);
    debugPrint('fcmTokenService: getIdWithInstanceId instance ID: $instanceID');
    try {
      Response response =
          await apiClient.dio.get(getUserIdFromInstanceId(instanceID)
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
        debugPrint(
            'Failed to fetch directus user id ${response.statusCode} ~ ${response.data}');
        return 0;
      }
    } on DioException catch (e) {
      debugPrint("DioExceptionw: ${e.message}");
      throw Exception('Failed to fetch directus user id');
    } catch (e) {
      debugPrint('Error fetching directus user id: $e');
      throw Exception('Failed to fetch directus user id');
    }
  }

  Future<int> getId(String userUID) async {
    ApiClient apiClient = ApiClient();
    // final authService = ref.watch(directusAuthServiceProvider);
    debugPrint('fcmTokenService: getId called with $userUID and $instanceId');
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
        debugPrint(
            'Failed to fetch directus user id ${response.statusCode} ~ ${response.data}');
        return 0;
      }
    } on DioException catch (e) {
      debugPrint("DioExceptionw: ${e.message}");
      throw Exception('Failed to fetch directus user id');
    } catch (e, stackTrace) {
      debugPrint('Error fetching directus user id: $stackTrace');
      throw Exception('Failed to fetch directus user id');
    }
  }

  Future<int> getUserId(String userUID) async {
    final int id1 = await getIdWithInstanceId(instanceId ?? '');
    if (id1 != 0) {
      debugPrint('has instance id');
      return id1;
    }

    final int id2 = await getId(userUID);
    if (id2 != 0) {
      debugPrint('has user ID');
      return id2;
    }

    return 0;
  }
}
