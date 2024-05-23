import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pzdeals/src/constants/color_constants.dart';
import 'package:pzdeals/src/utils/storage/network_image_cache_manager.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProductImageWidget extends StatelessWidget {
  const ProductImageWidget({
    super.key,
    required this.imageAsset,
    required this.sourceType,
    this.size = 'medium',
    this.isExpired = false,
    this.fit = BoxFit.fitWidth,
  });

  final String imageAsset;
  final String sourceType;
  final String size;
  final bool isExpired;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    double width;
    double? height;

    //get container width;
    final containerWidth = MediaQuery.of(context).size.width;

    // Set width and height based on the provided size parameter or use default values
    switch (size) {
      case 'small':
        width = 40.0;
        height = 40.0;
        break;
      case 'medium':
        width = 80.0;
        height = 80.0;
        break;
      case 'large':
        width = 140.0;
        height = 140.0;
        break;
      case 'xlarge':
        width = containerWidth / 2;
        height = containerWidth / 2;
        break;
      case 'container':
        width = containerWidth / 1.75;
        height = containerWidth / 1.75;
        break;
      case 'fullscreen':
        width = containerWidth;
        height = containerWidth;
      default:
        // Set default size if the provided size is not recognized
        width = 80.0;
        height = 80.0;
        break;
    }

    ImageProvider imageProvider;

    if (sourceType == 'asset') {
      imageProvider = AssetImage(imageAsset);
    } else if (sourceType == 'network') {
      imageProvider = NetworkImage(imageAsset);
    } else {
      imageProvider = const AssetImage('assets/pzdeals.png');
    }

    Widget imageWidget = Image(
      image: imageProvider,
      width: width,
      height: height,
      fit: fit,
    );

    // Apply opaque effect if expired
    // if (isExpired) {
    //   imageWidget = ColorFiltered(
    //     colorFilter: ColorFilter.mode(
    //       Colors.white.withOpacity(0.5), // Adjust opacity as needed
    //       BlendMode.srcOver,
    //     ),
    //     child: imageWidget,
    //   );
    // }

    // Apply loading and error builders for network images
    if (sourceType == 'network') {
      try {
        imageWidget = CachedNetworkImage(
          imageUrl: imageAsset,
          width: width,
          cacheManager: networkImageCacheManager,
          fadeInDuration: const Duration(milliseconds: 1),
          fit: fit,
          placeholder: (context, url) => Skeletonizer(
              effect: PulseEffect(
                  from: Colors.white,
                  to: Colors.grey[200]!,
                  duration: const Duration(milliseconds: 1000)),
              child: Image.asset(
                'assets/images/placeholder_white.png',
                width: width,
                // height: height,
                fit: BoxFit.fitWidth,
              )),
          errorWidget: (context, url, error) {
            debugPrint('Error loading image: $error');
            return Image.asset(
              'assets/images/pzdeals.png',
              width: width,
              // height: height,
              fit: BoxFit.fitWidth,
            );
          },
        );
      } catch (e) {
        debugPrint('Error loading image: $e');
        imageWidget = Image.asset(
          'assets/images/pzdeals.png',
          width: width,
          height: height,
          fit: BoxFit.fitWidth,
        );
      }
    }

    if (isExpired) {
      return imageWidget = ColorFiltered(
        colorFilter: ColorFilter.mode(
          Colors.white.withOpacity(0.65), // Adjust opacity as needed
          BlendMode.srcOver,
        ),
        child: imageWidget,
      );
    } else {
      return imageWidget;
    }
  }
}
