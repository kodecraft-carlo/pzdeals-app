import 'package:cached_network_image/cached_network_image.dart';
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
    } else if (sourceType == 'network') {
      imageProvider = NetworkImage(imageAsset);
    } else {
      imageProvider = const AssetImage('assets/pzdeals.png');
    }

    Widget imageWidget = Image(
      image: imageProvider,
      width: 100.0,
      height: 80.0,
      fit: BoxFit.fitWidth,
    );

    // Apply loading and error builders for network images
    if (sourceType == 'network') {
      imageWidget = CachedNetworkImage(
        imageUrl: imageAsset,
        width: 100.0,
        height: 80.0,
        fit: BoxFit.fitWidth,
        placeholder: (context, url) => const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(PZColors.pzGrey),
            backgroundColor: PZColors.pzLightGrey,
            strokeWidth: 3,
          ),
        ),
        errorWidget: (context, url, error) {
          debugPrint('Error loading image: $error');
          return Image.asset(
            'assets/images/pzdeals.png',
            width: 100.0,
            height: 80.0,
            fit: BoxFit.fitWidth,
          );
        },
      );
    }

    return imageWidget;
  }
}
