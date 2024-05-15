import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:pzdeals/src/common_widgets/button_browser.dart';
import 'package:pzdeals/src/common_widgets/expired_deal_banner.dart';
import 'package:pzdeals/src/common_widgets/html_content.dart';
import 'package:pzdeals/src/common_widgets/product_image.dart';
import 'package:pzdeals/src/common_widgets/scrollbar.dart';
import 'package:pzdeals/src/constants/index.dart';
import 'package:pzdeals/src/features/deals/models/index.dart';

class CreditCardDealDescription extends StatelessWidget {
  const CreditCardDealDescription(
      {super.key, required this.creditCardDealData});
  final CreditCardDealData creditCardDealData;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: PZColors.pzWhite,
        automaticallyImplyLeading: false,
        surfaceTintColor: PZColors.pzWhite,
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            iconSize: Sizes.screenCloseIconSize,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: ScrollbarWidget(
          child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.only(
            left: Sizes.paddingLeft,
            right: Sizes.paddingRight,
            bottom: Sizes.paddingBottom,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ProductImageWidget(
                imageAsset: creditCardDealData.imageAsset,
                sourceType: creditCardDealData.sourceType,
                size: 'xlarge',
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      creditCardDealData.title,
                      style: const TextStyle(
                          fontSize: Sizes.fontSizeMedium,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
              const SizedBox(height: Sizes.spaceBetweenSections),
              if (creditCardDealData.isDealExpired != null &&
                  creditCardDealData.isDealExpired == true)
                const ExpiredDealBannerWidget(
                    message: 'Sorry, this deal has expired')
              else if (creditCardDealData.barCodeLink != null &&
                  creditCardDealData.barCodeLink != "")
                OpenBrowserButton(
                    url: creditCardDealData.barCodeLink ?? '',
                    buttonLabel: 'Apply Now'),
              const SizedBox(height: Sizes.spaceBetweenSections),
              HtmlContent(
                htmlContent: creditCardDealData.description ?? '',
                margin: Margins.symmetric(horizontal: 10),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
