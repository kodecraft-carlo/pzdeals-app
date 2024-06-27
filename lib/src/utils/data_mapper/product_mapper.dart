import 'package:flutter/material.dart';
import 'package:pzdeals/src/features/deals/models/index.dart';
import 'package:pzdeals/src/utils/helpers/format_price.dart';
import 'package:pzdeals/src/utils/helpers/image_asset.dart';
import 'package:pzdeals/src/utils/helpers/index.dart';

class ProductMapper {
  static List<ProductDealcardData> mapToProductDealcardDataList(
      List<dynamic> responseData) {
    // debugPrint('responseData: $responseData');
    try {
      return List<ProductDealcardData>.from(responseData.map((json) {
        final dynamic oldPrice = isProductPriceValid(json['variants'].isNotEmpty
                ? json['variants'][0]['compare_at_price']
                : null)
            ? priceFormatter(json['variants'].isNotEmpty
                ? json['variants'][0]['compare_at_price']
                : null)
            : 0.0;
        final dynamic price = isProductPriceValid(json['variants'].isNotEmpty
                ? json['variants'][0]['price']
                : null)
            ? priceFormatter(json['variants'].isNotEmpty
                ? json['variants'][0]['price']
                : null)
            : 0.0;

        return ProductDealcardData(
          productId: json['id'],
          productName:
              json['title'] != null ? json['title'].toString().trim() : '',
          price: priceFormatterWithComma(price),
          storeAssetImage: getStoreImageUrlFromTags(json['tag_ids']),
          oldPrice: priceFormatterWithComma(oldPrice),
          imageAsset: json['local_image'] != null
              ? getProductImage(json['local_image'])
              : json['image_src'],
          discountPercentage: calculateDiscountPercentage(oldPrice, price),
          assetSourceType: 'network',
          isProductNoPrice: isProductNoPrice(json['tag_ids']),
          isProductExpired: isProductExpired(json['tag_ids']),
          productDealDescription: json['body_html'] != null
              ? json['body_html'].toString().trim()
              : '',
          barcodeLink: json['variants'].isNotEmpty
              ? json['variants'][0]['barcode'] ?? ''
              : '',
          sku: json['variants'].isNotEmpty &&
                  json['variants'][0]['sku'] != null &&
                  json['variants'][0]['sku'] != ''
              ? json['variants'][0]['sku']
              : '',
          tagDealDescription: extractTagDealDescription(json['tag_ids']),
          handle: json['handle'] ?? '',
          storeName: json['store'] != null
              ? json['store']['title']
              : getStoreNameFromTags(json['tag_ids']),
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
      final dynamic oldPrice = isProductPriceValid(json['variants'].isNotEmpty
              ? json['variants'][0]['compare_at_price']
              : null)
          ? priceFormatter(json['variants'].isNotEmpty
              ? json['variants'][0]['compare_at_price']
              : null)
          : 0.0;
      final dynamic price = isProductPriceValid(
              json['variants'].isNotEmpty ? json['variants'][0]['price'] : null)
          ? priceFormatter(
              json['variants'].isNotEmpty ? json['variants'][0]['price'] : null)
          : 0.0;
      return ProductDealcardData(
        productId: json['id'],
        productName:
            json['title'] != null ? json['title'].toString().trim() : '',
        price: priceFormatterWithComma(price),
        storeAssetImage: getStoreImageUrlFromTags(json['tag_ids']),
        oldPrice: priceFormatterWithComma(oldPrice),
        imageAsset: json['local_image'] != null
            ? getProductImage(json['local_image'])
            : json['image_src'],
        discountPercentage: calculateDiscountPercentage(oldPrice, price),
        assetSourceType: 'network',
        isProductNoPrice: isProductNoPrice(json['tag_ids']),
        isProductExpired: isProductExpired(json['tag_ids']),
        productDealDescription: json['body_html'] != null
            ? json['body_html'].toString().trim()
            : '',
        barcodeLink: json['variants'].isNotEmpty
            ? json['variants'][0]['barcode'] ?? ''
            : '',
        sku: json['variants'].isNotEmpty &&
                json['variants'][0]['sku'] != null &&
                json['variants'][0]['sku'] != ''
            ? json['variants'][0]['sku']
            : '',
        tagDealDescription: extractTagDealDescription(json['tag_ids']),
        handle: json['handle'] ?? '',
        storeName: json['store'] != null
            ? json['store']['title']
            : getStoreNameFromTags(json['tag_ids']),
      );
    } catch (e, stackTrace) {
      debugPrint('Error in mapToProductDealcardDataList: $e');
      debugPrint('Error in mapToProductDealcardDataList: $stackTrace');
      throw ('Error in mapToProductDealcardDataList $e');
    }
  }
}
