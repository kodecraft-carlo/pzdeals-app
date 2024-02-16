import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:pzdeals/src/features/deals/models/index.dart';
import 'package:pzdeals/src/features/deals/presentation/widgets/product_deal_card.dart';
import 'package:pzdeals/src/constants/sizes.dart';

class ProductsDisplay extends StatelessWidget {
  const ProductsDisplay(
      {super.key, required this.productData, required this.layoutType});

  final List<ProductDealcardData> productData;
  final String layoutType;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double itemWidth = screenWidth / 2;
    return Scaffold(
      body: layoutType == 'List' ? buildListView() : buildGridView(itemWidth),
    );
  }

  Widget buildListView() {
    return ListView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.only(
        top: Sizes.paddingTopSmall,
        left: Sizes.paddingLeft,
        right: Sizes.paddingRight,
        bottom: Sizes.paddingBottom,
      ),
      itemCount: productData.length,
      itemBuilder: (BuildContext context, int index) {
        final product = productData[index];
        return ProductDealcard(
          productName: product.productName,
          price: product.price,
          storeAssetImage: product.storeAssetImage,
          oldPrice: product.oldPrice,
          imageAsset: product.imageAsset,
          discountPercentage: product.discountPercentage,
          assetSourceType: product.assetSourceType,
        );
      },
    );
  }

  Widget buildGridView(itemWidth) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: itemWidth,
          crossAxisSpacing: 15,
          childAspectRatio: 2 / 3.5),
      padding: const EdgeInsets.only(
        top: Sizes.paddingTopSmall,
        left: Sizes.paddingLeft,
        right: Sizes.paddingRight,
        bottom: Sizes.paddingBottom,
      ),
      itemCount: productData.length,
      itemBuilder: (BuildContext context, int index) {
        final product = productData[index];
        return ProductDealcard(
          productName: product.productName,
          price: product.price,
          storeAssetImage: product.storeAssetImage,
          oldPrice: product.oldPrice,
          imageAsset: product.imageAsset,
          discountPercentage: product.discountPercentage,
          assetSourceType: product.assetSourceType,
        );
      },
    );
  }
}
