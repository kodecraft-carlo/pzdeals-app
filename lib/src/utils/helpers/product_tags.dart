import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pzdeals/config.dart';
import 'package:pzdeals/src/utils/helpers/convert_string.dart';

String getStoreImageUrlFromTags(List<dynamic> tagIds) {
  for (var tag in tagIds) {
    if (tag == null || tag['tags_id'] == null) {
      continue;
    }
    final storeImage = tag['tags_id']['image'];
    if (tag['tags_id']['tag_name'] == 'ac') {
      return '${AppConfig.directusAssetsUrl}53ec2659-d1a7-4b64-807e-634089893364';
    }
    if (storeImage != null) {
      return '${AppConfig.directusAssetsUrl}$storeImage';
    }
  }
  return 'assets/images/pzdeals_store.png';
}

String getProductImage(String imageSrc) {
  return '${AppConfig.directusAssetsUrl}$imageSrc';
}

String getStoreNameFromTags(List<dynamic> tagIds) {
  for (var tag in tagIds) {
    if (tag == null || tag['tags_id'] == null) {
      continue;
    }
    final storeImage = tag['tags_id']['image'];
    if (tag['tags_id']['tag_name'] == 'ac') {
      return 'Amazon';
    }
    if (storeImage != null) {
      return formatTagNameToCapitalizedWord(tag['tags_id']['tag_name']);
    }
  }
  return 'PzDeals';
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
  return tagDealDescription != '' ? tagDealDescription : '';
}
