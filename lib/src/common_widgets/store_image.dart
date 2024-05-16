import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pzdeals/src/utils/storage/network_image_cache_manager.dart';

class StoreImageWidget extends ConsumerWidget {
  const StoreImageWidget(
      {super.key,
      required this.storeAssetImage,
      this.imageWidth = 27,
      this.imageHeight = 25,
      this.hasLayoutType = true});

  final String storeAssetImage;
  final int imageWidth;
  final double imageHeight;
  final bool hasLayoutType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return storeAssetImage == 'assets/images/pzdeals_store.png'
        ? Image.asset(
            'assets/images/pzdeals.png',
            width: 18,
            height: 18,
            fit: BoxFit.fitWidth,
          )
        : CachedNetworkImage(
            imageUrl: storeAssetImage,
            height: imageHeight,
            cacheManager: networkImageCacheManager,
            fit: BoxFit.fitHeight,
            errorWidget: (context, url, error) {
              debugPrint('Error loading image: $error');
              return Image.asset(
                'assets/images/pzdeals.png',
                width: 18,
                height: 18,
                fit: BoxFit.fitHeight,
              );
            },
          );
  }
}
