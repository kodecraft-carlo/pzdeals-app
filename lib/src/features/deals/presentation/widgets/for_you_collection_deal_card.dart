import 'package:flutter/material.dart';
import 'package:pzdeals/src/common_widgets/badge.dart';
import 'package:pzdeals/src/common_widgets/product_dialog.dart';
import 'package:pzdeals/src/common_widgets/product_image.dart';
import 'package:pzdeals/src/common_widgets/store_image.dart';
import 'package:pzdeals/src/constants/color_constants.dart';
import 'package:pzdeals/src/constants/sizes.dart';
import 'package:pzdeals/src/features/deals/models/index.dart';
import 'package:pzdeals/src/features/deals/presentation/widgets/index.dart';

class StaticProductDealCardWidget extends StatefulWidget {
  const StaticProductDealCardWidget({super.key, required this.productData});

  final ProductDealcardData productData;
  @override
  StaticProductDealCardWidgetState createState() =>
      StaticProductDealCardWidgetState();
}

class StaticProductDealCardWidgetState
    extends State<StaticProductDealCardWidget> {
  // FetchProductDealService productDealService = FetchProductDealService();
  // Future<ProductDealcardData> loadProduct(int productId) async {
  //   final product = await productDealService.fetchProductInfo(productId);
  //   return product;
  // }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
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
                        hasDescription:
                            widget.productData.productDealDescription != null &&
                                widget.productData.productDealDescription != '',
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
      child: Card(
          margin: const EdgeInsets.only(
            top: Sizes.marginTopSmall,
            bottom: Sizes.marginBottomSmall,
          ),
          color: PZColors.pzWhite,
          surfaceTintColor: PZColors.pzWhite,
          elevation: 0,
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
                              imageAsset: widget.productData.imageAsset,
                              sourceType: widget.productData.assetSourceType,
                              size: 'large',
                              isExpired: widget.productData.isProductExpired !=
                                      null &&
                                  widget.productData.isProductExpired == true,
                            ),
                            widget.productData.isProductExpired != null &&
                                    widget.productData.isProductExpired == true
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
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: Sizes.spaceBetweenContent),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            widget.productData.productName,
                            style: const TextStyle(
                              fontSize: Sizes.bodyFontSize,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.start,
                            maxLines: widget.productData.isProductNoPrice !=
                                        null &&
                                    widget.productData.isProductNoPrice == true
                                ? 3
                                : 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(
                            height: Sizes
                                .spaceBetweenContent), // Add some spacing between
                        Flex(
                          direction: Axis.horizontal,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            StoreImageWidget(
                                storeAssetImage:
                                    widget.productData.storeAssetImage),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  widget.productData.discountPercentage > 0
                                      ? BadgeWidget(
                                          discountPercentage: widget
                                              .productData.discountPercentage)
                                      : const SizedBox(),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: Sizes.spaceBetweenContentSmall),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: widget.productData.isProductNoPrice != null &&
                                  widget.productData.isProductNoPrice ==
                                      false &&
                                  widget.productData.price != '' &&
                                  widget.productData.price != '0.00'
                              ? RichText(
                                  maxLines: 1,
                                  softWrap: false,
                                  textWidthBasis: TextWidthBasis.parent,
                                  overflow: TextOverflow.ellipsis,
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: '\$${widget.productData.price}',
                                        style: const TextStyle(
                                            fontSize: Sizes.listTitleFontSize,
                                            color: PZColors.pzGreen,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const TextSpan(
                                        text: ' ',
                                      ),
                                      TextSpan(
                                        text:
                                            '\$${widget.productData.oldPrice}',
                                        style: const TextStyle(
                                            fontSize: Sizes.bodyFontSize,
                                            color: Colors.red,
                                            decoration:
                                                TextDecoration.lineThrough,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ],
                                  ),
                                )
                              : const SizedBox.shrink(),
                        )
                      ],
                    ),
                  ),
                ],
              ))),
    );
  }
}
