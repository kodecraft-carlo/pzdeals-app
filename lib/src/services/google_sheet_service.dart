import 'package:dio/dio.dart' as dioclient;
import 'package:flutter/material.dart';
import 'package:pzdeals/config.dart';

enum SheetType { soldOut, dealAlive, storeRequest, wishlist, flights }

class GoogleSheetService {
  dioclient.Dio dio = dioclient.Dio();

  Future<bool> reportSoldout(String params) async {
    final String url = getSheetUrl(SheetType.soldOut);
    try {
      dioclient.Response response =
          await dio.get('$url$params&sheetname=sold_out');
      debugPrint('response $response');
      if (response.statusCode == 200) {
        final responseData = response.data;
        if (responseData == null || responseData.isEmpty) {
          return false;
        }
        if (responseData['status'] != 0) {
          return false;
        }
        debugPrint('Success writing to Google Sheet for Sold Out Report');
        return true;
      } else {
        throw Exception('Failed to reportSoldout');
      }
    } on dioclient.DioException catch (e, stackTrace) {
      debugPrint('DioException reportSoldout $e');
      debugPrint('DioException reportSoldout trace $stackTrace');
    } catch (e, stackTrace) {
      debugPrint('error reportSoldout $e');
      debugPrint('trace reportSoldout $stackTrace');
      throw Exception(
          "There's a problem processing your request. Please try again");
    }
    return false;
  }

  Future<bool> reportDealAlive(String params) async {
    final String url = getSheetUrl(SheetType.dealAlive);
    try {
      dioclient.Response response =
          await dio.get('$url$params&sheetname=deal_alive');
      debugPrint('response $response');
      if (response.statusCode == 200) {
        debugPrint('success');
        final responseData = response.data;
        if (responseData == null || responseData.isEmpty) {
          return false;
        }
        if (responseData['status'] != 0) {
          return false;
        }
        debugPrint('Success writing to Google Sheet for Deal Alive Report');
        return true;
      } else {
        throw Exception('Failed to reportDealAlive');
      }
    } on dioclient.DioException catch (e, stackTrace) {
      debugPrint('DioException reportDealAlive $e');
      debugPrint('DioException reportDealAlive trace $stackTrace');
    } catch (e, stackTrace) {
      debugPrint('error reportDealAlive $e');
      debugPrint('trace reportDealAlive $stackTrace');
      throw Exception(
          "There's a problem processing your request. Please try again");
    }
    return false;
  }

  Future<bool> requestStore(String params) async {
    final String url = getSheetUrl(SheetType.storeRequest);
    try {
      dioclient.Response response =
          await dio.get('$url$params&sheetname=store_request');
      if (response.statusCode == 200) {
        final responseData = response.data;
        if (responseData == null || responseData.isEmpty) {
          return false;
        }
        if (responseData['status'] != 0) {
          return false;
        }
        debugPrint('Success writing to Google Sheet for Store Request');
        return true;
      } else {
        throw Exception('Failed to requestStore');
      }
    } on dioclient.DioException catch (e, stackTrace) {
      debugPrint('DioException requestStore $e');
      debugPrint('DioException requestStore trace $stackTrace');
    } catch (e, stackTrace) {
      debugPrint('error requestStore $e');
      debugPrint('trace requestStore $stackTrace');
      throw Exception(
          "There's a problem processing your request. Please try again");
    }
    return false;
  }

  Future<bool> notifyWishlisht(String params) async {
    final String url = getSheetUrl(SheetType.wishlist);
    try {
      dioclient.Response response =
          await dio.get('$url$params&sheetname=wish_list');
      if (response.statusCode == 200) {
        final responseData = response.data;
        if (responseData == null || responseData.isEmpty) {
          return false;
        }
        if (responseData['status'] != 0) {
          return false;
        }
        debugPrint('Success writing to Google Sheet for Wishlist Notification');
        return true;
      } else {
        throw Exception('Failed to notifyWishlisht');
      }
    } on dioclient.DioException catch (e, stackTrace) {
      debugPrint('DioException notifyWishlisht $e');
      debugPrint('DioException notifyWishlisht trace $stackTrace');
    } catch (e, stackTrace) {
      debugPrint('error notifyWishlisht $e');
      debugPrint('trace notifyWishlisht $stackTrace');
      throw Exception(
          "There's a problem processing your request. Please try again");
    }
    return false;
  }

  Future<bool> notifyFlights(String params) async {
    final String url = getSheetUrl(SheetType.flights);
    try {
      dioclient.Response response =
          await dio.get('$url$params&sheetname=flights');
      if (response.statusCode == 200) {
        final responseData = response.data;
        if (responseData == null || responseData.isEmpty) {
          return false;
        }
        if (responseData['status'] != 0) {
          return false;
        }
        debugPrint('Success writing to Google Sheet for Flights Notification');
        return true;
      } else {
        throw Exception('Failed to notifyFlights');
      }
    } on dioclient.DioException catch (e, stackTrace) {
      debugPrint('DioException notifyFlights $e');
      debugPrint('DioException notifyFlights trace $stackTrace');
    } catch (e, stackTrace) {
      debugPrint('error notifyFlights $e');
      debugPrint('trace notifyFlights $stackTrace');
      throw Exception(
          "There's a problem processing your request. Please try again");
    }
    return false;
  }

  String getSheetUrl(SheetType sheetType) {
    switch (sheetType) {
      case SheetType.soldOut:
        return AppConfig.googleSheetScriptUrl;
      case SheetType.dealAlive:
        return AppConfig.googleSheetScriptUrl;
      case SheetType.storeRequest:
        return AppConfig.googleSheetScriptUrl;
      case SheetType.wishlist:
        return AppConfig.googleSheetScriptUrl;
      case SheetType.flights:
        return AppConfig.googleSheetScriptUrl;
      default:
        return '';
    }
  }
}
