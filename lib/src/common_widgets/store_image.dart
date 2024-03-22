import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pzdeals/src/state/layout_type_provider.dart';

class StoreImageWidget extends ConsumerWidget {
  const StoreImageWidget(
      {super.key,
      required this.storeAssetImage,
      this.imageWidth = 27,
      this.hasLayoutType = true});

  final String storeAssetImage;
  final int imageWidth;
  final bool hasLayoutType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final layoutType = ref.watch(layoutTypeProvider);
    return Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          // border: Border.all(
          //   color: Colors.grey[300]!,
          //   width: 1,
          // ),
        ),
        // Adjust the width as needed
        width: hasLayoutType == true
            ? layoutType == 'List'
                ? 40
                : 32
            : imageWidth.toDouble(),
        child: AspectRatio(
          aspectRatio: 1 / .5,
          child: storeAssetImage == 'assets/images/pzdeals_store.png'
              ? Image.asset(
                  'assets/images/pzdeals.png',
                  width: 18,
                  height: 18,
                  fit: BoxFit.fitHeight,
                )
              : CachedNetworkImage(
                  imageUrl: storeAssetImage,
                  fit: BoxFit.fitWidth,
                  errorWidget: (context, url, error) {
                    debugPrint('Error loading image: $error');
                    return Image.asset(
                      'assets/images/pzdeals.png',
                      width: 18,
                      height: 18,
                      fit: BoxFit.fitHeight,
                    );
                  },
                ),
        ));
  }
}
