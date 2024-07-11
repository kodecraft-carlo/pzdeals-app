import 'package:flutter/material.dart';

String getBlogsByCollectionNameQuery(int pageNumber) {
  String query = '/items/products'
      '?fields[]=id'
      '&fields[]=title'
      '&fields[]=image_src'
      '&fields[]=published'
      '&fields[]=status'
      '&filter[collection_ids][collection_id][keywords][_eq]=pz_blog'
      '&limit[]=15'
      '&page[]=$pageNumber'
      '&sort=-created_at,-id'
      '&filter[title][_nempty]='
      '&filter[published][_eq]=true';

  debugPrint('getBlogsByCollectionNameQuery: $query');
  return query;
}

String getBlogByIdQuery(int blogId) {
  String query = '/items/products'
      '?fields[]=id'
      '&fields[]=title'
      '&fields[]=image_src'
      '&fields[]=published'
      '&fields[]=body_html'
      '&fields[]=status'
      '&fields[]=local_image'
      '&fields[]=local_image'
      '&filter[id][_eq]=$blogId'
      '&filter[collection_ids][collection_id][keywords][_eq]=pz_blog';

  debugPrint('getBlogByIdQuery: $query');
  return query;
}
