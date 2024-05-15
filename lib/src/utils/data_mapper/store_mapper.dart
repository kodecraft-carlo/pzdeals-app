import 'package:flutter/material.dart';
import 'package:pzdeals/src/features/deals/models/pzstore_data.dart';
import 'package:pzdeals/src/models/index.dart';

class StoreDataMapper {
  static List<PZStoreData> mapToStoreDataList(List<dynamic> responseData) {
    try {
      return List<PZStoreData>.from(
          responseData.where((json) => json['title'] != null).map((json) {
        return PZStoreData(
          id: json['id'],
          title: json['title'],
          imageUrl: json['image_src'] ?? 'assets/images/pzdeals_store.png',
          tagName: json['tags'].length > 0
              ? json['tags'][0]['tags_id']['tag_name']
              : '',
          bodyHtml: json['body'] ?? '',
        );
      }));
    } catch (e) {
      debugPrint('Error in mapToStoreDataList: $e');
      throw ('Error in mapToStoreDataList $e');
    }
  }

  static List<StoreData> mapToStoreIconList(List<dynamic> responseData) {
    try {
      return List<StoreData>.from(
          responseData.where((json) => json['title'] != null).map((json) {
        return StoreData(
          id: json['id'],
          storeName: json['title'],
          handle: json['handle'],
          storeAssetImage:
              json['image_src'] ?? 'assets/images/pzdeals_store.png',
          appStoreImg: json['app_store_img'] ?? '',
          assetSourceType: 'network',
          tagName: json['tags'].length > 0
              ? json['tags'][0]['tags_id']['tag_name']
              : '',
          storeBody: json['body'] ?? '',
        );
      }));
    } catch (e) {
      debugPrint('Error in mapToStoreIconList: $e');
      throw ('Error in mapToStoreIconList $e');
    }
  }

  static StoreData mapToStoreData(List<dynamic> responseData) {
    try {
      final json = responseData[0];
      return StoreData(
        id: json['id'],
        storeName: json['title'],
        handle: json['handle'],
        storeAssetImage: json['image_src'] ?? 'assets/images/pzdeals_store.png',
        appStoreImg: json['app_store_img'] ?? '',
        assetSourceType: 'network',
        tagName: json['tags'].length > 0
            ? json['tags'][0]['tags_id']['tag_name']
            : '',
        storeBody: json['body'] ?? '',
      );
    } catch (e) {
      debugPrint('Error in mapToStoreData: $e');
      throw ('Error in mapToStoreData $e');
    }
  }
}
