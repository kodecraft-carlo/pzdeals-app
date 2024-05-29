import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:pzdeals/src/common_widgets/scrollbar.dart';
import 'package:pzdeals/src/constants/index.dart';
import 'package:pzdeals/src/features/stores/presentation/widgets/index.dart';
import 'package:pzdeals/src/features/stores/state/stores_provider.dart';
import 'package:pzdeals/src/models/index.dart';

class DisplayStores extends ConsumerStatefulWidget {
  const DisplayStores({super.key, required this.searchController});

  final TextEditingController searchController;
  @override
  _DisplayStoresState createState() => _DisplayStoresState();
}

class _DisplayStoresState extends ConsumerState<DisplayStores>
    with TickerProviderStateMixin {
  late final AnimationController _animationController;
  final _scrollController = ScrollController();
  final StoreData pzDeals = StoreData(
      id: 0,
      handle: 'pzdeals',
      storeName: Wordings.appName,
      storeAssetImage: 'assets/images/pzdeals_store.png',
      assetSourceType: 'asset');

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_onScroll);
    _animationController = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      debugPrint('loading more stores');
      ref.read(storescreenProvider).loadMoreStores();
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double itemWidth = screenWidth / 4;
    final storeState = ref.watch(storescreenProvider);

    Widget body;

    debugPrint('stores display build');
    if (storeState.isLoading && storeState.stores.isEmpty) {
      body = const Center(
        child: CircularProgressIndicator.adaptive(),
      );
    } else if (storeState.stores.isEmpty) {
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
      final displayStores = storeState.filteredStores.isNotEmpty
          ? storeState.filteredStores
          : storeState.stores;

      if (widget.searchController.text.isEmpty) {
        if (displayStores[0].id != 0) {
          displayStores.insert(0, pzDeals);
        }
      }

      body = RefreshIndicator.adaptive(
          color: PZColors.pzOrange,
          child: ScrollbarWidget(
              scrollController: _scrollController,
              child: GridView.builder(
                padding: const EdgeInsets.all(Sizes.paddingAll),
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: itemWidth,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 15,
                    childAspectRatio: 2 / 3),
                itemCount: displayStores.length,
                itemBuilder: (context, index) {
                  if (displayStores.isNotEmpty) {
                    final store = displayStores[index];
                    return StoreCardWidget(storeData: store);
                  } else {
                    // Return an empty container if storedata is empty
                    return Container();
                  }
                },
              )),
          onRefresh: () async {
            HapticFeedback.mediumImpact();
            ref.read(storescreenProvider).refreshStores();
          });
    }

    return body;
  }
}
