String getStoreCollectionQuery(int pageNumber) {
  String query = '/items/stores'
      '?fields[]=id'
      '&fields[]=title'
      '&fields[]=image_src'
      '&fields[]=body'
      '&fields[]=tags.tags_id.tag_name'
      '&fields[]=handle'
      '&sort[]=title'
      '&limit=100'
      '&page=$pageNumber';
  return query;
}

String getStoreSpecificDetailsQuery(int storeId) {
  String query = '/items/stores'
      '?filter[id][_eq]=$storeId'
      '&fields[]=id'
      '&fields[]=title'
      '&fields[]=body'
      '&fields[]=image_src'
      '&fields[]=tags.tags_id.tag_name'
      '&fields[]=handle';
  return query;
}
