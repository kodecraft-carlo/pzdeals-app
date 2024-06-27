import 'package:flutter/material.dart';
import 'package:pzdeals/src/features/deals/models/collection_data.dart';
import 'package:pzdeals/src/utils/helpers/image_asset.dart';

class CollectionDataMapper {
  static List<CollectionData> mapToCollectionDataList(
      List<dynamic> responseData) {
    try {
      return List<CollectionData>.from(responseData.map((json) {
        String collectionTitle = json['collection_name']
            .toString()
            .replaceAll(RegExp('Deals\\b', caseSensitive: false), '');
        return CollectionData(
          id: json['id'],
          title: collectionTitle.trim(),
          assetSourceType: json['image_src'] == null ? 'asset' : 'network',
          imageAsset:
              getCollectionImage(json['local_image'] ?? '', json['image_src']),
          keyword: json['keywords'] ?? "",
        );
      }));
    } catch (e) {
      debugPrint('Error in mapToCollectionDataList: $e');
      throw ('Error in mapToCollectionDataList $e');
    }
  }
}
