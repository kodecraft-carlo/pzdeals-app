import 'package:flutter/material.dart';
import 'package:pzdeals/src/common_widgets/product_image.dart';
import 'package:pzdeals/src/constants/index.dart';
import 'package:pzdeals/src/features/deals/models/index.dart';
import 'package:pzdeals/src/features/deals/presentation/screens/screen_search_result.dart';

class SearchDiscoveryWidget extends StatelessWidget {
  const SearchDiscoveryWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return buildGridView();
  }

  Widget buildGridView() {
    final List<SearchDiscoveryData> searchDiscoveryData = [
      SearchDiscoveryData(
        title: "Men's Long Sleeve Button Up",
        imageAsset:
            "https://www.pzdeals.com/cdn/shop/files/George-Men-s-Corduroy-Shirt-with-Long-Sleeves-Sizes-S-3XL_6623da96-7876-4de0-b812-d84e4fd4dde5.866b71df569242e9070d68158c5eb3aa.webp?v=1707168321",
        assetSourceType: 'network',
      ),
      SearchDiscoveryData(
        title: "Gold wrist watch",
        imageAsset:
            "https://m.media-amazon.com/images/I/616e06+DUoS._AC_UL480_FMwebp_QL65_.jpg",
        assetSourceType: 'network',
      ),
      SearchDiscoveryData(
        title: "Hiking backpack",
        imageAsset:
            "https://m.media-amazon.com/images/I/91RAr-hQ4mL._AC_UL480_FMwebp_QL65_.jpg",
        assetSourceType: 'network',
      ),
      SearchDiscoveryData(
        title: "Men's leather boots",
        imageAsset:
            "https://m.media-amazon.com/images/I/81bVVHmoPHL._AC_UL480_FMwebp_QL65_.jpg",
        assetSourceType: 'network',
      ),
      SearchDiscoveryData(
        title: "Kid's bike",
        imageAsset:
            "https://m.media-amazon.com/images/I/71mewjyRm3L._AC_UL480_FMwebp_QL65_.jpg",
        assetSourceType: 'network',
      ),
      SearchDiscoveryData(
        title: "Women's blouse",
        imageAsset:
            "https://m.media-amazon.com/images/I/517CLTocmeL._AC_UL480_FMwebp_QL65_.jpg",
        assetSourceType: 'network',
      ),
    ];
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 15,
        childAspectRatio: 2,
      ),
      itemCount: searchDiscoveryData.length,
      itemBuilder: (BuildContext context, int index) {
        final searchDiscovery = searchDiscoveryData[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SearchResultScreen(
                    searchKey: searchDiscovery.title,
                  ),
                ));
          },
          child: searchDiscoveryCard(
            searchDiscovery.title,
            searchDiscovery.imageAsset,
            searchDiscovery.assetSourceType,
          ),
        );
      },
    );
  }

  Widget searchDiscoveryCard(
      String title, String imageAsset, String assetSourceType) {
    return Card(
        margin: const EdgeInsets.only(
          top: Sizes.marginTopSmall,
          bottom: Sizes.marginBottomSmall,
        ),
        color: PZColors.pzWhite,
        elevation: 0,
        surfaceTintColor: PZColors.pzWhite,
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: PZColors.pzLightGrey, width: 1.0),
          borderRadius: BorderRadius.circular(Sizes.cardBorderRadius),
        ),
        child: Padding(
          padding: const EdgeInsets.all(Sizes.paddingAllSmall),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ProductImageWidget(
                imageAsset: imageAsset,
                sourceType: assetSourceType,
                size: 'small',
              ),
              const SizedBox(
                  width: Sizes.paddingAllSmall), // Add some spacing between
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: Sizes.bodyFontSize,
                    fontWeight: FontWeight.w400,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              )
            ],
          ),
        ));
  }
}
