import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:pzdeals/src/common_widgets/sliver_appbar.dart';
import 'package:pzdeals/src/constants/index.dart';
import 'package:pzdeals/src/features/navigationwidget.dart';
import 'package:pzdeals/src/features/stores/presentation/screens/stores_display.dart';
import 'package:pzdeals/src/features/stores/presentation/widgets/index.dart';
import 'package:pzdeals/src/features/stores/state/stores_provider.dart';
import 'package:pzdeals/src/utils/helpers/debouncer.dart';

class StoresWidget extends ConsumerStatefulWidget {
  const StoresWidget({super.key});

  @override
  _StoresWidgetState createState() => _StoresWidgetState();
}

class _StoresWidgetState extends ConsumerState<StoresWidget>
    with TickerProviderStateMixin {
  // late List<StoreData> filteredStores;
  late TextEditingController searchController;
  late final AnimationController _animationController;
  final _scrollController = ScrollController();
  final _debouncer = Debouncer(delay: const Duration(milliseconds: 300));

  void _onTextChanged(String text) {
    _debouncer.run(() {
      filterStores(text);
    });
  }

  void filterStores(String query) {
    ref.read(storescreenProvider).filterStores(query);
  }

  @override
  void initState() {
    super.initState();
    // filteredStores = [];
    searchController = TextEditingController();
    _scrollController.addListener(_onScroll);
    _animationController = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    searchController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  // void filterStores(String query) {
  //   setState(() {
  //     filteredStores = ref
  //         .read(storescreenProvider)
  //         .stores
  //         .where((store) =>
  //             store.storeName.toLowerCase().contains(query.toLowerCase()))
  //         .toList();
  //   });
  // }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      debugPrint('loading more stores');
      ref.read(storescreenProvider).loadMoreStores();
    }
  }

  @override
  Widget build(BuildContext context) {
    final storescreenState = ref.watch(storescreenProvider);
    Widget body;

    if (storescreenState.isLoading && storescreenState.stores.isEmpty) {
      body = const Center(
        child: CircularProgressIndicator.adaptive(),
      );
    } else if (storescreenState.stores.isEmpty) {
      body = Padding(
          padding: const EdgeInsets.all(Sizes.paddingAll),
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
                'There are no stores available at the moment. Please check back later.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: Sizes.fontSizeMedium, color: PZColors.pzGrey),
              ),
            ],
          ));
    } else {
      final displayStores = storescreenState.filteredStores.isNotEmpty
          ? storescreenState.filteredStores
          : storescreenState.stores;
      body = RefreshIndicator.adaptive(
          color: PZColors.pzOrange,
          child: DisplayStores(
            scrollController: _scrollController,
            storedata: displayStores,
          ),
          onRefresh: () => storescreenState.refreshStores());
    }
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
          body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBarWidget(
                    innerBoxIsScrolled: innerBoxIsScrolled,
                    searchFieldWidget: StoreSearchFieldWidget(
                      hintText: "Search store",
                      filterStores: _onTextChanged,
                      storeNames: storescreenState.storeNames,
                      searchController: searchController,
                    )),
                SliverToBoxAdapter(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "This is a sample description of store page",
                      style: TextStyle(
                          color: Colors.black54, fontSize: Sizes.bodyFontSize),
                    ),
                  ),
                )
              ];
            },
            body: body,
          ),
        ));
  }
}
