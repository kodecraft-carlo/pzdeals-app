import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pzdeals/src/actions/navigate_screen.dart';
import 'package:pzdeals/src/common_widgets/creditcard_image.dart';
import 'package:pzdeals/src/constants/index.dart';
import 'package:pzdeals/src/features/deals/models/index.dart';
import 'package:pzdeals/src/features/deals/presentation/screens/screen_cc_deal_description.dart';

class CreditCardItem extends StatelessWidget {
  final String displayType;
  final CreditCardDealData creditCardDealData;

  const CreditCardItem(
      {super.key, required this.displayType, required this.creditCardDealData});

  @override
  Widget build(BuildContext context) {
    return NavigateScreenWidget(
        destinationWidget: CreditCardDealDescription(
          creditCardDealData: creditCardDealData,
        ),
        childWidget: displayType == "listView"
            ? Container(
                width: 100.0, // Set the width as needed
                margin: const EdgeInsets.only(
                  left: Sizes.cardPaddingLeft,
                  right: Sizes.cardPaddingRight,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    creditcardImage(creditCardDealData.imageAsset,
                        creditCardDealData.sourceType),
                    Text(
                        creditCardDealData.isDealExpired != null &&
                                creditCardDealData.isDealExpired == true
                            ? 'EXPIRED: ${creditCardDealData.title}'
                            : creditCardDealData.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: Sizes.bodySmallSize,
                        )),
                  ],
                ),
              )
            : Card(
                elevation: 2.0,
                color: PZColors.pzLightGrey,
                margin: const EdgeInsets.only(
                    top: Sizes.marginTopSmall, bottom: Sizes.marginBottomSmall),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: Sizes.paddingLeftSmall,
                      right: Sizes.paddingRightSmall),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Left side - Image
                      CreditCardImageWidget(
                          imageAsset: creditCardDealData.imageAsset,
                          sourceType: creditCardDealData.sourceType),
                      // Right side - Description
                      const SizedBox(
                        width: Sizes.paddingAll,
                      ),
                      Expanded(
                        child: Text(
                          creditCardDealData.isDealExpired != null &&
                                  creditCardDealData.isDealExpired == true
                              ? 'EXPIRED: ${creditCardDealData.title}'
                              : creditCardDealData.title,
                          style: const TextStyle(fontSize: Sizes.fontSizeSmall),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
        animationDirection: 'bottomToTop');
  }

  Widget creditcardImage(String imageAsset, String sourceType) {
    Widget imageWidget;
    if (sourceType == 'network') {
      imageWidget = CachedNetworkImage(
        imageUrl: imageAsset,
        height: 65,
        fit: BoxFit.fitWidth,
        // placeholder: (context, url) => const Center(
        //   child: CircularProgressIndicator(
        //     valueColor: AlwaysStoppedAnimation<Color>(PZColors.pzGrey),
        //     backgroundColor: PZColors.pzLightGrey,
        //     strokeWidth: 3,
        //   ),
        // ),
        errorWidget: (context, url, error) {
          debugPrint('Error loading image: $error');
          return Image.asset(
            'assets/images/pzdeals.png',
            height: 65,
            fit: BoxFit.fitWidth,
          );
        },
      );
    } else {
      imageWidget = Image.asset(
        imageAsset,
        fit: BoxFit.fitWidth,
        height: 65.0,
      );
    }
    return imageWidget;
  }
}
