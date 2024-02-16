import 'package:flutter/material.dart';
import 'package:pzdeals/src/common_widgets/badge.dart';
import 'package:pzdeals/src/common_widgets/product_image.dart';
import 'package:pzdeals/src/common_widgets/store_image.dart';
import 'package:pzdeals/src/constants/color_constants.dart';
import 'package:pzdeals/src/constants/sizes.dart';

class ProductDealDescription extends StatelessWidget {
  const ProductDealDescription(
      {super.key,
      required this.productName,
      required this.price,
      required this.storeAssetImage,
      required this.oldPrice,
      required this.imageAsset,
      required this.discountPercentage,
      required this.assetSourceType,
      required this.dealDescription});

  final String productName;
  final String price;
  final String storeAssetImage;
  final String oldPrice;
  final String imageAsset;
  final String discountPercentage;
  final String assetSourceType;
  final String dealDescription;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ProductImageWidget(
          imageAsset: imageAsset,
          sourceType: assetSourceType,
          size: 'large',
        ),
        StoreImageWidget(
          storeAssetImage: storeAssetImage,
        ),
        Text(
          productName,
          style: const TextStyle(
              fontSize: Sizes.fontSizeMedium, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: Sizes.spaceBetweenContent),
        const SizedBox(height: Sizes.spaceBetweenSections),
        BadgeWidget(discountPercentage: int.parse(discountPercentage)),
        const SizedBox(height: Sizes.spaceBetweenContent),
        RichText(
          text: TextSpan(
            children: [
              // Current Price
              TextSpan(
                text: '\$$price',
                style: const TextStyle(
                  fontSize: Sizes.fontSizeXXLarge,
                  color: PZColors.pzGreen,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w800,
                ),
              ),

              // Add some space between prices
              const TextSpan(
                text: '  ',
              ),

              // Old Price with Strikethrough
              TextSpan(
                text: '\$$oldPrice', // Replace with your old price
                style: const TextStyle(
                  fontSize: Sizes.fontSizeMedium,
                  color: Colors.red,
                  decoration: TextDecoration.lineThrough,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: Sizes.spaceBetweenSections),
        Text(
          dealDescription,
          style: const TextStyle(
            color: PZColors.pzBlack,
            fontWeight: FontWeight.w500,
            fontSize: Sizes.bodyFontSize,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: Sizes.spaceBetweenSections),
        Container(
          color: Colors.white,
          margin: const EdgeInsets.all(Sizes.marginAll),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.thumb_up_outlined),
                    iconSize: Sizes.screenCloseIconSize,
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('You liked this deal!'),
                          action: SnackBarAction(
                            label: 'Dismiss',
                            onPressed: () {
                              // Code to execute.
                            },
                          ),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.thumb_down_outlined),
                    iconSize: Sizes.screenCloseIconSize,
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('You dislike this deal!'),
                          action: SnackBarAction(
                            label: 'Dismiss',
                            onPressed: () {
                              // Code to execute.
                            },
                          ),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.sell_outlined),
                    iconSize: Sizes.screenCloseIconSize,
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Sold out!'),
                          action: SnackBarAction(
                            label: 'Dismiss',
                            onPressed: () {
                              // Code to execute.
                            },
                          ),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.bookmark_border_outlined),
                    iconSize: Sizes.screenCloseIconSize,
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Deal saved!'),
                          action: SnackBarAction(
                            label: 'Dismiss',
                            onPressed: () {
                              // Code to execute.
                            },
                          ),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: Sizes.spaceBetweenContent),
              ButtonBarTheme(
                data: const ButtonBarThemeData(
                    alignment: MainAxisAlignment.center),
                child: Row(
                  children: [
                    Expanded(
                        child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(Sizes
                                .buttonBorderRadius), // Adjust the radius as needed
                          ),
                          backgroundColor: PZColors.pzGreen,
                          minimumSize: const Size(150, 40),
                          elevation: Sizes.buttonElevation),
                      onPressed: () {
                        // Handle button action
                        debugPrint('See Deal presssed');
                      },
                      child: const Text(
                        'See Deal',
                        style: TextStyle(color: PZColors.pzWhite),
                      ),
                    )),
                  ],
                ),
              ),
              const SizedBox(height: Sizes.spaceBetweenContent),
              const Text(
                'We may earn commission from affiliate links. We appreciate your support!',
                style: TextStyle(
                    fontSize: Sizes.fontSizeXSmall,
                    fontStyle: FontStyle.italic),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        )
      ],
    );
  }
}
