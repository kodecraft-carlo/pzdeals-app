import 'package:flutter/material.dart';
import 'package:pzdeals/src/features/alerts/models/index.dart';

class KeywordDataMapper {
  static List<KeywordData> mapToKeywordList(
      List<dynamic> responseData, String keywordType) {
    try {
      return List<KeywordData>.from(responseData.map((json) {
        return KeywordData(
          id: json['id'] ?? '',
          keyword: json['keyword'].toString().toLowerCase(),
          imageUrl: json['image_src'] ?? '',
          datecreated: keywordType == 'saved'
              ? json['date_subscribed'] ?? ''
              : json['date_created'] ?? '',
        );
      }));
    } catch (e) {
      debugPrint('Error in mapToKeywordList: $e');
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
      );
    } catch (e) {
      debugPrint('Error in mapToKeywordData: $e');
      throw ('Error in mapToKeywordData $e');
    }
  }
}
