import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:googleapis/androidenterprise/v1.dart';
import 'package:pzdeals/src/common_widgets/badge.dart';
import 'package:pzdeals/src/common_widgets/product_dialog.dart';
import 'package:pzdeals/src/common_widgets/product_image.dart';
import 'package:pzdeals/src/common_widgets/store_image.dart';
import 'package:pzdeals/src/constants/color_constants.dart';
import 'package:pzdeals/src/constants/sizes.dart';
import 'package:pzdeals/src/features/deals/models/index.dart';
import 'package:pzdeals/src/features/deals/presentation/widgets/index.dart';
import 'package:pzdeals/src/state/layout_type_provider.dart';

class ProductDealcard extends ConsumerStatefulWidget {
  const ProductDealcard({super.key, required this.productData});

  final ProductDealcardData productData;
  @override
  ProductDealcardState createState() => ProductDealcardState();
}

class ProductDealcardState extends ConsumerState<ProductDealcard> {
  // FetchProductDealService productDealService = FetchProductDealService();

  // Future<ProductDealcardData> loadProduct(int productId) async {
  //   final product = await productDealService.fetchProductInfo(productId);
  //   return product;
  // }

  bool isProductNoPrice(ProductDealcardData productData) {
    return productData.isProductNoPrice != null &&
        productData.isProductNoPrice == false &&
        productData.price != '' &&
        productData.price != '0.00';
  }

