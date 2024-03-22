String getStoreImageUrlFromTags(List<dynamic> tagIds) {
  final Map<String, String> storeImageUrls = {
    'woot': 'assets/images/stores/woot.png',
    'amazon': 'assets/images/stores/amazon.png',
    'ebay': 'assets/images/stores/ebay.png',
    'bestbuy': 'assets/images/stores/bestbuy.png',
    'walmart': 'assets/images/stores/walmart.png',
    'newegg': 'assets/images/stores/newegg.png',
  };

  for (var tag in tagIds) {
    final tagName = tag['tags_id']['tag_name'].toLowerCase();
    if (storeImageUrls.containsKey(tagName)) {
      return storeImageUrls[tagName] ?? 'assets/images/pzdeals_store.png';
    }
  }
  return 'assets/images/pzdeals_store.png';
}
