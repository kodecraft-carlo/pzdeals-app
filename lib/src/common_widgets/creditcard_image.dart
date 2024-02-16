import 'package:flutter/material.dart';
import 'package:pzdeals/src/constants/color_constants.dart';

class CreditCardImageWidget extends StatelessWidget {
  const CreditCardImageWidget({
    super.key,
    required this.imageAsset,
    required this.sourceType,
  });

  final String imageAsset;
  final String sourceType;

  @override
  Widget build(BuildContext context) {
    ImageProvider imageProvider;

    if (sourceType == 'asset') {
      imageProvider = AssetImage(imageAsset);
      return Image(
        image: imageProvider,
        width: 100.0,
        height: 80.0,
        fit: BoxFit.fitWidth,
      );
    } else if (sourceType == 'network') {
      imageProvider = NetworkImage(imageAsset);
      return Image.network(
        imageAsset,
        width: 100.0,
        height: 80.0,
        fit: BoxFit.fitWidth,
        loadingBuilder: (BuildContext context, Widget child,
            ImageChunkEvent? loadingProgress) {
          if (loadingProgress == null) {
            // If there's no progress, return the child (loaded image)
            return child;
          } else {
            // If the image is still loading, return a loading indicator
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        (loadingProgress.expectedTotalBytes ?? 1)
                    : null,
                valueColor:
                    const AlwaysStoppedAnimation<Color>(PZColors.pzOrange),
              ),
            );
          }
        },
      );
    } else {
      // Handle other source types or provide a default image
      imageProvider = const AssetImage('assets/pzdeals.png');
      return Image(
        image: imageProvider,
        width: 100.0,
        height: 80.0,
        fit: BoxFit.fitHeight,
      );
    }
  }
}
