import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pzdeals/src/actions/show_dialog.dart';
import 'package:pzdeals/src/common_widgets/badge.dart';
import 'package:pzdeals/src/common_widgets/dialog.dart';
import 'package:pzdeals/src/common_widgets/product_image.dart';
import 'package:pzdeals/src/common_widgets/store_image.dart';
import 'package:pzdeals/src/constants/color_constants.dart';
import 'package:pzdeals/src/constants/sizes.dart';
import 'package:pzdeals/src/features/deals/presentation/widgets/index.dart';
import 'package:pzdeals/src/state/layout_type_provider.dart';

class ProductDealcard extends ConsumerWidget {
  const ProductDealcard(
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
  Widget build(BuildContext context, WidgetRef ref) {
    final layoutType = ref.watch(layoutTypeProvider);
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
              'This is a great deal for you! This is a great deal for you! This is a great deal for you! This is a great deal for you! This is a great deal for you! This is a great deal for you! This is a great deal for you! This is a great deal for you! This is a great deal for you! This is a great deal for you! This is a great deal for you! This is a great deal for you! This is a great deal for you! This is a great deal for you! This is a great deal for you! This is a great deal for you! This is a great deal for you! This is a great deal for you! This is a great deal for you! This is a great deal for you! This is a great deal for you! This is a great deal for you! This is a great deal for you! This is a great deal for you! This is a great deal for you! This is a great deal for you! This is a great deal for you! This is a great deal for you! This is a great deal for you! This is a great deal for you! This is a great deal for you! This is a great deal for you! This is a great deal for you! This is a great deal for you! This is a great deal for you! This is a great deal for you!',
        )),
        childWidget: layoutType == 'Grid'
            ? gridProductCard(productName, price, imageAsset,
                discountPercentage, oldPrice, storeAssetImage, assetSourceType)
            : listProductCard(
                productName,
                price,
                imageAsset,
                discountPercentage,
                oldPrice,
                storeAssetImage,
                assetSourceType));
  }

  Widget gridProductCard(
      String productName,
      String price,
      String imageAsset,
      int discountPercentage,
      String oldPrice,
      String storeAssetImage,
      String assetSourceType) {
    return Card(
        margin: const EdgeInsets.only(
          top: Sizes.marginTopSmall,
          bottom: Sizes.marginBottomSmall,
        ),
        elevation: 0,
        color: PZColors.pzWhite,
        surfaceTintColor: PZColors.pzWhite,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: PZColors.pzLightGrey, width: 1.0),
          borderRadius: BorderRadius.circular(
              Sizes.cardBorderRadius), // You can adjust the radius as needed
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
                  height:
                      Sizes.spaceBetweenContent), // Add some spacing between
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
                  height:
                      Sizes.spaceBetweenContent), // Add some spacing between
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  StoreImageWidget(storeAssetImage: storeAssetImage),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Discount Badge
                      BadgeWidget(discountPercentage: discountPercentage),
                      const SizedBox(height: Sizes.spaceBetweenContentSmall),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: RichText(
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                          text: TextSpan(
                            children: [
                              // Current Price
                              TextSpan(
                                text: '\$$price',
                                style: const TextStyle(
                                    fontSize: Sizes.fontSizeLarge,
                                    color: PZColors.pzGreen,
                                    fontFamily: 'Poppins',
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
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ));
  }

  Widget listProductCard(
      String productName,
      String price,
      String imageAsset,
      int discountPercentage,
      String oldPrice,
      String storeAssetImage,
      String assetSourceType) {
    return Card(
        margin: const EdgeInsets.only(
          top: Sizes.marginTopSmall,
          bottom: Sizes.marginBottomSmall,
        ),
        color: PZColors.pzWhite,
        elevation: 0,
        surfaceTintColor: PZColors.pzWhite,
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: PZColors.pzLightGrey, width: 1.0),
          borderRadius: BorderRadius.circular(
              Sizes.cardBorderRadius), // You can adjust the radius as needed
        ),
        child: Padding(
          padding: const EdgeInsets.all(Sizes.paddingAllSmall),
          child: Row(
            children: [
              // Left side: Product Image Preview
              ProductImageWidget(
                imageAsset: imageAsset,
                sourceType: assetSourceType,
                size: 'medium',
              ),
              // Right side: Product Name, Discount Badge, and Price
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: Sizes.paddingLeftSmall),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Product Name
                      Text(
                        productName,
                        style: const TextStyle(
                          fontSize: Sizes.bodyFontSize,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: Sizes.spaceBetweenSectionsXL),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Align(
                            alignment: Alignment.bottomLeft,
                            child:
                                // Left side: Additional Image
                                Padding(
                              padding: const EdgeInsets.all(0),
                              child: StoreImageWidget(
                                  storeAssetImage: storeAssetImage),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                // Discount Badge
                                BadgeWidget(
                                    discountPercentage: discountPercentage),

                                // Product Price
                                FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: RichText(
                                      text: TextSpan(
                                        children: [
                                          // Current Price
                                          TextSpan(
                                            text: '\$$price',
                                            style: const TextStyle(
                                                fontSize: Sizes.fontSizeLarge,
                                                color: PZColors.pzGreen,
                                                fontFamily: 'Poppins',
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
                                                decoration:
                                                    TextDecoration.lineThrough,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ],
                                      ),
                                    )),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
