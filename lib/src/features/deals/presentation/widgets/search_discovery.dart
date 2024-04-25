import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pzdeals/src/common_widgets/product_image.dart';
import 'package:pzdeals/src/constants/index.dart';
import 'package:pzdeals/src/features/deals/models/index.dart';
import 'package:pzdeals/src/features/deals/presentation/screens/screen_search_result.dart';
import 'package:pzdeals/src/features/deals/state/provider_search.dart';

class SearchDiscoveryWidget extends ConsumerWidget {
  const SearchDiscoveryWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchProductState = ref.watch(searchproductProvider);
    final List<SearchDiscoveryData> searchDiscoveryData =
        searchProductState.searchDiscovery;
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
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              )
            ],
          ),
        ));
  }
}
