import 'package:flutter/material.dart';

String getSavedKeywordsQuery(String userId) {
  String query = '/keywords/fetch/user/$userId';
  debugPrint('getSavedKeywordsQuery: $query ');
  return query;
}

String getPopularKeywordsQuery(
    int limit, List<String> excludeKeywords, int pageNumber) {
  String query = '/items/popular_keywords'
      '?fields[]=id'
      '&fields[]=keyword'
      '&fields[]=image_src'
      '&limit=$limit'
      '&page=$pageNumber'
      '&filter={"keyword":{"_nin":["${excludeKeywords.join('","')}"]}}'
      '&sort[]=-id';
  debugPrint('getPopularKeywordsQuery: $query ');
  return query;
}

String deleteKeywordQuery() {
  return '/keywords/unsubscribe';
}

String saveKeywordQuery() {
  return '/keywords/subscribe';
}
