import 'package:flutter/material.dart';

String getProductsAll(int pageNumber) {
  String query = '/items/products'
      '?fields[]=id'
      '&fields[]=title'
      '&fields[]=body_html'
      '&fields[]=image_src'
      '&fields[]=variants.price'
      '&fields[]=variants.compare_at_price'
      '&fields[]=variants.barcode'
      '&fields[]=variants.sku'
      '&fields[]=tag_ids.tags_id'
      '&fields[]=tag_ids.tags_id.tag_name'
      '&fields[]=tag_ids.tags_id.tag_deal_key.deal_description'
      '&fields[]=collection_ids.collection_id'
      '&fields[]=collection_ids.collection_id.collection_name'
      '&fields[]=store.image_src'
      '&sort=-modified_at,-id'
      '&limit=30'
      '&page=$pageNumber'
      '&filter={"tag_ids":{"tags_id":{"tag_name":{"_nin":["credit-cards","price-mistake"]}}}}';
  debugPrint('getProductsByCollectionQuery: $query');
  return query;
}

String getProductsByCollectionQuery(String pageName, int pageNumber) {
  String query = '/items/products'
      '?fields[]=id'
      '&fields[]=title'
      '&fields[]=body_html'
      '&fields[]=image_src'
      '&fields[]=variants.price'
      '&fields[]=variants.compare_at_price'
      '&fields[]=variants.barcode'
      '&fields[]=variants.sku'
      '&fields[]=tag_ids.tags_id'
      '&fields[]=tag_ids.tags_id.tag_name'
      '&fields[]=tag_ids.tags_id.tag_deal_key.deal_description'
      '&fields[]=collection_ids.collection_id'
      '&fields[]=collection_ids.collection_id.collection_name'
      '&fields[]=store.image_src'
      '&sort=-modified_at,-id'
      '&limit=30'
      '&page=$pageNumber'
      // '&filter[id][_eq]=2231'
      '&filter={"_and":[{"collection_ids":{"collection_id":{"collection_name":{"_icontains":"$pageName"}}}},'
      '{"tag_ids":{"tags_id":{"tag_name":{"_nin":["credit-cards","price-mistake"]}}}}]}';
  debugPrint('getProductsByCollectionQuery: $query');
  return query;
}

String getProductsByProductIdsQuery(List<int> productIds, int pageNumber) {
  String query = '/items/products'
      '?fields[]=id'
      '&fields[]=title'
      '&fields[]=body_html'
      '&fields[]=image_src'
      '&fields[]=variants.price'
      '&fields[]=variants.compare_at_price'
      '&fields[]=variants.barcode'
      '&fields[]=variants.sku'
      '&fields[]=tag_ids.tags_id'
      '&fields[]=tag_ids.tags_id.tag_name'
      '&fields[]=tag_ids.tags_id.tag_deal_key.deal_description'
      '&fields[]=collection_ids.collection_id'
      '&fields[]=collection_ids.collection_id.collection_name'
      '&fields[]=store.image_src'
      '&sort=-modified_at,-id'
      '&limit=30'
      '&page=$pageNumber'
      '&filter={"id":{"_in":["${productIds.join('","')}"]}}';

  return query;
}

String getProductsByCollectionIdQuery(int collectionId, int limit) {
  String query = '/items/products'
      '?fields[]=id'
      '&fields[]=title'
      '&fields[]=body_html'
      '&fields[]=image_src'
      '&fields[]=variants.price'
      '&fields[]=variants.compare_at_price'
      '&fields[]=variants.barcode'
      '&fields[]=variants.sku'
      '&fields[]=tag_ids.tags_id'
      '&fields[]=tag_ids.tags_id.tag_name'
      '&fields[]=tag_ids.tags_id.tag_deal_key.deal_description'
      '&fields[]=collection_ids.collection_id'
      '&fields[]=collection_ids.collection_id.collection_name'
      '&fields[]=store.image_src'
      '&sort=-modified_at,-id'
      '&limit=$limit'
      '&filter={"_and":[{"collection_ids":{"collection_id":{"_eq":$collectionId}}},'
      '{"tag_ids":{"tags_id":{"tag_name":{"_nin":["credit-cards","price-mistake"]}}}}]}';

  debugPrint('getProductsByCollectionIdQuery: $query');
  return query;
}

String getProductSpecificDetailsQuery(int productId) {
  String query = '/items/products'
      '?filter={"id":{"_eq":$productId}}'
      '&fields[]=id'
      '&fields[]=title'
      '&fields[]=body_html'
      '&fields[]=image_src'
      '&fields[]=variants.price'
      '&fields[]=variants.barcode'
      '&fields[]=variants.sku'
      '&fields[]=variants.compare_at_price'
      '&fields[]=tag_ids.tags_id'
      '&fields[]=tag_ids.tags_id.tag_name'
      '&fields[]=tag_ids.tags_id.tag_deal_key.deal_description'
      '&fields[]=store.image_src'
      '&sort=-modified_at,-id';
  return query;
}

