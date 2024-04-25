import 'package:flutter/material.dart';
import 'package:pzdeals/src/features/deals/models/index.dart';

class SearchDiscoveryMapper {
  static List<SearchDiscoveryData> mapToSearchDiscoveryDataList(
      List<dynamic> responseData) {
    try {
      return List<SearchDiscoveryData>.from(responseData.map((json) {
        return SearchDiscoveryData(
            title: json['title'],
            imageAsset: json['image_src'],
            assetSourceType: 'network');
      }));
    } catch (e) {
      debugPrint('Error in mapToSearchDiscoveryDataList: $e');
      throw ('Error in mapToSearchDiscoveryDataList $e');
    }
  }
}
