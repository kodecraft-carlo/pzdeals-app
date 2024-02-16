import 'package:flutter/material.dart';
import 'package:pzdeals/src/actions/navigate_screen.dart';
import 'package:pzdeals/src/common_widgets/screen_collections_display.dart';
import 'package:pzdeals/src/common_widgets/square_labeled_icons.dart';
import 'package:pzdeals/src/constants/index.dart';
import 'package:pzdeals/src/features/more/models/index.dart';

class ShopCategory extends StatelessWidget {
  const ShopCategory({super.key, required this.categoryData});

  final List<CategoryData> categoryData;
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double itemWidth = screenWidth / 4;

    return GridView.builder(
      padding: const EdgeInsets.all(Sizes.paddingAll),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: itemWidth,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 2 / 3),
      itemCount: categoryData.length,
      itemBuilder: (context, index) {
        final category = categoryData[index];
        return NavigateScreenWidget(
          destinationWidget:
              CollectionDisplayScreenWidget(collectionTitle: category.category),
          childWidget: SquareLabeledIcon(
              iconTitle: category.category,
              iconImage: category.categoryAssetImage,
              iconAssetType: category.assetSourceType),
          animationDirection: 'leftToRight',
        );
      },
    );
  }
}
