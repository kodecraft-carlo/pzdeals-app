import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pzdeals/src/constants/index.dart';
import 'package:pzdeals/src/utils/storage/network_image_cache_manager.dart';

class PopularKeywordsCard extends StatelessWidget {
  final String imagePath;
  final String text;
  final VoidCallback? onPressed;

  const PopularKeywordsCard({
    super.key,
    required this.imagePath,
    required this.text,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      padding: const EdgeInsets.all(Sizes.paddingAllSmall / 3),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Sizes.cardBorderRadius),
        border: Border.all(
          color: PZColors.pzLightGrey,
          width: 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: onPressed,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(
                  Icons.add_circle,
                  color: PZColors.pzOrange,
                ),
              ],
            ),
          ),
          Expanded(
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(Sizes.cardBorderRadius),
                  child: CachedNetworkImage(
                    imageUrl: imagePath,
                    cacheManager: networkImageCacheManager,
                    fadeInDuration: const Duration(milliseconds: 10),
                    fit: BoxFit.contain,
                    errorWidget: (context, url, error) {
                      debugPrint('Error loading image: $error');
                      return Image.asset(
                        'assets/images/pzdeals.png',
                        fit: BoxFit.fitWidth,
                      );
                    },
                  )
                  // Image.network(
                  //         imagePath,
                  //         fit: BoxFit.contain,
                  //         loadingBuilder: (BuildContext context, Widget child,
                  //             ImageChunkEvent? loadingProgress) {
                  //           if (loadingProgress == null) {
                  //             return child;
                  //           } else {
                  //             return const SizedBox.square(
                  //               child: Padding(
                  //                 padding: EdgeInsets.all(Sizes.paddingAll),
                  //                 child: AspectRatio(
                  //                   aspectRatio: 1,
                  //                   child: CircularProgressIndicator.adaptive(
                  //                     valueColor:
                  //                         AlwaysStoppedAnimation<Color>(PZColors.pzOrange),
                  //                     backgroundColor: PZColors.pzLightGrey,
                  //                     strokeWidth: 3,
                  //                   ),
                  //                 ),
                  //               ),
                  //             );
                  //           }
                  //         },
                  //       ),
                  )),
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: Sizes.paddingAllSmall),
            child: Text(
              text,
              style: const TextStyle(
                  color: PZColors.pzBlack,
                  fontWeight: FontWeight.w500,
                  fontSize: Sizes.bodyFontSize),
            ),
          )
        ],
      ),
    );
  }
}
