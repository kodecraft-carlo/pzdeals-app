import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pzdeals/src/actions/show_browser.dart';
import 'package:pzdeals/src/common_widgets/badge.dart';
import 'package:pzdeals/src/common_widgets/coupon_code_widget.dart';
import 'package:pzdeals/src/common_widgets/expired_deal_banner.dart';
import 'package:pzdeals/src/common_widgets/html_content.dart';
import 'package:pzdeals/src/common_widgets/product_image.dart';
import 'package:pzdeals/src/common_widgets/store_image.dart';
import 'package:pzdeals/src/constants/color_constants.dart';
import 'package:pzdeals/src/constants/sizes.dart';
import 'package:pzdeals/src/features/deals/models/index.dart';

class ProductDealDescription extends ConsumerStatefulWidget {
  const ProductDealDescription(
      {super.key, required this.productData, required this.snackbarContext});

  final ProductDealcardData productData;
  final BuildContext snackbarContext;
  @override
  ProductDealDescriptionState createState() => ProductDealDescriptionState();
}

class ProductDealDescriptionState
    extends ConsumerState<ProductDealDescription> {
  @override
  Widget build(BuildContext context) {
    // RenderObject.debugCheckingIntrinsics = true;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            //Commented as of 05/08/2024 - client requested to remove the image preview
            // GestureDetector(
            //   onTap: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) => ProductImageDetailScreen(
            //           imageUrl: widget.productData.imageAsset,
            //           heroTag:
            //               'imageHero${widget.productData.productId}', // Unique tag for this image within the screen
            //         ),
            //       ),
            //     );
            //   },
            //   child: Hero(
            //     tag: 'imageHero${widget.productData.productId}',
            //     child: ProductImageWidget(
            //       imageAsset: widget.productData.imageAsset,
            //       sourceType: widget.productData.assetSourceType,
            //       size: 'container',
            //       fit: BoxFit.contain,
            //       isExpired: widget.productData.isProductExpired != null &&
            //           widget.productData.isProductExpired == true,
            //     ),
            //   ),
            // ),
            GestureDetector(
              child: ProductImageWidget(
                imageAsset: widget.productData.imageAsset,
                sourceType: widget.productData.assetSourceType,
                size: 'container',
                fit: BoxFit.contain,
                isExpired: widget.productData.isProductExpired != null &&
                    widget.productData.isProductExpired == true,
              ),
              onTap: () {
                if (widget.productData.barcodeLink != null &&
                    widget.productData.barcodeLink!.isNotEmpty &&
                    widget.productData.barcodeLink != '') {
                  openBrowser(widget.productData.barcodeLink ?? '');
                }
              },
            ),
            widget.productData.isProductExpired != null &&
                    widget.productData.isProductExpired == true
                ? Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: Sizes.paddingAllSmall),
                    child: Row(
                      children: [
                        Expanded(
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
                              fontSize: Sizes.fontSizeXLarge,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ))
                      ],
                    ),
                  )
                : const SizedBox(),
          ],
        ),
        const SizedBox(
          height: Sizes.spaceBetweenContent,
        ),
        Text(
          widget.productData.productName,
          style: const TextStyle(
              fontSize: Sizes.fontSizeMedium, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: Sizes.spaceBetweenContentSmall),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            widget.productData.discountPercentage > 0
                ? BadgeWidget(
                    discountPercentage: widget.productData.discountPercentage)
                : const SizedBox.shrink(),
            widget.productData.discountPercentage > 0
                ? const SizedBox(width: Sizes.paddingAllSmall)
                : const SizedBox.shrink(),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(
                    top: Sizes.paddingAllSmall / 2,
                    bottom: Sizes.paddingAllSmall / 2),
                child: Container(
                    //add red outline
                    // decoration: BoxDecoration(
                    //   border: Border.all(
                    //     color: Colors.red,
                    //     width: 1,
                    //   ),
                    //   borderRadius: BorderRadius.circular(5),
                    // ),
                    height: 21,
                    child: Align(
                      alignment: Alignment.center,
                      child: StoreImageWidget(
                        storeAssetImage: widget.productData.storeAssetImage,
                        imageWidth: 30,
                        imageHeight: 25,
                        hasLayoutType: false,
                      ),
                    )),
              ),
            ),
          ],
        ),
        // const SizedBox(height: Sizes.spaceBetweenContentSmall),
        widget.productData.isProductNoPrice != null &&
                widget.productData.isProductNoPrice == false &&
                (widget.productData.oldPrice != null &&
                    double.parse(widget.productData.oldPrice
                            .toString()
                            .replaceAll(',', '')) >
                        0 &&
                    widget.productData.oldPrice != '')
            ? RichText(
                text: TextSpan(
                  children: [
                    // Current Price
                    TextSpan(
                      text: '\$${widget.productData.price}',
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
                    widget.productData.oldPrice != '0.00'
                        ? TextSpan(
                            text:
                                '\$${widget.productData.oldPrice}', // Replace with your old price
                            style: const TextStyle(
                              fontSize: Sizes.fontSizeMedium,
                              color: Colors.red,
                              decoration: TextDecoration.lineThrough,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        : const TextSpan(text: ''),
                  ],
                ),
              )
            : const SizedBox.shrink(),
        const SizedBox(height: Sizes.spaceBetweenContent),
        if (widget.productData.isProductExpired != null &&
            widget.productData.isProductExpired == true)
          const ExpiredDealBannerWidget(
              message: 'Sorry, this deal has expired'),
        if (widget.productData.isProductExpired != null &&
            widget.productData.isProductExpired == true)
          const SizedBox(height: Sizes.spaceBetweenContent),
        //Added 05/08/2024 Tag Description
        widget.productData.sku != null && widget.productData.sku!.isNotEmpty
            ? Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: Sizes.paddingAllSmall,
                      top: 10,
                      bottom: 5,
                      right: Sizes.paddingAllSmall),
                  child: RichText(
                    textAlign: TextAlign.start,
                    text: TextSpan(children: [
                      // const TextSpan(
                      //   text: '•  ',
                      //   style: TextStyle(
                      //     color: Colors.black,
                      //     fontWeight: FontWeight.w600,
                      //     fontFamily: 'Poppins',
                      //   ),
                      // ),
                      const TextSpan(
                        text: 'Coupon code ',
                        style: TextStyle(
                          color: Colors.black,
                          // fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: CouponCodeWidget(
                            text: widget.productData.sku ?? '',
                            url: widget.productData.barcodeLink ?? '',
                          )),
                    ]),
                  ),
                ),
              )
            : const SizedBox.shrink(),
        //add divider line if there is a sku or product description

        (widget.productData.productDealDescription != null &&
                    widget.productData.productDealDescription?.trim() != '') ||
                (widget.productData.tagDealDescription != null &&
                    widget.productData.tagDealDescription != '')
            ? SizedBox(
                width: MediaQuery.of(context).size.width / 3,
                child: Divider(
                  color: Colors.grey[300],
                  thickness: .75,
                ))
            : const SizedBox.shrink(),

        widget.productData.sku != null && widget.productData.sku!.isNotEmpty ||
                widget.productData.productDealDescription != null &&
                    widget.productData.productDealDescription?.trim() != '' ||
                widget.productData.tagDealDescription != null &&
                    widget.productData.tagDealDescription != ''
            ? const SizedBox(height: Sizes.spaceBetweenContent)
            : const SizedBox.shrink(),

        widget.productData.productDealDescription != null &&
                widget.productData.productDealDescription?.trim() != ''
            ? Row(
                children: [
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: Sizes.paddingAllSmall),
                    child: HtmlContent(
                      htmlContent:
                          widget.productData.productDealDescription!.trim(),
                      isProductDescription: true,
                    ),
                  ))
                ],
              )
            : const SizedBox.shrink(),
        widget.productData.tagDealDescription != null &&
                widget.productData.tagDealDescription != '' &&
                widget.productData.productDealDescription != null &&
                widget.productData.productDealDescription?.trim() != ''
            ? const SizedBox(
                height: Sizes.spaceBetweenContent,
              )
            : const SizedBox.shrink(),
        widget.productData.tagDealDescription != null &&
                widget.productData.tagDealDescription != ''
            ? Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: Sizes.paddingAllSmall,
                        right: Sizes.paddingAllSmall,
                      ),
                      child: HtmlContent(
                        htmlContent:
                            widget.productData.tagDealDescription ?? '',
                        isProductDescription: true,
                      ),
                    ),
                  ),
                ],
              )
            : const SizedBox.shrink(),
        const SizedBox(height: Sizes.spaceBetweenSections),
      ],
    );
  }
}
