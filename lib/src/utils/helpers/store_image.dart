import 'package:pzdeals/config.dart';

String getStoreImageUrlFromTags(List<dynamic> tagIds) {
  for (var tag in tagIds) {
    if (tag == null || tag['tags_id'] == null) {
      continue;
    }
    final storeImage = tag['tags_id']['image'];
    if (storeImage != null) {
      return '${AppConfig.directusAssetsUrl}$storeImage';
    }
  }
  return 'assets/images/pzdeals_store.png';
}

String getStoreIconsUrl(String assetId, String imageUrl) {
  if (assetId.isEmpty) {
    if (imageUrl.isNotEmpty) {
      return imageUrl;
    }
    return 'assets/images/pzdeals_store.png';
  }
  return '${AppConfig.directusAssetsUrl}$assetId';
}
