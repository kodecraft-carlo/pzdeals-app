import 'package:flutter/material.dart';
import 'package:pzdeals/src/actions/navigate_screen.dart';
import 'package:pzdeals/src/common_widgets/screen_collections_display.dart';
import 'package:pzdeals/src/common_widgets/text_widget.dart';
import 'package:pzdeals/src/constants/index.dart';
import 'package:pzdeals/src/features/deals/models/index.dart';
import 'package:pzdeals/src/features/deals/presentation/widgets/for_you_collection_deal_card.dart';

class ForYouCollectionList extends StatelessWidget {
  const ForYouCollectionList({
    super.key,
    required this.title,
    required this.productData,
  });

  final String title;
  final List<ProductDealcardData> productData;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      margin: const EdgeInsets.only(
        bottom: Sizes.marginBottom,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextWidget(
              text: title, textDisplayType: TextDisplayType.sectionTitle),
          Flexible(
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: productData.length + 1,
              itemBuilder: (BuildContext context, int index) {
                if (index < productData.length) {
                  final product = productData[index];
                  return AspectRatio(
                    aspectRatio: .64,
                    child: StaticProductDealCardWidget(
                      productName: product.productName,
                      price: product.price,
                      storeAssetImage: product.storeAssetImage,
                      oldPrice: product.oldPrice,
                      imageAsset: product.imageAsset,
                      discountPercentage: product.discountPercentage,
                      assetSourceType: product.assetSourceType,
                    ),
                  );
                } else {
                  return NavigateScreenWidget(
                    destinationWidget: CollectionDisplayScreenWidget(
                      collectionTitle: title,
                    ),
                    childWidget: Container(
                      width: 150,
                      padding: const EdgeInsets.all(8),
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius:
                            BorderRadius.circular(Sizes.cardBorderRadius),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'View more',
                            style: TextStyle(
                              color: PZColors.pzOrange,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_circle_right_outlined,
                              color: PZColors.pzOrange),
                        ],
                      ),
                    ),
                    animationDirection: 'leftToRight',
                  );
                }
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const SizedBox(width: Sizes.spaceBetweenContent),
            ),
          ),
        ],
      ),
    );
  }
}
