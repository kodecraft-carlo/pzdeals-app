import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pzdeals/src/actions/show_browser.dart';
import 'package:pzdeals/src/common_widgets/badge.dart';
import 'package:pzdeals/src/common_widgets/expired_deal_banner.dart';
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
            ProductImageWidget(
              imageAsset: widget.productData.imageAsset,
              sourceType: widget.productData.assetSourceType,
              size: 'container',
              fit: BoxFit.contain,
              isExpired: widget.productData.isProductExpired != null &&
                  widget.productData.isProductExpired == true,
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
        StoreImageWidget(
          storeAssetImage: widget.productData.storeAssetImage,
          imageWidth: 40,
          hasLayoutType: false,
        ),
        const SizedBox(
          height: Sizes.spaceBetweenContent,
        ),
        Text(
          widget.productData.productName,
          style: const TextStyle(
              fontSize: Sizes.fontSizeMedium, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        widget.productData.discountPercentage > 0
            ? const SizedBox(height: Sizes.spaceBetweenSections)
            : const SizedBox.shrink(),
        widget.productData.discountPercentage > 0
            ? BadgeWidget(
                discountPercentage: widget.productData.discountPercentage)
            : const SizedBox.shrink(),
        const SizedBox(height: Sizes.spaceBetweenContent),
        widget.productData.isProductNoPrice != null &&
                widget.productData.isProductNoPrice == false
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
                    TextSpan(
                      text:
                          '\$${widget.productData.oldPrice}', // Replace with your old price
                      style: const TextStyle(
                        fontSize: Sizes.fontSizeMedium,
                        color: Colors.red,
                        decoration: TextDecoration.lineThrough,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              )
            : const SizedBox.shrink(),
        const SizedBox(height: Sizes.spaceBetweenSections),
        if (widget.productData.isProductExpired != null &&
            widget.productData.isProductExpired == true)
          const ExpiredDealBannerWidget(
              message: 'Sorry, this deal has expired'),
        widget.productData.productDealDescription != null &&
                widget.productData.productDealDescription != ''
            ? Row(
                children: [
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: Sizes.paddingAllSmall,
                        vertical: Sizes.paddingAllSmall),
                    child: Html(
                        shrinkWrap: true,
                        data: widget.productData.productDealDescription,
                        style: {
                          "body": Style(
                            padding: HtmlPaddings.zero,
                            margin: Margins.zero,
                            textAlign: TextAlign.left,
                          ),
                          "ul": Style(
                            padding: HtmlPaddings.zero,
                            margin: Margins.zero,
                            textAlign: TextAlign.left,
                          ),
                          "a": Style(
                            color: Colors.blue,
                            textDecoration: TextDecoration.none,
                          ),
                        },
                        onLinkTap: (url, attributes, element) =>
                            openBrowser(url ?? '')),
                  ))
                ],
              )
            : const SizedBox(),
        const SizedBox(height: Sizes.spaceBetweenSections),
      ],
    );
  }
}
