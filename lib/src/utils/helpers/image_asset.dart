import 'package:pzdeals/config.dart';

String getStoreImageUrlFromTags(List<dynamic> tagIds) {
  for (var tag in tagIds) {
    if (tag == null || tag['tags_id'] == null) {
      continue;
    }
    final storeImage = tag['tags_id']['image'];
    if (tag['tags_id']['tag_name'] == 'ac') {
      return '${AppConfig.directusAssetsUrl}53ec2659-d1a7-4b64-807e-634089893364';
    }
    if (storeImage != null) {
      return '${AppConfig.directusAssetsUrl}$storeImage';
    }
  }
  return 'assets/images/pzdeals_store.png';
}

String getProductImage(String imageSrc) {
  return '${AppConfig.directusAssetsUrl}$imageSrc';
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

String getCollectionImage(String localImage, String imageUrl) {
  if (localImage.isEmpty) {
    if (imageUrl.isNotEmpty) {
      return imageUrl;
    }
    return 'assets/images/pzdeals_store.png';
  }
  return '${AppConfig.directusAssetsUrl}$localImage';
}
