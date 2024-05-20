import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String getStoreImageUrlFromTags(List<dynamic> tagIds) {
  for (var tag in tagIds) {
    if (tag == null || tag['tags_id'] == null) {
      continue;
    }
    final storeImage = tag['tags_id']['image'];
    if (storeImage != null) {
      return 'https://backend.pzdeals.com/assets/$storeImage';
    }
  }
  return 'assets/images/pzdeals_store.png';
}

bool isProductExpired(List<dynamic> tagIds) {
  for (var tag in tagIds) {
    if (tag == null || tag['tags_id'] == null) {
      continue;
    }
    final tagName = tag['tags_id']['tag_name'].toLowerCase();
    if (tagName == 'sold-out' || tagName == 'soldout') {
      return true;
    }
  }
  return false;
}

bool isProductNoPrice(List<dynamic> tagIds) {
  for (var tag in tagIds) {
    if (tag == null || tag['tags_id'] == null) {
      continue;
    }
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
    if (tag == null || tag['tags_id'] == null) {
      continue;
    }
    final tagDealKey = tag['tags_id']['tag_deal_key'];
    if (tagDealKey != null) {
      if (tagDealKey['deal_description'] != null) {
        tagDealDescription += tagDealKey['deal_description'];
      }
    }
  }
  return tagDealDescription != '' ? '<ul>$tagDealDescription</ul>' : '';
}
