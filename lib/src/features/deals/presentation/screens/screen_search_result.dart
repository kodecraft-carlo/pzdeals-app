import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:pzdeals/src/common_widgets/products_display.dart';
import 'package:pzdeals/src/common_widgets/search_field.dart';
import 'package:pzdeals/src/constants/index.dart';
import 'package:pzdeals/src/features/deals/presentation/screens/screen_search_deals.dart';
import 'package:pzdeals/src/features/deals/presentation/widgets/index.dart';
import 'package:pzdeals/src/features/deals/state/provider_filters.dart';
import 'package:pzdeals/src/features/deals/state/provider_search.dart';

final searchFilterProvider = ChangeNotifierProvider<SearchFilterNotifier>(
    (ref) => SearchFilterNotifier());

class SearchResultScreen extends ConsumerStatefulWidget {
  const SearchResultScreen({
    super.key,
    this.searchKey = '',
  });

  final String searchKey;
  @override
  SearchResultScreenState createState() => SearchResultScreenState();
}

class SearchResultScreenState extends ConsumerState<SearchResultScreen>
    with TickerProviderStateMixin {
  late final AnimationController _animationController;
  final _scrollController = ScrollController(keepScrollOffset: false);
  late String? textFieldValue;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this);
    _scrollController.addListener(_onScroll);
    Future(() {
      ref.read(searchproductProvider).setFilters('');
      ref.read(searchproductProvider).setSearchKey(widget.searchKey);
      ref.read(searchFilterProvider).resetFilter();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      ref.read(searchproductProvider).loadMoreProducts();
    }
  }

  void scrollToTop() {
    _scrollController.animateTo(
      0.0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget searchResultWidget;

    final searchState = ref.watch(searchproductProvider);
    final searchFilterState = ref.watch(searchFilterProvider);
    final searchValue =
        searchState.searchKey != '' ? searchState.searchKey : widget.searchKey;

    if (searchState.isLoading && searchState.products.isEmpty) {
      searchResultWidget = const Center(
          child: CircularProgressIndicator(color: PZColors.pzOrange));
    } else if (searchState.products.isEmpty) {
      searchResultWidget = Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Sizes.paddingAll),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Lottie.asset(
                'assets/images/lottie/empty.json',
                height: 200,
                fit: BoxFit.fitHeight,
                frameRate: FrameRate.max,
                controller: _animationController,
                onLoaded: (composition) {
                  _animationController
                    ..duration = composition.duration
                    ..forward();
                },
              ),
              const SizedBox(height: Sizes.spaceBetweenSections),
              const Text(
                'There are no deals available for this search. Please try again.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: Sizes.fontSizeMedium, color: PZColors.pzGrey),
              ),
            ],
          ),
        ),
      );
    } else {
      final productData = searchState.products;
      searchResultWidget = Flexible(
        child: ProductsDisplay(
          productData: productData,
          layoutType: 'grid',
          scrollKey: 'searchResult',
          scrollController: _scrollController,
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: PZColors.pzWhite,
        surfaceTintColor: PZColors.pzWhite,
        title: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const SearchDealScreen())),
              child: const Icon(Icons.arrow_back_ios_new),
            ),
            const SizedBox(width: Sizes.spaceBetweenContent),
            Expanded(
              child: SearchFieldWidget(
                hintText: "Search deals",
                textValue: searchValue,
                autoFocus: false,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
              padding: const EdgeInsets.only(right: Sizes.paddingRight),
              child: GestureDetector(
                onTap: () {
                  if (!searchFilterState.isFilterApplied) {
                    ref.read(searchFilterProvider).resetFilter();
                  }
                  showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      enableDrag: true,
                      showDragHandle: true,
                      useSafeArea: true,
                      builder: (context) => buildSheet(context));
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    searchFilterState.isFilterApplied
                        ? const Icon(
                            Icons.filter_alt,
                            color: PZColors.pzOrange,
                          )
                        : const Icon(
                            Icons.filter_alt_outlined,
                            color: PZColors.pzOrange,
                          ),
                    const Text(
                      "Filter",
                      style: TextStyle(
                          color: PZColors.pzOrange,
                          fontSize: Sizes.fontSizeXSmall,
                          fontWeight: FontWeight.w400),
                    )
                  ],
                ),
              )),
        ],
      ),
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Sizes.paddingAll),
          child: Text.rich(
            TextSpan(
              text: "Search result for '",
              style: const TextStyle(
                fontSize: Sizes.bodyFontSize,
                fontWeight: FontWeight.w500,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: searchValue,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontStyle: FontStyle.italic),
                ),
                const TextSpan(
                  text: "'",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: Sizes.spaceBetweenContent),
        if (searchFilterState.isFilterApplied)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Sizes.paddingAll),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  searchFilterState.selectedStoreIds.isNotEmpty
                      ? const Text(
                          "Store: ",
                          style: TextStyle(
                            fontSize: Sizes.bodyFontSize,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      : const SizedBox(),
                  searchFilterState.selectedStoreIds.isNotEmpty
                      ? Text(
                          searchFilterState.selectedStoreIds
                              .map((map) => map['store_name'] as String)
                              .join(', '),
                          style: const TextStyle(
                            fontSize: Sizes.bodyFontSize,
                          ),
                        )
                      : const SizedBox(),
                  searchFilterState.selectedCollectionIds.isNotEmpty &&
                          searchFilterState.selectedStoreIds.isNotEmpty
                      ? const Text(" & ",
                          style: TextStyle(
                            fontSize: Sizes.bodyFontSize,
                            fontWeight: FontWeight.w500,
                          ))
                      : const SizedBox(),
                  searchFilterState.selectedCollectionIds.isNotEmpty
                      ? const Text(
                          "Collection: ",
                          style: TextStyle(
                            fontSize: Sizes.bodyFontSize,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      : const SizedBox(),
                  searchFilterState.selectedCollectionIds.isNotEmpty
                      ? Text(
                          searchFilterState.selectedCollectionIds
                              .map((map) => map['collection_name'] as String)
                              .join(', '),
                          style: const TextStyle(
                            fontSize: Sizes.bodyFontSize,
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
            ),
          ),
        const SizedBox(height: Sizes.spaceBetweenSections),
        searchResultWidget,
      ]),
    );
  }
}
