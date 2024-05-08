import 'package:flutter/material.dart';
import 'package:pzdeals/src/features/deals/models/index.dart';
import 'package:pzdeals/src/utils/helpers/index.dart';

class ProductMapper {
  static List<ProductDealcardData> mapToProductDealcardDataList(
      List<dynamic> responseData) {
    try {
      return List<ProductDealcardData>.from(responseData.map((json) {
        final double oldPrice = isProductNoPrice(json['tag_ids'])
            ? 0
            : isProductPriceValid(json['variants'][0]['compare_at_price'])
                ? double.parse(json['variants'][0]['compare_at_price'])
                : 0;
        final double price = isProductNoPrice(json['tag_ids'])
            ? 0
            : isProductPriceValid(json['variants'][0]['price'])
                ? double.parse(json['variants'][0]['price'])
                : 0;
        return ProductDealcardData(
            productId: json['id'],
            productName: json['title'],
            price: price.toStringAsFixed(2),
            storeAssetImage: json['store_images'].isNotEmpty
                ? json['store_images'][0]
                : 'assets/images/pzdeals_store.png',
            oldPrice: oldPrice.toStringAsFixed(2),
            imageAsset: json['image_src'],
            discountPercentage: !isProductNoPrice(json['tag_ids'])
                ? calculateDiscountPercentage(oldPrice, price)
                : 0,
            assetSourceType: 'network',
            isProductNoPrice: isProductNoPrice(json['tag_ids']),
            isProductExpired: isProductExpired(json['tag_ids']),
            productDealDescription: json['body_html'] ?? '',
            barcodeLink: json['variants'][0]['barcode'] ?? '',
            tagDealDescription: extractTagDealDescription(json['tag_ids']));
      }));
    } catch (e) {
      debugPrint('Error in mapToProductDealcardDataList: $e');
      throw ('Error in mapToProductDealcardDataList $e');
    }
  }

  static ProductDealcardData mapToProductDealcardData(
      List<dynamic> responseData) {
    try {
      final json = responseData[0];
      final double oldPrice = isProductNoPrice(json['tag_ids'])
          ? 0
          : isProductPriceValid(json['variants'][0]['compare_at_price'])
              ? double.parse(json['variants'][0]['compare_at_price'])
              : 0;
      final double price = isProductNoPrice(json['tag_ids'])
          ? 0
          : isProductPriceValid(json['variants'][0]['price'])
              ? double.parse(json['variants'][0]['price'])
              : 0;
      return ProductDealcardData(
        productId: json['id'],
        productName: json['title'],
        price: price.toStringAsFixed(2),
        storeAssetImage: json['store_images'].isNotEmpty
            ? json['store_images'][0]
            : 'assets/images/pzdeals_store.png',
        oldPrice: oldPrice.toStringAsFixed(2),
        imageAsset: json['image_src'],
        discountPercentage: !isProductNoPrice(json['tag_ids'])
            ? calculateDiscountPercentage(oldPrice, price)
            : 0,
        assetSourceType: 'network',
        isProductNoPrice: isProductNoPrice(json['tag_ids']),
        isProductExpired: isProductExpired(json['tag_ids']),
        productDealDescription: json['body_html'],
        barcodeLink: json['variants'][0]['barcode'] ?? '',
      );
    } catch (e) {
      debugPrint('Error in mapToProductDealcardDataList: $e');
      throw ('Error in mapToProductDealcardDataList $e');
    }
  }
}
