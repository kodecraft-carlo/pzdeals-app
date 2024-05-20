import 'package:flutter/material.dart';
import 'package:pzdeals/src/common_widgets/scrollbar.dart';
import 'package:pzdeals/src/constants/index.dart';
import 'package:pzdeals/src/features/stores/presentation/widgets/index.dart';
import 'package:pzdeals/src/models/index.dart';

class DisplayStores extends StatelessWidget {
  DisplayStores({super.key, required this.storedata, this.scrollController});

  final List<StoreData> storedata;

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
          itemCount: storedata.length,
          itemBuilder: (context, index) {
            if (storedata.isNotEmpty) {
              final store = storedata[index];
              return StoreCardWidget(storeData: store);
            } else {
              // Return an empty container if storedata is empty
              return Container();
            }
          },
        ));
  }
}
