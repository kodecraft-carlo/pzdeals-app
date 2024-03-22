import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pzdeals/main.dart';
import 'package:pzdeals/src/common_widgets/search_cancel.dart';
import 'package:pzdeals/src/common_widgets/search_field.dart';
import 'package:pzdeals/src/constants/index.dart';
import 'package:pzdeals/src/features/deals/presentation/screens/screen_search_result.dart';
import 'package:pzdeals/src/features/deals/presentation/widgets/search_discovery.dart';
import 'package:pzdeals/src/features/deals/presentation/widgets/search_keywords.dart';
import 'package:pzdeals/src/features/deals/state/provider_search.dart';

import 'package:pzdeals/src/state/auth_user_data.dart';

class SearchDealScreen extends ConsumerStatefulWidget {
  const SearchDealScreen({super.key});
  @override
  SearchDealScreenState createState() => SearchDealScreenState();
}

class SearchDealScreenState extends ConsumerState<SearchDealScreen> {
  void searchfieldSubmit(String value) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return SearchResultScreen(
        searchKey: value,
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: PZColors.pzWhite,
        surfaceTintColor: PZColors.pzWhite,
        title: Consumer(builder: (context, ref, child) {
          final searchState = ref.watch(searchproductProvider);
          return Row(
            children: [
              Expanded(
                child: SearchFieldWidget(
                  hintText: "Search deals",
                  destinationScreen: const SearchResultScreen(),
                  autoFocus: true,
                  textValue: searchState.searchKey,
                  onSubmitted: () {
                    searchfieldSubmit(searchState.searchKey);
                  },
                ),
              ),
            ],
          );
        }),
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
                final authUserDataState = ref.watch(authUserDataProvider);
                if (authUserDataState.isAuthenticated == true) {
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
