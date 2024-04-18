import 'package:flutter/material.dart';

String getStoresQuery(int pageNumber) {
  String query = '/items/stores'
      '?fields[]=id'
      '&fields[]=title'
      '&fields[]=image_src'
      '&fields[]=tags.tags_id.tag_name'
      '&fields[]=handle'
      '&sort[]=title'
      '&limit=100'
      '&page=$pageNumber';
  debugPrint('getStoresQuery: $query');
  return query;
}

String getCollectionsQuery() {
  return '/items/collection'
      '?filter[collection_name][_nin]=PzBlog,Credit Cards,Featured,PzStyles,noprice,Unknown,Front Page';
}

String filterByStoresQuery(List storeTagNames) {
  String query =
      '&filter={"tag_ids":{"tags_id":{"tag_name":{"_in":["${storeTagNames.join('","')}"]}}}}';
  // '&filter[tag_ids][tags_id][tag_name][_in]=${storeTagNames.join(',')}';
  debugPrint('filterByStoresQuery: $query');
  return query;
}

String filterByCollectionsQuery(List collectionIds) {
  String query =
      '&filter={"collection_ids": {"collection_id": {"_in": ["${collectionIds.join('","')}"]}}}';
  // '&filter[collection_ids][collection_id][_in]=${collectionIds.join(',')}';
  debugPrint('filterByCollectionsQuery: $query');
  return query;
}

String filterByAmountQuery(int minPrice, int maxPrice) {
  String query =
      '&filter={"variants":{"price":{"_between":["$minPrice","$maxPrice"]}}}';
  // '&filter[_and][0][variants][price][_between][0]=$minPrice'
  //     '&filter[_and][0][variants][price][_between][1]=$maxPrice';
  debugPrint('filterByAmountQuery: $query');
  return query;
}
