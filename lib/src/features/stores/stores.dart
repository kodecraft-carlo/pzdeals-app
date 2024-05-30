import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pzdeals/src/common_widgets/sliver_appbar.dart';
import 'package:pzdeals/src/constants/index.dart';
import 'package:pzdeals/src/features/navigationwidget.dart';
import 'package:pzdeals/src/features/stores/presentation/screens/stores_display.dart';
import 'package:pzdeals/src/features/stores/presentation/widgets/index.dart';
import 'package:pzdeals/src/features/stores/state/stores_provider.dart';
import 'package:pzdeals/src/models/index.dart';
import 'package:pzdeals/src/utils/helpers/debouncer.dart';

class StoresWidget extends ConsumerStatefulWidget {
  const StoresWidget({super.key});

  @override
  StoresWidgetState createState() => StoresWidgetState();
}

class StoresWidgetState extends ConsumerState<StoresWidget> {
  final searchController = TextEditingController();
  final _scrollController = ScrollController();
  final _debouncer = Debouncer(delay: const Duration(milliseconds: 300));
  final GlobalKey<NestedScrollViewState> globalKeyStoresNestedScroll =
      GlobalKey<NestedScrollViewState>();

  final StoreData pzDeals = StoreData(
      id: 0,
      handle: 'pzdeals',
      storeName: Wordings.appName,
      storeAssetImage: 'assets/images/pzdeals_store.png',
      assetSourceType: 'asset');

  void _onTextChanged(String text) {
    _debouncer.run(() {
      filterStores(text);
    });
  }

  void filterStores(String query) {
    ref.read(storescreenProvider).filterStores(query);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void scrollToTop() {
    globalKeyStoresNestedScroll.currentState?.innerController.animateTo(
      0.0, // Scroll to the top of the list
      duration:
          const Duration(milliseconds: 300), // Adjust the duration as needed
      curve: Curves.easeInOut, // Adjust the curve as needed
    );
    globalKeyStoresNestedScroll.currentState?.outerController.animateTo(
      0.0, // Scroll to the top of the list
      duration:
          const Duration(milliseconds: 300), // Adjust the duration as needed
      curve: Curves.easeInOut, // Adjust the curve as needed
    );
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('store screen build');
    return PopScope(
        canPop: false,
        onPopInvoked: (didPop) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const NavigationWidget(
                        initialPageIndex: 0,
                      )));
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: NestedScrollView(
            key: globalKeyStoresNestedScroll,
            controller: _scrollController,
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBarWidget(
                    innerBoxIsScrolled: innerBoxIsScrolled,
                    searchFieldWidget: StoreSearchFieldWidget(
                      hintText: "Search store",
                      filterStores: _onTextChanged,
                      storeNames: ref.watch(storescreenProvider
                          .select((value) => value.storeNames)),
                      searchController: searchController,
                    )),
                const SliverToBoxAdapter(
                  child: Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: Sizes.paddingAll,
                          right: Sizes.paddingAll,
                          top: Sizes.paddingAllSmall),
                      child: Text(
                        Wordings.descStoreScreen,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black54,
                            fontSize: Sizes.bodyFontSize),
                      ),
                    ),
                  ),
                )
              ];
            },
            body: DisplayStores(searchController: searchController),
          ),
        ));
  }
}
