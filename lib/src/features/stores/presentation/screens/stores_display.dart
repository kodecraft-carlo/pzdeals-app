import 'package:flutter/material.dart';
import 'package:pzdeals/src/common_widgets/scrollbar.dart';
import 'package:pzdeals/src/constants/index.dart';
import 'package:pzdeals/src/features/stores/presentation/widgets/index.dart';
import 'package:pzdeals/src/models/index.dart';

class DisplayStores extends StatelessWidget {
  DisplayStores({super.key, required this.storedata, this.scrollController});

  final List<StoreData> storedata;
  final StoreData pzDeals = StoreData(
      id: 0,
      handle: 'pzdeals',
      storeName: Wordings.appName,
      storeAssetImage: 'assets/images/pzdeals_store.png',
      assetSourceType: 'asset');

  final ScrollController? scrollController;
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double itemWidth = screenWidth / 4;
    return ScrollbarWidget(
        scrollController: scrollController,
        child: GridView.builder(
          controller: scrollController,
          padding: const EdgeInsets.all(Sizes.paddingAll),
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: itemWidth,
              crossAxisSpacing: 10,
              mainAxisSpacing: 15,
              childAspectRatio: 2 / 3),
          itemCount: storedata.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return StoreCardWidget(storeData: pzDeals);
            } else if (storedata.isNotEmpty) {
              final store = storedata[index - 1];
              return StoreCardWidget(storeData: store);
            } else {
              // Return an empty container if storedata is empty
              return Container();
            }
          },
        ));
  }
}
