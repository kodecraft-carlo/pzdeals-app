import 'package:flutter/material.dart';
import 'package:pzdeals/src/features/deals/models/index.dart';
import 'package:pzdeals/src/utils/helpers/format_price.dart';
import 'package:pzdeals/src/utils/helpers/index.dart';

class ProductMapper {
  static List<ProductDealcardData> mapToProductDealcardDataList(
      List<dynamic> responseData) {
    // debugPrint('responseData: $responseData');
    try {
      return List<ProductDealcardData>.from(responseData.map((json) {
        final dynamic oldPrice = isProductNoPrice(json['tag_ids'])
            ? 0.0
            : isProductPriceValid(json['variants'][0]['compare_at_price'])
                ? priceFormatter(json['variants'][0]['compare_at_price'])
                : 0.0;
        final dynamic price = isProductNoPrice(json['tag_ids'])
            ? 0.0
            : isProductPriceValid(json['variants'][0]['price'])
                ? priceFormatter(json['variants'][0]['price'])
                : 0.0;

        return ProductDealcardData(
          productId: json['id'],
          productName:
              json['title'] != null ? json['title'].toString().trim() : '',
          price: price,
          storeAssetImage: json['store_images'].isNotEmpty
              ? json['store_images'][0]
              : 'assets/images/pzdeals_store.png',
          oldPrice: oldPrice,
          imageAsset: json['image_src'],
          discountPercentage: !isProductNoPrice(json['tag_ids'])
              ? calculateDiscountPercentage(oldPrice, price)
              : 0,
          assetSourceType: 'network',
          isProductNoPrice: isProductNoPrice(json['tag_ids']),
          isProductExpired: isProductExpired(json['tag_ids']),
          productDealDescription: json['body_html'] != null
              ? json['body_html'].toString().trim()
              : '',
          barcodeLink: json['variants'][0]['barcode'] ?? '',
          sku: json['variants'][0]['sku'] != null &&
                  json['variants'][0]['sku'] != ''
              ? json['variants'][0]['sku']
              : '',
          tagDealDescription: extractTagDealDescription(json['tag_ids']),
        );
      }));
    } catch (e, stackTrace) {
      debugPrint('Error in mapToProductDealcardDataList: $e');
      debugPrint('Error in mapToProductDealcardDataList: $stackTrace');
      throw ('Error in mapToProductDealcardDataList $e');
    }
  }

  static ProductDealcardData mapToProductDealcardData(
      List<dynamic> responseData) {
    // debugPrint('responseData: $responseData');
    try {
      final json = responseData[0];
      final dynamic oldPrice = isProductNoPrice(json['tag_ids'])
          ? 0.0
          : isProductPriceValid(json['variants'][0]['compare_at_price'])
              ? priceFormatter(json['variants'][0]['compare_at_price'])
              : 0.0;
      final dynamic price = isProductNoPrice(json['tag_ids'])
          ? 0.0
          : isProductPriceValid(json['variants'][0]['price'])
              ? priceFormatter(json['variants'][0]['price'])
              : 0.0;
      return ProductDealcardData(
        productId: json['id'],
        productName:
            json['title'] != null ? json['title'].toString().trim() : '',
        price: price,
        storeAssetImage: json['store_images'].isNotEmpty
            ? json['store_images'][0]
            : 'assets/images/pzdeals_store.png',
        oldPrice: oldPrice,
        imageAsset: json['image_src'],
        discountPercentage: !isProductNoPrice(json['tag_ids'])
            ? calculateDiscountPercentage(oldPrice, price)
            : 0,
        assetSourceType: 'network',
        isProductNoPrice: isProductNoPrice(json['tag_ids']),
        isProductExpired: isProductExpired(json['tag_ids']),
        productDealDescription: json['body_html'] != null
            ? json['body_html'].toString().trim()
            : '',
        barcodeLink: json['variants'][0]['barcode'] ?? '',
        sku: json['variants'][0]['sku'] != null &&
                json['variants'][0]['sku'] != ''
            ? json['variants'][0]['sku']
            : '',
        tagDealDescription: extractTagDealDescription(json['tag_ids']),
      );
    } catch (e, stackTrace) {
      debugPrint('Error in mapToProductDealcardDataList: $e');
      debugPrint('Error in mapToProductDealcardDataList: $stackTrace');
      throw ('Error in mapToProductDealcardDataList $e');
    }
  }
}
