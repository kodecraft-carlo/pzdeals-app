import 'package:flutter/material.dart';
import 'package:pzdeals/src/features/deals/models/index.dart';
import 'package:pzdeals/src/utils/helpers/index.dart';

class CreditCardMapper {
  static List<CreditCardDealData> mapToCreditCardDataList(
      List<dynamic> responseData) {
    try {
      return List<CreditCardDealData>.from(responseData.map((json) {
        return CreditCardDealData(
          id: json['id'].toString(),
          title: json['title'],
          displayType: '',
          description: json['body_html'],
          sourceType: 'network',
          imageAsset: json['image_src'],
          isDealExpired: isProductExpired(json['tag_ids']),
          barCodeLink: json['barcode_link'],
        );
      }));
    } catch (e) {
      debugPrint('Error in mapToCreditCardDataList: $e');
      throw ('Error in mapToCreditCardDataList $e');
    }
  }
}
