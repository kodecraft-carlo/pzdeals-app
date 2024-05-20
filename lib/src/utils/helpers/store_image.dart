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
