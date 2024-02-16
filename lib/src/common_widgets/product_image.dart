import 'package:flutter/material.dart';
import 'package:pzdeals/src/constants/color_constants.dart';

class ProductImageWidget extends StatelessWidget {
  const ProductImageWidget({
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
      return Image(
        image: imageProvider,
        width: width,
        height: height,
        fit: BoxFit.fitWidth,
      );
    } else if (sourceType == 'network') {
      imageProvider = NetworkImage(imageAsset);
      return Image.network(
        imageAsset,
        width: width,
        height: height,
        fit: BoxFit.fitWidth,
        loadingBuilder: (BuildContext context, Widget child,
            ImageChunkEvent? loadingProgress) {
          if (loadingProgress == null) {
            return child;
          } else {
            return Align(
              alignment: Alignment.center,
              child: CircularProgressIndicator.adaptive(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        (loadingProgress.expectedTotalBytes ?? 1)
                    : null,
                valueColor:
                    const AlwaysStoppedAnimation<Color>(PZColors.pzOrange),
                backgroundColor: PZColors.pzLightGrey,
                strokeWidth: 3,
              ),
            );
          }
        },
      );
    } else {
      imageProvider = const AssetImage('assets/pzdeals.png');
      return Image(
        image: imageProvider,
        width: width,
        height: height,
        fit: BoxFit.fitWidth,
      );
    }
  }
}
