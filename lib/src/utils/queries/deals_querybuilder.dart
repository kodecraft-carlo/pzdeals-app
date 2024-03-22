import 'package:flutter/material.dart';

String getProductsByCollectionQuery(String pageName, int pageNumber) {
  String query = '/products_store'
      '?fields[]=id'
      '&fields[]=title'
      '&fields[]=image_src'
      '&fields[]=variants.price'
      '&fields[]=variants.compare_at_price'
      '&fields[]=variants.barcode'
      '&fields[]=tag_ids.tags_id'
      '&fields[]=tag_ids.tags_id.tag_name'
      '&fields[]=collection_ids.collection_id'
      '&fields[]=collection_ids.collection_id.collection_name'
      '&sort[]=id'
      '&limit=50'
      '&page=$pageNumber'
      // '&filter[id][_eq]=2231'
      '&filter={"collection_ids":{"collection_id":{"collection_name":{"_icontains":"$pageName"}}}}'
      '&filter={"tag_ids":{"tags_id":{"tag_name":{"_neq":"credit-cards"}}}}';

  debugPrint('getProductsByCollectionQuery: $query');
  return query;
}

String getProductsByProductIdsQuery(List<int> productIds, int pageNumber) {
  String query = '/products_store'
      '?fields[]=id'
      '&fields[]=title'
      '&fields[]=image_src'
      '&fields[]=variants.price'
      '&fields[]=variants.compare_at_price'
      '&fields[]=variants.barcode'
      '&fields[]=tag_ids.tags_id'
      '&fields[]=tag_ids.tags_id.tag_name'
      '&fields[]=collection_ids.collection_id'
      '&fields[]=collection_ids.collection_id.collection_name'
      '&sort[]=id'
      '&limit=50'
      '&page=$pageNumber'
      '&filter={"id":{"_in":["${productIds.join('","')}"]}}';

  debugPrint('getProductsByProductIdsQuery: $query');
  return query;
}

String getProductsByCollectionIdQuery(int collectionId, int limit) {
  String query = '/products_store'
      '?fields[]=id'
      '&fields[]=title'
      '&fields[]=image_src'
      '&fields[]=variants.price'
      '&fields[]=variants.compare_at_price'
      '&fields[]=variants.barcode'
      '&fields[]=tag_ids.tags_id'
      '&fields[]=tag_ids.tags_id.tag_name'
      '&fields[]=collection_ids.collection_id'
      '&fields[]=collection_ids.collection_id.collection_name'
      '&sort[]=id'
      '&limit=$limit'
      '&filter={"collection_ids":{"collection_id":{"_eq":$collectionId}}}'
      '&filter={"tag_ids":{"tags_id":{"tag_name":{"_neq":"credit-cards"}}}}';

  debugPrint('getProductsByCollectionIdQuery: $query');
  return query;
}

String getProductSpecificDetailsQuery(int productId) {
  return '/products_store'
      '?filter={"id":{"_eq":$productId}}'
      '&fields[]=id'
      '&fields[]=title'
      '&fields[]=body_html'
      '&fields[]=image_src'
      '&fields[]=variants.price'
      '&fields[]=variants.barcode'
      '&fields[]=variants.compare_at_price'
      '&fields[]=tag_ids.tags_id'
      '&fields[]=tag_ids.tags_id.tag_name';
}

String getCreditCardsCollectionQuery(int pageNumber, int limit) {
  return '/items/products'
      '?fields[]=id'
      '&fields[]=title'
      '&fields[]=body_html'
      '&fields[]=image_src'
      '&fields[]=variants.barcode'
      '&fields[]=tag_ids.tags_id'
      '&fields[]=tag_ids.tags_id.tag_name'
      '&fields[]=collection_ids.collection_id'
      '&fields[]=collection_ids.collection_id.collection_name'
      '&sort[]=id'
      '&limit=$limit'
      '&page=$pageNumber'
      '&filter={"collection_ids":{"collection_id":{"collection_name":{"_eq":"Credit Cards"}}}}';
}

String getProductsByTagQuery(String tagName, int pageNumber) {
  return '/products_store'
      '?fields[]=id'
      '&fields[]=title'
      '&fields[]=image_src'
      '&fields[]=variants.price'
      '&fields[]=variants.compare_at_price'
      '&fields[]=variants.barcode'
      '&fields[]=tag_ids.tags_id'
      '&fields[]=tag_ids.tags_id.tag_name'
      '&fields[]=collection_ids.collection_id'
      '&fields[]=collection_ids.collection_id.collection_name'
      '&sort[]=id'
      '&limit=50'
      '&page=$pageNumber'
      '&filter={"tag_ids":{"tag_id":{"tag_name":{"_in":"$tagName"}}}}'
      '&filter={"collection_ids":{"collection_id":{"collection_name":{"_ncontains":"Credit Cards"}}}}';
}

String getCollections(String colType) {
  if (colType == 'foryou') {
    return '/items/collection'
        '?filter[collection_name][_nin]'
        '=PzBlog,Credit Cards,Featured,PzStyles,noprice,Unknown,Front Page';
  } else {
    return '/items/collection'
        '?filter[collection_name][_nin]'
        '=noprice,Unknown';
  }
}

String searchProductQuery(String keyword, int pageNumber) {
  String query = '/products_store'
      '?fields[]=id'
      '&fields[]=title'
      '&fields[]=image_src'
      '&fields[]=variants.price'
      '&fields[]=variants.compare_at_price'
      '&fields[]=variants.barcode'
      '&fields[]=tag_ids.tags_id'
      '&fields[]=tag_ids.tags_id.tag_name'
      '&fields[]=collection_ids.collection_id'
      '&fields[]=collection_ids.collection_id.collection_name'
      '&sort[]=id'
      '&limit=50'
      '&page=$pageNumber'
      '&filter={"title": { "_icontains": "$keyword" }}';
  return query;
}

String searchPercentageProductQuery(int pageNumber) {
  String query = '/products_store'
      '?fields[]=id'
      '&fields[]=title'
      '&fields[]=image_src'
      '&fields[]=variants.price'
      '&fields[]=variants.compare_at_price'
      '&fields[]=variants.barcode'
      '&fields[]=tag_ids.tags_id'
      '&fields[]=tag_ids.tags_id.tag_name'
      '&fields[]=collection_ids.collection_id'
      '&fields[]=collection_ids.collection_id.collection_name'
      '&sort[]=id'
      '&limit=50'
      '&page=$pageNumber'
      '&filter={"collection_ids":{"collection_id":{"collection_name":{"_nin":"Credit Cards,PzBlog,PzStyles,noprice,Unknown"}}}}';
  return query;
}
