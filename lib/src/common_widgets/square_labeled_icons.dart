import 'package:flutter/material.dart';
import 'package:pzdeals/src/constants/index.dart';

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

    if (iconAssetType == 'asset') {
      imageProvider = AssetImage(iconImage);
      return Image(
        image: imageProvider,
        width: 80,
        height: 80,
        fit: BoxFit.cover,
      );
    } else if (iconAssetType == 'network') {
      imageProvider = NetworkImage(iconImage);
      return Image.network(
        iconImage,
        width: 80,
        height: 80,
        fit: BoxFit.cover,
        loadingBuilder: (BuildContext context, Widget child,
            ImageChunkEvent? loadingProgress) {
          if (loadingProgress == null) {
            return child;
          } else {
            return Center(
              child: CircularProgressIndicator.adaptive(
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
      imageProvider = const AssetImage('assets/pzdeals.png');
      return Image(
        image: imageProvider,
        width: 100,
        height: 100,
        fit: BoxFit.cover,
      );
    }
  }
}
