import 'package:flutter/material.dart';
import 'package:pzdeals/src/features/deals/models/index.dart';
import 'package:pzdeals/src/utils/helpers/image_asset.dart';

class SearchDiscoveryMapper {
  static List<SearchDiscoveryData> mapToSearchDiscoveryDataList(
      List<dynamic> responseData) {
    try {
      return List<SearchDiscoveryData>.from(responseData.map((json) {
        return SearchDiscoveryData(
            title: json['title'],
            imageAsset:
                getCollectionImage(json['local_img'] ?? '', json['image_src']),
            keyword: json['keyword'],
            assetSourceType: 'network');
      }));
    } catch (e) {
      debugPrint('Error in mapToSearchDiscoveryDataList: $e');
      throw ('Error in mapToSearchDiscoveryDataList $e');
    }
  }
}
