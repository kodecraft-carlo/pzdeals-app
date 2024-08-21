import 'package:flutter/material.dart';
import 'package:pzdeals/src/features/alerts/models/index.dart';
import 'package:pzdeals/src/utils/helpers/image_asset.dart';

class KeywordDataMapper {
  static List<KeywordData> mapToKeywordList(
      List<dynamic> responseData, String keywordType) {
    try {
      return List<KeywordData>.from(responseData.map((json) {
        return KeywordData(
          id: json['id'] ?? '',
          keyword: json['keyword'].toString().toLowerCase(),
          imageUrl: getCollectionImage(
              json['local_img'] ?? '', json['image_src'] ?? ''),
          datecreated: keywordType == 'saved'
              ? json['date_subscribed'] ?? ''
              : json['date_created'] ?? '',
          type: json['type'] ?? '',
        );
      }));
    } catch (e, stackTrace) {
      debugPrint('Error in mapToKeywordList: $stackTrace');
      throw ('Error in mapToKeywordList $e');
    }
  }

  static KeywordData mapToKeywordData(dynamic responseData) {
    try {
      final json = responseData['data'];

      return KeywordData(
        id: json['id'] ?? '',
        keyword: json['keyword'].toString().toLowerCase(),
        imageUrl: json['image_src'] ?? '',
        datecreated: json['date_created'] ?? '',
        type: json['type'] ?? '',
      );
    } catch (e) {
      debugPrint('Error in mapToKeywordData: $e');
      throw ('Error in mapToKeywordData $e');
    }
  }
}
