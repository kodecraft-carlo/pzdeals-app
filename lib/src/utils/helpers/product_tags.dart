import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String getStoreImageUrlFromTags(List<dynamic> tagIds) {
  final Map<String, String> storeImageUrls = {
    'woot': 'assets/images/stores/woot.png',
    'amazon': 'assets/images/stores/amazon.png',
    'ebay': 'assets/images/stores/ebay.png',
    'bestbuy': 'assets/images/stores/bestbuy.png',
    'walmart': 'assets/images/stores/walmart.png',
    'newegg': 'assets/images/stores/newegg.png',
  };

  for (var tag in tagIds) {
    final tagName = tag['tags_id']['tag_name'].toLowerCase();
    if (storeImageUrls.containsKey(tagName)) {
      return storeImageUrls[tagName] ?? 'assets/images/pzdeals_store.png';
    }
  }
  return 'assets/images/pzdeals_store.png';
}

bool isProductExpired(List<dynamic> tagIds) {
  for (var tag in tagIds) {
    final tagName = tag['tags_id']['tag_name'].toLowerCase();
    if (tagName == 'sold-out' || tagName == 'soldout') {
      return true;
    }
  }
  return false;
}

bool isProductNoPrice(List<dynamic> tagIds) {
  for (var tag in tagIds) {
    final tagName = tag['tags_id']['tag_name'].toLowerCase();
    if (tagName == 'no-price' || tagName == 'noprice') {
      return true;
    }
  }
  return false;
}

bool isProductPriceValid(dynamic productPrice) {
  if (productPrice == null) {
    return false;
  }
  if (productPrice is String) {
    return double.tryParse(productPrice) != null;
  }
  return productPrice is num;
}

String extractTagDealDescription(List<dynamic> tagIds) {
  String tagDealDescription = '';
  for (var tag in tagIds) {
    final tagDealKey = tag['tags_id']['tag_deal_key'];
    if (tagDealKey != null) {
      if (tagDealKey['deal_description'] != null) {
        tagDealDescription += tagDealKey['deal_description'];
      }
    }
  }
  return tagDealDescription != '' ? '<ul>$tagDealDescription</ul>' : '';
}