String getCreditCardsCollectionQuery(int pageNumber, int limit) {
  return '/items/products'
      '?fields[]=id'
      '&fields[]=title'
      '&fields[]=body_html'
      '&fields[]=image_src'
      '&fields[]=variants.barcode'
      '&fields[]=variants.sku'
      '&fields[]=tag_ids.tags_id'
      '&fields[]=tag_ids.tags_id.tag_name'
      '&fields[]=tag_ids.tags_id.tag_deal_key.deal_description'
      '&fields[]=collection_ids.collection_id'
      '&fields[]=collection_ids.collection_id.collection_name'
      '&sort=-modified_at,-id'
      '&limit=$limit'
      '&page=$pageNumber'
      '&filter={"collection_ids":{"collection_id":{"collection_name":{"_eq":"Credit Cards"}}}}';
}

String getProductsByTagQuery(String tagName, int pageNumber) {
  return '/items/products'
      '?fields[]=id'
      '&fields[]=title'
      '&fields[]=body_html'
      '&fields[]=image_src'
      '&fields[]=variants.price'
      '&fields[]=variants.compare_at_price'
      '&fields[]=variants.barcode'
      '&fields[]=variants.sku'
      '&fields[]=tag_ids.tags_id'
      '&fields[]=tag_ids.tags_id.tag_name'
      '&fields[]=tag_ids.tags_id.tag_deal_key.deal_description'
      '&fields[]=collection_ids.collection_id'
      '&fields[]=collection_ids.collection_id.collection_name'
      '&fields[]=store.image_src'
      '&sort=-modified_at,-id'
      '&limit=30'
      '&page=$pageNumber'
      '&filter={"_and":[{"tag_ids":{"tag_id":{"tag_name":{"_in":"$tagName"}}}},'
      '{"collection_ids":{"collection_id":{"collection_name":{"_ncontains":"Credit Cards"}}}}]}';
}

String getCollections(String colType) {
  String query = '';
  if (colType == 'foryou') {
    query = '/items/collection'
        '?filter[collection_name][_nin]'
        '=PzBlog,Credit Cards,Featured,PzStyles,noprice,Unknown,Front Page';
  } else {
    query = '/items/collection'
        '?filter[collection_name][_nin]'
        '=noprice,Unknown';
  }
  debugPrint('getCollections query: $query');
  return query;
}

String searchProductQuery(String keyword, int pageNumber) {
  String query = '/items/products'
      '?fields[]=id'
      '&fields[]=title'
      '&fields[]=body_html'
      '&fields[]=image_src'
      '&fields[]=variants.price'
      '&fields[]=variants.compare_at_price'
      '&fields[]=variants.barcode'
      '&fields[]=variants.sku'
      '&fields[]=tag_ids.tags_id'
      '&fields[]=tag_ids.tags_id.tag_name'
      '&fields[]=tag_ids.tags_id.tag_deal_key.deal_description'
      '&fields[]=collection_ids.collection_id'
      '&fields[]=collection_ids.collection_id.collection_name'
      '&fields[]=store.image_src'
      '&sort=-modified_at,-id'
      '&limit=30'
      '&page=$pageNumber'
      '&filter={"_and":[{"title": { "_icontains": "${keyword.trim()}" }},'
      '{"tag_ids":{"tags_id":{"tag_name":{"_neq":"price-mistake"}}}}]}';
  return query;
}

String searchPercentageProductQuery(int pageNumber) {
  String query = '/items/products'
      '?fields[]=id'
      '&fields[]=title'
      '&fields[]=body_html'
      '&fields[]=image_src'
      '&fields[]=variants.price'
      '&fields[]=variants.compare_at_price'
      '&fields[]=variants.barcode'
      '&fields[]=variants.sku'
      '&fields[]=tag_ids.tags_id'
      '&fields[]=tag_ids.tags_id.tag_name'
      '&fields[]=tag_ids.tags_id.tag_deal_key.deal_description'
      '&fields[]=collection_ids.collection_id'
      '&fields[]=collection_ids.collection_id.collection_name'
      '&fields[]=store.image_src'
      '&sort=-modified_at,-id'
      '&limit=30'
      '&page=$pageNumber'
      '&filter={"_and":[{"collection_ids":{"collection_id":{"collection_name":{"_nin":"Credit Cards,PzBlog,PzStyles,noprice,Unknown"}}}},'
      '{"tag_ids":{"tags_id":{"tag_name":{"_neq":"price-mistake"}}}}]}';
  return query;
}

String getSearchDiscoveryQuery() {
  String query = '/items/search_discovery?fields[]=title&fields[]=image_src';
  return query;
}
