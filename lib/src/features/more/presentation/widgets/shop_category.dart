import 'package:flutter/material.dart';
import 'package:pzdeals/src/actions/navigate_screen.dart';
import 'package:pzdeals/src/common_widgets/screen_collections_display.dart';
import 'package:pzdeals/src/common_widgets/square_labeled_icons.dart';
import 'package:pzdeals/src/constants/index.dart';
import 'package:pzdeals/src/features/deals/models/collection_data.dart';

class ShopCategory extends StatelessWidget {
  const ShopCategory({super.key, required this.categoryData});

  final List<CollectionData> categoryData;
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double itemWidth = screenWidth / 4;

    return GridView.builder(
      padding: const EdgeInsets.all(Sizes.paddingAll),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: itemWidth,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 2 / 3),
      itemCount: categoryData.length,
      itemBuilder: (context, index) {
        final category = categoryData[index];
        return NavigateScreenWidget(
          destinationWidget: CollectionDisplayScreenWidget(
            collectionTitle: '${category.title} Deals',
            keyword: category.keyword ?? '',
            collectionId: category.id,
          ),
          childWidget: SquareLabeledIcon(
              iconTitle: category.title,
              iconImage: category.imageAsset,
              iconAssetType: category.assetSourceType),
        );
      },
    );
  }
}
