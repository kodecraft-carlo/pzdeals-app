import 'package:flutter/material.dart';

String getStoreCollectionQuery(int pageNumber) {
  String query = '/items/stores'
      '?fields[]=id'
      '&fields[]=title'
      '&fields[]=image_src'
      '&fields[]=app_store_img'
      '&fields[]=body'
      '&fields[]=tags.tags_id.tag_name'
      '&fields[]=handle'
      '&fields[]=store_img'
      '&fields[]=local_app_store_img'
      '&sort[]=title'
      '&limit=200'
      '&page=$pageNumber';
  debugPrint('getStoreCollectionQuery: $query');
  return query;
}

String getStoreSpecificDetailsQuery(int storeId) {
  String query = '/items/stores'
      '?filter[id][_eq]=$storeId'
      '&fields[]=id'
      '&fields[]=title'
      '&fields[]=body'
      '&fields[]=image_src'
      '&fields[]=app_store_img'
      '&fields[]=tags.tags_id.tag_name'
      '&fields[]=handle';
  return query;
}
