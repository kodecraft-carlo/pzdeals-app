import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:pzdeals/src/common_widgets/product_image.dart';
import 'package:pzdeals/src/constants/index.dart';

class CreditCardDealDescription extends StatelessWidget {
  const CreditCardDealDescription(
      {super.key,
      required this.title,
      required this.description,
      required this.imageAsset,
      required this.sourceType});
  final String title;
  final String description;
  final String imageAsset;
  final String sourceType;
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
      body: SingleChildScrollView(
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
                imageAsset: imageAsset,
                sourceType: sourceType,
                size: 'xlarge',
              ),
              Text(
                title,
                style: const TextStyle(
                    fontSize: Sizes.fontSizeMedium,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: Sizes.spaceBetweenSections),
              ElevatedButton(
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
                  debugPrint('Credit Card Deal presssed');
                },
                child: const Text(
                  'Apply now',
                  style: TextStyle(color: PZColors.pzWhite),
                ),
              ),
              const SizedBox(height: Sizes.spaceBetweenSections),
              Html(
                data: description,
                style: {
                  "body": Style(
                    padding: HtmlPaddings.zero,
                    margin: Margins.zero,
                  ),
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