  @override
  Widget build(BuildContext context) {
    final layoutType = ref.watch(layoutTypeProvider);

    return GestureDetector(
      onTap: () {
        // LoadingDialog.show(context);
        if (mounted) {
          showDialog(
            context: context,
            useRootNavigator: false,
            barrierDismissible: true,
            builder: (context) => ScaffoldMessenger(
              child: Builder(
                builder: (context) => Scaffold(
                  backgroundColor: Colors.transparent,
                  body: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    behavior: HitTestBehavior.opaque,
                    child: GestureDetector(
                      onTap: () {},
                      child: ProductContentDialog(
                        productData: widget.productData,
                        hasDescription: widget
                                    .productData.productDealDescription !=
                                null &&
                            widget.productData.productDealDescription != '' &&
                            widget.productData.productDealDescription!.length >
                                100,
                        content: ProductDealDescription(
                          snackbarContext: context,
                          productData: widget.productData,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }
      },
      child: layoutType == 'Grid'
          ? gridProductCard(widget.productData)
          : listProductCard(widget.productData),
    );
  }

  Widget gridProductCard(ProductDealcardData productData) {
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        ProductImageWidget(
                          imageAsset: productData.imageAsset,
                          sourceType: productData.assetSourceType,
                          size: 'xlarge',
                          fit: BoxFit
                              .contain, //cover will expand but crop the image
                          isExpired: productData.isProductExpired != null &&
                              productData.isProductExpired == true,
                        ),
                        productData.isProductExpired != null &&
                                productData.isProductExpired == true
                            ? Row(
                                children: [
                                  Expanded(
                                      child: Container(
                                    padding: const EdgeInsets.all(
                                        Sizes.paddingAllSmall),
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      border: Border.all(
                                        color: PZColors.pzOrange,
                                        width: 2,
                                      ),
                                    ),
                                    child: const Text(
                                      'EXPIRED',
                                      style: TextStyle(
                                        color: PZColors.pzOrange,
                                        fontSize: Sizes.bodyFontSize,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ))
                                ],
                              )
                            : const SizedBox(),
                      ],
                    ),
                  ),
                ],
              ),
              // Flexible(
              //child:
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                      height: Sizes
                          .spaceBetweenContent), // Add some spacing between
                  Align(
                    alignment: Alignment.centerLeft,
                    child: productName(productData.productName, context),
                  ),
                  const SizedBox(
                      height: Sizes
                          .spaceBetweenContent), // Add some spacing between
                  Flex(
                    direction: Axis.horizontal,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      !isProductNoPrice(productData)
                          ? const Text('No price',
                              style: TextStyle(
                                  fontSize: 18, color: Colors.transparent))
                          : SizedBox(
                              height: 25,
                              child: StoreImageWidget(
                                  storeAssetImage: productData.storeAssetImage),
                            ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Discount Badge
                            BadgeWidget(
                                discountPercentage:
                                    productData.discountPercentage)
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: Sizes.spaceBetweenContentSmall),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: productData.isProductNoPrice != null &&
                            productData.isProductNoPrice == false &&
                            productData.price != '' &&
                            productData.price != '0.00'
                        ? RichText(
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: '\$${productData.price}',
                                  style: const TextStyle(
                                      fontSize: Sizes.fontSizeLarge,
                                      color: PZColors.pzGreen,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.bold),
                                ),
                                const TextSpan(
                                  text: ' ',
                                ),
                                TextSpan(
                                  text:
                                      '\$${productData.oldPrice}', // Replace with your old price
                                  style: const TextStyle(
                                      fontSize: Sizes.bodyFontSize,
                                      color: Colors.red,
                                      decoration: TextDecoration.lineThrough,
                                      fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                          )
                        : StoreImageWidget(
                            storeAssetImage: productData.storeAssetImage),
                  )
                ],
              ),
              // )
            ],
          ),
        ));
  }

  Widget listProductCard(ProductDealcardData productData) {
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
            Stack(
              children: [
                ProductImageWidget(
                  imageAsset: productData.imageAsset,
                  sourceType: productData.assetSourceType,
                  size: 'medium',
                  isExpired: productData.isProductExpired != null &&
                      productData.isProductExpired == true,
                ),
                if (productData.isProductExpired != null &&
                    productData.isProductExpired == true)
                  Positioned(
                    top: 10,
                    left: 0,
                    child: Container(
                      padding: const EdgeInsets.all(Sizes.paddingAllSmall),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(
                          color: PZColors.pzOrange,
                          width: 2,
                        ),
                      ),
                      child: const Text(
                        'EXPIRED',
                        style: TextStyle(
                          color: PZColors.pzOrange,
                          fontSize: Sizes.bodyFontSize,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
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
                      productData.productName,
                      style: const TextStyle(
                        fontSize: Sizes.bodyFontSize,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: productData.isProductNoPrice != null &&
                              productData.isProductNoPrice == true
                          ? 3
                          : 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: Sizes.spaceBetweenSectionsXL),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // Left side: Additional Image
                        Padding(
                          padding: const EdgeInsets.all(0),
                          child: StoreImageWidget(
                              storeAssetImage: productData.storeAssetImage),
                        ),
                        // Right side: Discount Badge and Product Price
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            // Discount Badge
                            if (productData.discountPercentage > 0)
                              BadgeWidget(
                                  discountPercentage:
                                      productData.discountPercentage),

                            // Product Price
                            if (productData.isProductNoPrice != null &&
                                productData.isProductNoPrice == false)
                              RichText(
                                text: TextSpan(
                                  children: [
                                    // Current Price
                                    TextSpan(
                                      text: '\$${productData.price}',
                                      style: const TextStyle(
                                          fontSize: Sizes.fontSizeLarge,
                                          color: PZColors.pzGreen,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const TextSpan(
                                      text: '  ',
                                    ),
                                    // Old Price with Strikethrough
                                    TextSpan(
                                      text: '\$${productData.oldPrice}',
                                      style: const TextStyle(
                                          fontSize: Sizes.bodyFontSize,
                                          color: Colors.red,
                                          decoration:
                                              TextDecoration.lineThrough,
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
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget productName(String productName, BuildContext context) {
    double baseHeight =
        2.8; // The base height for the default text scale factor

    return SizedBox(
      height: baseHeight *
          MediaQuery.textScalerOf(context).scale(Sizes.bodyFontSize * 1.3),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Text(
          productName,
          style: TextStyle(
            fontSize: MediaQuery.textScalerOf(context)
                .scale(Sizes.bodyFontSize * 1.3),
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.start,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
