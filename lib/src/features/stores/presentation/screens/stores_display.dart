import 'package:flutter/material.dart';
import 'package:pzdeals/src/actions/show_dialog.dart';
import 'package:pzdeals/src/constants/index.dart';
import 'package:pzdeals/src/features/stores/models/index.dart';
import 'package:pzdeals/src/features/stores/presentation/widgets/index.dart';

class DisplayStores extends StatelessWidget {
  DisplayStores({super.key, required this.storedata});

  final List<StoreData> storedata;
  final StoreData pzDeals = StoreData(
      storeName: 'PZ Deals',
      storeAssetImage: 'assets/images/pzdeals_store.png',
      assetSourceType: 'asset');
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double itemWidth = screenWidth / 4;

    return GridView.builder(
      padding: const EdgeInsets.all(Sizes.paddingAll),
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: itemWidth,
          crossAxisSpacing: 10,
          mainAxisSpacing: 15,
          childAspectRatio: 2 / 3),
      itemCount: storedata.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          // return GestureDetector(
          //   onTap: () {
          //     showDialog(
          //       context: context,
          //       builder: (BuildContext context) {
          //         return const CustomInputDialog();
          //       },
          //     );
          //   },
          //   child: StoreCardWidget(storeDetails: pzDeals),
          // );
          return ShowDialogWidget(
            content: const StoreInputDialog(),
            childWidget: StoreCardWidget(storeDetails: pzDeals),
          );
        } else {
          final store = storedata[index - 1];
          return ShowDialogWidget(
            content: const StoreDialog(),
            childWidget: StoreCardWidget(storeDetails: store),
          );
        }
      },
    );
  }
}
