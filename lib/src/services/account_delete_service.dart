import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:pzdeals/src/utils/http/http_client.dart';

class AccountDeleteService {
  Future<void> deleteAccountFromFirestore(String uuid) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(uuid).delete();
    } catch (e, stackTrace) {
      debugPrint("Error deleting account from firebase: $stackTrace");
      FirebaseCrashlytics.instance.recordError(e, stackTrace);
      throw Exception('Error deleting account');
    }
  }

  Future<void> deleteAccountFromDatabase(String uuid) async {
    debugPrint('deleteAccountFromDatabase called for $uuid');
    ApiClient apiClient = ApiClient();
    const int maxRetryCount = 3;
    int retryCount = 0;
    while (retryCount < maxRetryCount) {
      try {
        final int id = await getId(uuid, 'user');
        if (id == 0) {
          return;
        }

        Response response = await apiClient.dio.delete('/items/users/$id');
        if (response.statusCode != 204) {
          throw Exception(
              'Unable to delete user account ${response.statusCode} ~ ${response.data}');
        }
        return; //exit the loop if successful
      } catch (e, stackTrace) {
        debugPrint('Error deleting user account: $stackTrace');
        retryCount++;
        if (retryCount < maxRetryCount) {
          Duration retryDelay =
              Duration(seconds: 2 * (1 << retryCount)); // Exponential backoff
          debugPrint('Retrying in ${retryDelay.inSeconds} seconds...');
          await Future.delayed(retryDelay);
        } else {
          throw Exception(
              'Failed to delete user account after $maxRetryCount attempts');
        }
      }
    }
  }

  Future<void> deleteAccountSettingsFromDatabase(String uuid) async {
    debugPrint('deleteAccountSettingsFromDatabase called for $uuid');
    ApiClient apiClient = ApiClient();
    const int maxRetryCount = 3;
    int retryCount = 0;
    while (retryCount < maxRetryCount) {
      try {
        final int id = await getId(uuid, 'notification_settings');
        if (id == 0) {
          return;
        }

        Response response =
            await apiClient.dio.delete('/items/notification_settings/$id');
        if (response.statusCode != 204) {
          throw Exception(
              'Unable to delete user settings ${response.statusCode} ~ ${response.data}');
        }
        return; //exit the loop if successful
      } catch (e, stackTrace) {
        debugPrint('Error deleting user settings: $stackTrace');
        retryCount++;
        if (retryCount < maxRetryCount) {
          Duration retryDelay =
              Duration(seconds: 2 * (1 << retryCount)); // Exponential backoff
          debugPrint('Retrying in ${retryDelay.inSeconds} seconds...');
          await Future.delayed(retryDelay);
        } else {
          throw Exception(
              'Failed to delete user settings after $maxRetryCount attempts');
        }
      }
    }
  }

  Future<void> deleteAccountForYouConfigFromDatabase(String uuid) async {
    debugPrint('deleteAccountForYouConfigFromDatabase called for $uuid');
    ApiClient apiClient = ApiClient();
    const int maxRetryCount = 3;
    int retryCount = 0;
    while (retryCount < maxRetryCount) {
      try {
        final int id = await getId(uuid, 'foryou_config');
        if (id == 0) {
          return;
        }

        Response response =
            await apiClient.dio.delete('/items/foryou_config/$id');
        if (response.statusCode != 204) {
          throw Exception(
              'Unable to delete user foryou settings ${response.statusCode} ~ ${response.data}');
        }
        return; //exit the loop if successful
      } catch (e, stackTrace) {
        debugPrint('Error deleting user foryou settings: $stackTrace');
        retryCount++;
        if (retryCount < maxRetryCount) {
          Duration retryDelay =
              Duration(seconds: 2 * (1 << retryCount)); // Exponential backoff
          debugPrint('Retrying in ${retryDelay.inSeconds} seconds...');
          await Future.delayed(retryDelay);
        } else {
          throw Exception(
              'Failed to delete user foryou settings after $maxRetryCount attempts');
        }
      }
    }
  }

  Future<int> getId(String uuid, String queryType) async {
    ApiClient apiClient = ApiClient();
    try {
      String query = '';
      if (queryType == 'user') {
        query = '/items/users/?filter[user_id]=$uuid';
      } else if (queryType == 'notification_settings') {
        query = '/items/notification_settings/?filter[user_id]=$uuid';
      } else if (queryType == 'foryou_config') {
        query = '/items/foryou_config/?filter[user_id]=$uuid';
      }
      Response response = await apiClient.dio.get(query
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
    } catch (e, stackTrace) {
      debugPrint('Error fetching directus user id: $stackTrace');
      throw Exception('Failed to fetch directus user id');
    }
  }
}
