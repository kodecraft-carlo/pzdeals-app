import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:pzdeals/src/features/deals/models/index.dart';
import 'package:pzdeals/src/utils/data_mapper/index.dart';
import 'package:pzdeals/src/utils/http/http_client.dart';
import 'package:pzdeals/src/utils/queries/index.dart';

class FetchCreditCardsDealService {
  Future<List<CreditCardDealData>> getCachedCreditCards(String boxName) async {
    debugPrint("getCachedCreditCards called for $boxName");
    final box = await Hive.openBox<CreditCardDealData>(boxName);
    final creditcards = box.values.toList();
    await box.close();
    return creditcards;
  }

  Future<List<CreditCardDealData>> fetchBannerCreditCardDeals(
      int pageNumber, int limit) async {
    ApiClient apiClient = ApiClient();
    // final authService = ref.watch(directusAuthServiceProvider);
    debugPrint("fetchBannerCreditCardDeals called");
    try {
      Response response = await apiClient.dio
          .get(getCreditCardsCollectionQuery(pageNumber, limit)
              // options: Options(
              //   headers: {'Authorization': 'Bearer $accessToken'},
              // ),
              );
      if (response.statusCode == 200) {
        final responseData = response.data["data"];
        if (responseData == null || responseData.isEmpty) {
          throw Exception('No Data Found');
        }

        final creditcards =
            CreditCardMapper.mapToCreditCardDataList(responseData);

        return creditcards;
      } else {
        throw Exception('Failed to fetch directus creditcards list');
      }
    } on DioException catch (e) {
      debugPrint("DioExceptionw: ${e.message}");
      throw Exception('Failed to fetch directus creditcards list');
    } catch (e) {
      debugPrint('Error fetching frontpage deals: $e');
      throw Exception('Failed to fetch directus creditcards list');
    }
  }

  Future<List<CreditCardDealData>> fetchCreditCardDeals(
      String boxName, int pageNumber, int limit) async {
    ApiClient apiClient = ApiClient();
    // final authService = ref.watch(directusAuthServiceProvider);
    debugPrint("fetchCreditCardDeals called");
    try {
      Response response = await apiClient.dio
          .get(getCreditCardsCollectionQuery(pageNumber, limit)
              // options: Options(
              //   headers: {'Authorization': 'Bearer $accessToken'},
              // ),
              );
      if (response.statusCode == 200) {
        final responseData = response.data["data"];
        if (responseData == null || responseData.isEmpty) {
          throw Exception('No Data Found');
        }

        final creditcards =
            CreditCardMapper.mapToCreditCardDataList(responseData);
        await _cacheCreditCards(creditcards, boxName);
        return creditcards;
      } else {
        throw Exception(
            'Failed to fetch directus creditcards list ${response.statusCode}');
      }
    } on DioException catch (e) {
      debugPrint("DioExceptionw: ${e.message}");
      throw Exception('Failed to fetch directus creditcards list');
    } catch (e) {
      debugPrint('Error fetching frontpage deals: $e');
      throw Exception('Failed to fetch directus creditcards list');
    }
  }

  Future<List<CreditCardDealData>> fetchMoreCreditCardDeals(
      String boxName, int pageNumber, int limit) async {
    ApiClient apiClient = ApiClient();
    // final authService = ref.watch(directusAuthServiceProvider);
    debugPrint("fetchCreditCardDeals called");
    try {
      Response response = await apiClient.dio
          .get(getCreditCardsCollectionQuery(pageNumber, limit)
              // options: Options(
              //   headers: {'Authorization': 'Bearer $accessToken'},
              // ),
              );
      if (response.statusCode == 200) {
        final responseData = response.data["data"];
        if (responseData == null || responseData.isEmpty) {
          throw Exception('No Data Found');
        }

        final creditcards =
            CreditCardMapper.mapToCreditCardDataList(responseData);
        await _cacheCreditCards(creditcards, boxName);
        return creditcards;
      } else {
        throw Exception('Failed to fetch directus creditcards list');
      }
    } on DioException catch (e) {
      debugPrint("DioExceptionw: ${e.message}");
      throw Exception('Failed to fetch directus creditcards list');
    } catch (e) {
      debugPrint('Error fetching frontpage deals: $e');
      throw Exception('Failed to fetch directus creditcards list');
    }
  }

  Future<void> _cacheCreditCards(
      List<CreditCardDealData> creditcards, String boxName) async {
    debugPrint("Caching creditcards for $boxName");
    final box = await Hive.openBox<CreditCardDealData>(boxName);
    await box.clear(); // Clear existing cache
    for (final creditcard in creditcards) {
      box.put(creditcard.id, creditcard);
    }
  }
}
