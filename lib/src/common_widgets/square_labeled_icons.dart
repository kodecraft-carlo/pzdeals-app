import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pzdeals/src/constants/index.dart';
import 'package:pzdeals/src/utils/storage/network_image_cache_manager.dart';

class SquareLabeledIcon extends StatelessWidget {
  final String iconTitle;
  final String iconImage;
  final String iconAssetType;
  final Color borderColor;
  const SquareLabeledIcon(
      {super.key,
      required this.iconTitle,
      required this.iconImage,
      required this.iconAssetType,
      this.borderColor = PZColors.pzLightGrey});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: Container(
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(Sizes.cardBorderRadius),
              border: Border.all(color: borderColor),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 3,
                  blurRadius: 9,
                ),
              ],
            ),
            child: storeIcon(),
          ),
        ),
        const SizedBox(height: Sizes.spaceBetweenContentSmall),
        Text(
          iconTitle,
          style: const TextStyle(
              color: PZColors.pzBlack,
              fontSize: Sizes.fontSizeSmall,
              fontWeight: FontWeight.w500),
          textScaler: MediaQuery.textScalerOf(context),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        )
      ],
    );
  }

  Widget storeIcon() {
    ImageProvider imageProvider;
    double width = 80;
    double height = 80;

    if (iconAssetType == 'asset') {
      imageProvider = AssetImage(iconImage);
    } else if (iconAssetType == 'network') {
      imageProvider = NetworkImage(iconImage);
    } else {
      imageProvider = const AssetImage('assets/pzdeals.png');
    }

    Widget imageWidget = Image(
      image: imageProvider,
      width: width,
      height: height,
      fit: BoxFit.cover,
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
    if (iconAssetType == 'network') {
      imageWidget = CachedNetworkImage(
        imageUrl: iconImage,
        width: width,
        cacheManager: networkImageCacheManager,
        fadeInDuration: const Duration(milliseconds: 10),
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
          return Image.asset(
            'assets/images/pzdeals.png',
            width: width,
            height: height,
            fit: BoxFit.cover,
          );
        },
      );
    }
    return imageWidget;
  }
}
