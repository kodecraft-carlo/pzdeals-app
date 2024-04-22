import 'package:flutter/material.dart';
import 'package:pzdeals/src/constants/index.dart';
import 'package:pzdeals/src/features/deals/models/index.dart';
import 'package:pzdeals/src/features/deals/presentation/widgets/product_deal_card.dart';
import 'package:pzdeals/src/constants/sizes.dart';

class ProductsDisplay extends StatelessWidget {
  const ProductsDisplay(
      {super.key,
      required this.productData,
      required this.layoutType,
      this.scrollController,
      this.scrollKey,
      this.onRefresh});

  final List<ProductDealcardData> productData;
  final String layoutType;
  final ScrollController? scrollController;
  final String? scrollKey;
  final Future<void> Function()? onRefresh;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double itemWidth = screenWidth / 2;
    return Scaffold(
      body: layoutType == 'List' ? buildListView() : buildGridView(itemWidth),
    );
  }

  Widget buildListView() {
    return RefreshIndicator.adaptive(
      onRefresh: onRefresh ?? () async {},
      child: ListView.builder(
        key: PageStorageKey<String>(scrollKey ?? 'list'),
        shrinkWrap: true,
        controller: scrollController,
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
            productData: product,
          );
        },
      ),
    );
  }

  Widget buildGridView(itemWidth) {
    return RefreshIndicator.adaptive(
        onRefresh: onRefresh ?? () async {},
        color: PZColors.pzOrange,
        child: GridView.builder(
          shrinkWrap: true,
          controller: scrollController,
          key: PageStorageKey<String>(scrollKey ?? 'grid'),
          padding: const EdgeInsets.only(
            top: Sizes.paddingTopSmall,
            left: Sizes.paddingLeft,
            right: Sizes.paddingRight,
            bottom: Sizes.paddingBottom,
          ),
          itemCount: productData.length,
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: itemWidth,
              crossAxisSpacing: 15,
              childAspectRatio: .47),
          itemBuilder: (BuildContext context, int index) {
            final product = productData[index];
            return ProductDealcard(
              productData: product,
            );
          },
        ));
  }
}
