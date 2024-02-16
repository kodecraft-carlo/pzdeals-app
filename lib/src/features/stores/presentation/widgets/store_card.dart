import 'package:flutter/material.dart';
import 'package:pzdeals/src/constants/index.dart';
import 'package:pzdeals/src/features/stores/models/store_data.dart';

class StoreCardWidget extends StatelessWidget {
  final StoreData storeDetails;
  const StoreCardWidget({super.key, required this.storeDetails});

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
          storeDetails.storeName,
          style: const TextStyle(
              color: PZColors.pzBlack,
              fontSize: Sizes.fontSizeSmall,
              fontWeight: FontWeight.w500),
          textScaler: MediaQuery.textScalerOf(context),
        )
      ],
    );
  }

  Widget storeIcon() {
    ImageProvider imageProvider;

    if (storeDetails.assetSourceType == 'asset') {
      imageProvider = AssetImage(storeDetails.storeAssetImage);
      return Image(
        image: imageProvider,
        width: 80,
        height: 80,
        fit: BoxFit.cover,
      );
    } else if (storeDetails.assetSourceType == 'network') {
      imageProvider = NetworkImage(storeDetails.storeAssetImage);
      return Image.network(
        storeDetails.storeAssetImage,
        width: 80,
        height: 80,
        fit: BoxFit.cover,
        loadingBuilder: (BuildContext context, Widget child,
            ImageChunkEvent? loadingProgress) {
          if (loadingProgress == null) {
            return child;
          } else {
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
