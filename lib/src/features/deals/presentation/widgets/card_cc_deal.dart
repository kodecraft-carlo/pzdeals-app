import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:pzdeals/src/actions/navigate_screen.dart';
import 'package:pzdeals/src/common_widgets/creditcard_image.dart';
import 'package:pzdeals/src/constants/index.dart';
import 'package:pzdeals/src/features/deals/presentation/screens/screen_cc_deal_description.dart';

class CreditCardItem extends StatelessWidget {
  final String imageAsset;
  final String description;
  final String title;
  final String sourceType;
  final String displayType;

  const CreditCardItem(
      {super.key,
      required this.imageAsset,
      required this.description,
      required this.title,
      required this.sourceType,
      required this.displayType});

  @override
  Widget build(BuildContext context) {
    return NavigateScreenWidget(
        destinationWidget: CreditCardDealDescription(
          title: title,
          description: description,
          imageAsset: imageAsset,
          sourceType: sourceType,
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
                    Image.asset(
                      imageAsset,
                      fit: BoxFit.fitWidth,
                      height: 65.0, // Set the height of the image box
                    ),
                    Text(title,
                        maxLines: 1,
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
                          imageAsset: imageAsset, sourceType: sourceType),
                      // Right side - Description
                      const SizedBox(
                        width: Sizes.paddingAll,
                      ),
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(fontSize: Sizes.bodySmallSize),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
        animationDirection: 'bottomToTop');
  }
}
