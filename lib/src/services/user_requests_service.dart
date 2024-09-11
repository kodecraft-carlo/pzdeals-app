import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pzdeals/src/utils/http/http_client.dart';

class UserRequestService {
  Future<bool> addStoreRequest(
      String storeName, String userName, String userEmail) async {
    ApiClient apiClient = ApiClient();
    debugPrint(
        'addStoreRequest called with $storeName and $userName and $userEmail');

    try {
      if (await isStoreAlreadyRequested(storeName, userEmail) == false) {
        final request = {
          "store": storeName.trim(),
          "email": userEmail,
          "name": userName
        };
        debugPrint('request: $request');
        Response response =
            await apiClient.dio.post('/items/store_request', data: request
                // options: Options(
                //   headers: {'Authorization': 'Bearer $accessToken'},
                // ),
                );
        if (response.statusCode != 200) {
          throw Exception(
              'Unable to addStoreRequest ${response.statusCode} ~ ${response.data}');
        }
        return true;
      } else {
        debugPrint('User already requested this store');
      }
      return true;
    } on DioException catch (e) {
      debugPrint("DioException: ${e.message}");
      throw Exception('Failed to addStoreRequest');
    } catch (e, stackTrace) {
      debugPrint('Error addStoreRequest: $stackTrace');
      throw Exception('Failed to addStoreRequest');
    }
  }

  Future<bool> addUserRequest(String type, String userEmail) async {
    ApiClient apiClient = ApiClient();
    debugPrint('addUserRequest called with $type and $userEmail');

    try {
      if (await isUserAlreadyRequested(type, userEmail) == false) {
        final request = {"type": type.trim(), "email": userEmail};
        debugPrint('request: $request');
        Response response =
            await apiClient.dio.post('/items/user_request', data: request
                // options: Options(
                //   headers: {'Authorization': 'Bearer $accessToken'},
                // ),
                );
        if (response.statusCode != 200) {
          throw Exception(
              'Unable to addUserRequest ${response.statusCode} ~ ${response.data}');
        }
        return true;
      } else {
        debugPrint('User already requested for $type');
      }
      return true;
    } on DioException catch (e) {
      debugPrint("DioException: ${e}");
      throw Exception('Failed to addUserRequest');
    } catch (e, stackTrace) {
      debugPrint('Error addUserRequest: $stackTrace');
      throw Exception('Failed to addUserRequest');
    }
  }

  Future<bool> isStoreAlreadyRequested(
      String storeName, String userEmail) async {
    ApiClient apiClient = ApiClient();
    debugPrint('isStoreAlreadyRequested called with $storeName and $userEmail');
    try {
      storeName = storeName.trim();
      userEmail = userEmail.trim();
      debugPrint(
          'query: /items/store_request?filter[store][_eq]=$storeName&filter[email][_eq]=$userEmail');
      Response response = await apiClient.dio.get(
          '/items/store_request?filter[store][_eq]=$storeName&filter[email][_eq]=$userEmail'
          // options: Options(
          //   headers: {'Authorization': 'Bearer $accessToken'},
          // ),
          );
      debugPrint('response code: ${response.statusCode}');
      debugPrint('response data: ${response.data}');
      if (response.statusCode != 200) {
        throw Exception(
            'Unable to isStoreAlreadyRequested ${response.statusCode} ~ ${response.data}');
      }

      return response.data["data"].length > 0;
    } on DioException catch (e) {
      debugPrint("DioException: $e");
      throw Exception('Failed to isStoreAlreadyRequested');
    } catch (e, stackTrace) {
      debugPrint('Error isStoreAlreadyRequested: $stackTrace');
      throw Exception('Failed to isStoreAlreadyRequested');
    }
  }

  Future<bool> isUserAlreadyRequested(String type, String userEmail) async {
    ApiClient apiClient = ApiClient();
    debugPrint('isUserAlreadyRequested called with $type and $userEmail');
    try {
      type = type.trim();
      userEmail = userEmail.trim();
      debugPrint(
          'query: /items/user_request?filter[type][_eq]=$type&filter[email][_eq]=$userEmail');
      Response response = await apiClient.dio.get(
          '/items/user_request?filter[type][_eq]=$type&filter[email][_eq]=$userEmail'
          // options: Options(
          //   headers: {'Authorization': 'Bearer $accessToken'},
          // ),
          );
      debugPrint('response code: ${response.statusCode}');
      if (response.statusCode != 200) {
        throw Exception(
            'Unable to isUserAlreadyRequested ${response.statusCode} ~ ${response.data}');
      }
      return response.data["data"].length > 0;
    } on DioException catch (e) {
      debugPrint("DioException: $e");
      throw Exception('Failed to isUserAlreadyRequested');
    } catch (e, stackTrace) {
      debugPrint('Error isUserAlreadyRequested: $stackTrace');
      throw Exception('Failed to isUserAlreadyRequested');
    }
  }
}
