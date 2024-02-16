import 'package:flutter/material.dart';
import 'package:pzdeals/src/constants/index.dart';

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
            child: Image.network(
              imagePath,
              fit: BoxFit.contain,
              loadingBuilder: (BuildContext context, Widget child,
                  ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                } else {
                  return SizedBox.square(
                    child: Padding(
                      padding: const EdgeInsets.all(Sizes.paddingAll),
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: CircularProgressIndicator.adaptive(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  (loadingProgress.expectedTotalBytes ?? 1)
                              : null,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                              PZColors.pzOrange),
                          backgroundColor: PZColors.pzLightGrey,
                          strokeWidth: 3,
                        ),
                      ),
                    ),
                  );
                }
              },
            ),
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
