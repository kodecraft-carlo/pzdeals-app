import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:pzdeals/src/actions/show_dialog.dart';
import 'package:pzdeals/src/common_widgets/badge.dart';
import 'package:pzdeals/src/common_widgets/dialog.dart';
import 'package:pzdeals/src/common_widgets/product_image.dart';
import 'package:pzdeals/src/common_widgets/store_image.dart';
import 'package:pzdeals/src/constants/color_constants.dart';
import 'package:pzdeals/src/constants/sizes.dart';
import 'package:pzdeals/src/features/deals/presentation/widgets/index.dart';

class StaticProductDealCardWidget extends StatelessWidget {
  const StaticProductDealCardWidget(
      {super.key,
      required this.productName,
      required this.price,
      required this.imageAsset,
      required this.discountPercentage,
      required this.storeAssetImage,
      required this.oldPrice,
      required this.assetSourceType});

  final String productName;
  final String price;
  final String imageAsset;
  final int discountPercentage;
  final String oldPrice;
  final String storeAssetImage;
  final String assetSourceType;

  @override
  Widget build(BuildContext context) {
    return ShowDialogWidget(
        content: ContentDialog(
            content: ProductDealDescription(
          productName: productName,
          price: price,
          storeAssetImage: storeAssetImage,
          oldPrice: oldPrice,
          imageAsset: imageAsset,
          discountPercentage: discountPercentage.toString(),
          assetSourceType: assetSourceType,
          dealDescription:
              'This is a gsreat deal! This is a great deal! This is a great deal! This is a great deal! This is a great deal! This is a great deal!',
        )),
        childWidget: Card(
            margin: const EdgeInsets.only(
              top: Sizes.marginTopSmall,
              bottom: Sizes.marginBottomSmall,
            ),
            color: PZColors.pzWhite,
            surfaceTintColor: PZColors.pzWhite,
            elevation: 0,
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: PZColors.pzLightGrey, width: 1.0),
              borderRadius: BorderRadius.circular(Sizes
                  .cardBorderRadius), // You can adjust the radius as needed
            ),
            child: Padding(
              padding: const EdgeInsets.all(Sizes.paddingAllSmall),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: ProductImageWidget(
                      imageAsset: imageAsset,
                      sourceType: assetSourceType,
                      size: 'large',
                    ),
                  ),
                  const SizedBox(
                      height: Sizes
                          .spaceBetweenContent), // Add some spacing between
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      productName,
                      style: const TextStyle(
                        fontSize: Sizes.bodyFontSize,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.start,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(
                      height: Sizes
                          .spaceBetweenContent), // Add some spacing between
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      StoreImageWidget(storeAssetImage: storeAssetImage),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          BadgeWidget(discountPercentage: discountPercentage),
                          const SizedBox(
                              height: Sizes.spaceBetweenContentSmall),
                          RichText(
                            text: TextSpan(
                              children: [
                                // Current Price
                                TextSpan(
                                  text: '\$$price',
                                  style: const TextStyle(
                                      fontSize: Sizes.listTitleFontSize,
                                      color: PZColors.pzGreen,
                                      fontWeight: FontWeight.bold),
                                ),

                                // Add some space between prices
                                const TextSpan(
                                  text: '  ',
                                ),

                                // Old Price with Strikethrough
                                TextSpan(
                                  text:
                                      '\$$oldPrice', // Replace with your old price
                                  style: const TextStyle(
                                      fontSize: Sizes.bodyFontSize,
                                      color: Colors.red,
                                      decoration: TextDecoration.lineThrough,
                                      fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            )));
  }
}
