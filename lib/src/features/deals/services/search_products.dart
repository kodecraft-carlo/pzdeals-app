import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pzdeals/src/features/deals/models/index.dart';
import 'package:pzdeals/src/utils/data_mapper/index.dart';
import 'package:pzdeals/src/utils/http/http_client.dart';
import 'package:pzdeals/src/utils/queries/deals_querybuilder.dart';
import 'package:pzdeals/src/utils/queries/index.dart';

class SearchProductService {
  Future<List<SearchDiscoveryData>> fetchSearchDiscovery() async {
    ApiClient apiClient = ApiClient();
    // final authService = ref.watch(directusAuthServiceProvider);
    debugPrint("fetchSearchDiscovery called");

    try {
      Response response = await apiClient.dio.get(getSearchDiscoveryQuery()
          // options: Options(
          //   headers: {'Authorization': 'Bearer $accessToken'},
          // ),
          );
      if (response.statusCode == 200) {
        final responseData = response.data;
        if (responseData == null || responseData.isEmpty) {
          throw Exception('No Data Found');
        }

        final searchDiscovery =
            SearchDiscoveryMapper.mapToSearchDiscoveryDataList(
                responseData['data']);
        return searchDiscovery;
      } else {
        throw Exception('Failed to fetch directus searchDiscovery list');
      }
    } on DioException catch (e) {
      debugPrint("DioExceptionw: ${e.message}");
      throw Exception('Failed to fetch directus searchDiscovery list');
    } catch (e) {
      debugPrint('Error fetching searchDiscovery deals: $e');
      throw Exception('Failed to fetch directus searchDiscovery list');
    }
  }

  Future<List<ProductDealcardData>> searchProduct(
      String searchKey, int pageNumber, String filters) async {
    ApiClient apiClient = ApiClient();
    // final authService = ref.watch(directusAuthServiceProvider);
    debugPrint("searchProduct Deals called using $searchKey");

    try {
      debugPrint(
          'searchProductQuery w/ filters: ${searchProductQuery(searchKey, pageNumber)}$filters');
      Response response = await apiClient.dio
          .get(searchProductQuery(searchKey, pageNumber) + filters
              // options: Options(
              //   headers: {'Authorization': 'Bearer $accessToken'},
              // ),
              );
      if (response.statusCode == 200) {
        final responseData = response.data;
        if (responseData == null || responseData.isEmpty) {
          throw Exception('No Data Found');
        }

        final products =
            ProductMapper.mapToProductDealcardDataList(responseData["data"]);
        return products;
      } else {
        throw Exception('Failed to fetch directus searchProduct list');
      }
    } on DioException catch (e) {
      debugPrint("DioExceptionw: ${e.message}");
      throw Exception('Failed to fetch directus searchProduct list');
    } catch (e) {
      debugPrint('Error fetching frontpage deals: $e');
      throw Exception('Failed to fetch directus searchProduct list');
    }
  }

  Future<List<ProductDealcardData>> searchProductWithCustomQuery(
      String query) async {
    ApiClient apiClient = ApiClient();
    // final authService = ref.watch(directusAuthServiceProvider);
    // debugPrint("searchProductWithCustomQuery Deals called");
    try {
      Response response = await apiClient.dio.get(query
          // options: Options(
          //   headers: {'Authorization': 'Bearer $accessToken'},
          // ),
          );
      if (response.statusCode == 200) {
        final responseData = response.data;
        if (responseData == null || responseData.isEmpty) {
          throw Exception('No Data Found');
        }

        final products =
            ProductMapper.mapToProductDealcardDataList(responseData["data"]);
        return products;
      } else {
        throw Exception(
            'Failed to fetch directus searchProductWithCustomQuery list');
      }
    } on DioException catch (e) {
      debugPrint("DioExceptionw: ${e.message}");
      throw Exception(
          'Failed to fetch directus searchProductWithCustomQuery list');
    } catch (e) {
      debugPrint('Error fetching frontpage deals: $e');
      throw Exception(
          'Failed to fetch directus searchProductWithCustomQuery list');
    }
  }

  Future<ProductDealcardData> fetchProductInfo(int productId) async {
    ApiClient apiClient = ApiClient();
    // final authService = ref.watch(directusAuthServiceProvider);
    debugPrint("fetchProductInfo Deals called for $productId");

    try {
      Response response =
          await apiClient.dio.get(getProductSpecificDetailsQuery(productId)
              // options: Options(
              //   headers: {'Authorization': 'Bearer $accessToken'},
              // ),
              );
      if (response.statusCode == 200) {
        final responseData = response.data;
        if (responseData == null || responseData.isEmpty) {
          throw Exception('No Data Found');
        }

        final products =
            ProductMapper.mapToProductDealcardData(responseData["data"]);
        return products;
      } else {
        throw Exception('Failed to fetch directus product info');
      }
    } on DioException catch (e) {
      debugPrint("DioExceptionw: ${e.message}");
      throw Exception('Failed to fetch directus product info');
    } catch (e) {
      debugPrint('Error fetching fetchProductInfo deals: $e');
      throw Exception('Failed to fetch directus product info');
    }
  }
}
