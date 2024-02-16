import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pzdeals/main.dart';
import 'package:pzdeals/src/common_widgets/search_cancel.dart';
import 'package:pzdeals/src/common_widgets/search_field.dart';
import 'package:pzdeals/src/constants/index.dart';
import 'package:pzdeals/src/features/deals/presentation/screens/screen_search_result.dart';
import 'package:pzdeals/src/features/deals/presentation/widgets/search_discovery.dart';
import 'package:pzdeals/src/features/deals/presentation/widgets/search_keywords.dart';
import 'package:pzdeals/src/state/authentication_provider.dart';

class SearchDealScreen extends StatelessWidget {
  const SearchDealScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: PZColors.pzWhite,
        surfaceTintColor: PZColors.pzWhite,
        title: const Row(
          children: [
            Expanded(
              child: SearchFieldWidget(
                hintText: "Search deals",
                destinationScreen: SearchResultScreen(),
                autoFocus: true,
              ),
            ),
          ],
        ),
        actions: const [
          Padding(
              padding: EdgeInsets.only(right: Sizes.paddingRight),
              child: SearchCancelWidget(
                  destinationWidget: NavigationWidget(
                initialPageIndex: 0,
              ))),
        ],
      ),
      body: Padding(
          padding: const EdgeInsets.only(
              left: 13, right: 13, top: Sizes.spaceBetweenContent),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Consumer(builder: (context, ref, child) {
                final authentication = ref.watch(authenticationProvider);
                if (authentication == true) {
                  return SearchKeyWords();
                } else {
                  return const SizedBox();
                }
              }),
              const SizedBox(height: Sizes.spaceBetweenSections),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text("Search Discovery",
                    style: TextStyle(
                        fontSize: Sizes.fontSizeMedium,
                        fontWeight: FontWeight.w600,
                        color: PZColors.pzBlack)),
              ),
              const Expanded(child: SearchDiscoveryWidget())
            ],
          )),
    );
  }
}
