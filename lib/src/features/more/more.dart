import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pzdeals/src/common_widgets/sliver_appbar.dart';
import 'package:pzdeals/src/constants/index.dart';
import 'package:pzdeals/src/features/deals/deals.dart';
import 'package:pzdeals/src/features/more/presentation/widgets/index.dart';

class MoreScreen extends StatelessWidget {
  MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          SliverAppBarWidget(
              innerBoxIsScrolled: innerBoxIsScrolled,
              searchFieldWidget: const MoreScreenSearchFieldWidget(
                hintText: "Search deals",
              )),
        ];
      },
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const MoreShortcutsWidget(),
          const SizedBox(height: Sizes.spaceBetweenContentSmall),
          const Padding(
              padding: EdgeInsets.symmetric(horizontal: Sizes.paddingAll),
              child: Text("Shop by Category",
                  style: TextStyle(
                      color: PZColors.pzBlack,
                      fontSize: Sizes.sectionHeaderFontSize,
                      fontWeight: FontWeight.w600))),
          Consumer(builder: (context, ref, child) {
            final collectionState = ref.watch(tabForYouProvider);
            return Expanded(
              child: ShopCategory(categoryData: collectionState.collections),
            );
          }),
        ],
      ),
    ));
  }
}
