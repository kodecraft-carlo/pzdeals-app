import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pzdeals/src/constants/color_constants.dart';
import 'package:pzdeals/src/constants/sizes.dart';

class CategoryImageWidget extends StatelessWidget {
  const CategoryImageWidget({
    super.key,
    required this.imageAsset,
    required this.sourceType,
    this.size = 'medium', // Make size parameter optional with a default value
  });

  final String imageAsset;
  final String sourceType;
  final String size;

  @override
  Widget build(BuildContext context) {
    double width;
    double height;

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
        width = 180.0;
        height = 180.0;
        break;
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
      fit: BoxFit.cover,
    );

    // Apply loading and error builders for network images
    if (sourceType == 'network') {
      imageWidget = CachedNetworkImage(
        imageUrl: imageAsset,
        width: width,
        height: height,
        fit: BoxFit.cover,
        // placeholder: (context, url) => const Center(
        //   child: CircularProgressIndicator(
        //     valueColor: AlwaysStoppedAnimation<Color>(PZColors.pzGrey),
        //     backgroundColor: PZColors.pzLightGrey,
        //     strokeWidth: 3,
        //   ),
        // ),
        errorWidget: (context, url, error) {
          debugPrint('Error loading image: $error');
          return ClipRRect(
            borderRadius: BorderRadius.circular(Sizes.containerBorderRadius),
            child: Image.asset(
              'assets/images/pzdeals.png',
              width: width,
              height: height,
              fit: BoxFit.cover,
            ),
          );
        },
      );
    }
    return imageWidget;
  }
}
