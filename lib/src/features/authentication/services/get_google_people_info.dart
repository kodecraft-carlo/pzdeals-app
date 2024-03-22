import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pzdeals/src/utils/http/http_client.dart';

Future<Map<String, dynamic>> getPersonInfo(
    Map<String, String> authHeaders) async {
  debugPrint('authHeaders: $authHeaders');
  ApiClient apiClient = ApiClient();
  try {
    Response response = await apiClient.dio.get(
      "https://people.googleapis.com/v1/people/me?personFields=genders,birthdays,phoneNumbers&key=",
      options:
          Options(headers: {"Authorization": authHeaders["Authorization"]}),
    );

    if (response.statusCode == 200) {
      debugPrint('Person info: ${response.data}');
      final responseData = response.data;

      // Extract gender
      String gender = responseData["genders"][0]["formattedValue"];

      // Extract birthday
      String birthday = responseData["birthdays"][0]["date"]["year"] +
          "-" +
          responseData["birthdays"][0]["date"]["month"] +
          "-" +
          responseData["birthdays"][0]["date"]["day"];

      // Extract phone number
      String phoneNumber = responseData["phoneNumbers"][0]["value"];

      // Return the extracted information
      return {
        "gender": gender,
        "birthday": birthday,
        "phoneNumber": phoneNumber,
      };
    } else {
      throw Exception('Failed to fetch person info');
    }
  } catch (e) {
    debugPrint('Error fetching person info: $e');
    throw Exception('Failed to fetch person info');
  }
}
