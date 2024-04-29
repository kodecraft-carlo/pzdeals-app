import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pzdeals/src/constants/index.dart';
import 'package:pzdeals/src/features/deals/presentation/screens/screen_search_result.dart';

class FilterByStoresWidget extends ConsumerStatefulWidget {
  const FilterByStoresWidget({super.key});

  @override
  _FilterByStoresWidgetState createState() => _FilterByStoresWidgetState();
}

class _FilterByStoresWidgetState extends ConsumerState<FilterByStoresWidget>
    with TickerProviderStateMixin {
  bool isExpanded = false;
  final _scrollController = ScrollController(keepScrollOffset: true);

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      ref.read(searchFilterProvider).loadMoreStores();
    }
  }

  @override
  Widget build(BuildContext context) {
    final searchFilterState = ref.watch(searchFilterProvider);
    double screenWidth = MediaQuery.of(context).size.width;
    double itemWidth = screenWidth / 3;

    return Column(
      children: [
        if (searchFilterState.isStoreLoading &&
            searchFilterState.stores.isEmpty)
          const Center(child: CircularProgressIndicator.adaptive()),
        if (searchFilterState.stores.isEmpty)
          const Center(child: Text('No stores found')),
        if (searchFilterState.stores.isNotEmpty)
          GridView.builder(
            controller: _scrollController,
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: itemWidth,
                crossAxisSpacing: 10,
                mainAxisSpacing: 2,
                childAspectRatio: 1.9),
            itemCount: searchFilterState.stores.length > 9 && !isExpanded
                ? 9
                : searchFilterState.stores.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              final store = searchFilterState.stores[index];
              return StoreItemWidget(
                  containerChild: Card(
                    clipBehavior: Clip.hardEdge,
                    elevation: 0,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: Align(
                        alignment: Alignment.center,
                        child: storeFilterImage(store.imageUrl),
                      ),
                    ),
                  ),
                  isSelected: searchFilterState.isStoreIdExisting(store.id),
                  onTap: () {
                    searchFilterState.toggleStoreMap(
                        store.id, store.tagName, store.title);
                  });
            },
          ),
        if (searchFilterState.stores.length > 6)
          if (!isExpanded)
            TextButton(
              onPressed: () {
                searchFilterState.loadMoreStores();
                setState(() {
                  isExpanded = true;
                });
              },
              style: TextButton.styleFrom(
                  enableFeedback: false, splashFactory: NoSplash.splashFactory),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Show more',
                    style: TextStyle(
                        color: PZColors.pzBlack, fontSize: Sizes.fontSizeSmall),
                  ),
                  Icon(Icons.expand_more, color: PZColors.pzBlack)
                ],
              ),
            ),
        if (isExpanded)
          TextButton(
            onPressed: () {
              setState(() {
                isExpanded = false;
              });
            },
            style: TextButton.styleFrom(
                enableFeedback: false, splashFactory: NoSplash.splashFactory),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Show less',
                  style: TextStyle(
                      color: PZColors.pzBlack, fontSize: Sizes.fontSizeSmall),
                ),
                Icon(Icons.expand_less, color: PZColors.pzBlack)
              ],
            ),
          ),
      ],
    );
  }

  Widget storeFilterImage(String imageUrl) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fadeInDuration: const Duration(milliseconds: 100),
      fit: BoxFit.contain,
      cacheKey: Key(imageUrl.trim()).toString(),
      height: 30,
      errorWidget: (context, url, error) {
        debugPrint('Error loading image: $error');
        return ClipRRect(
          borderRadius: BorderRadius.circular(Sizes.containerBorderRadius),
          child: Image.asset(
            'assets/images/pzdeals.png',
            fit: BoxFit.fitHeight,
          ),
        );
      },
      imageBuilder: (context, imageProvider) {
        Image image = Image(image: imageProvider);
        int width = (image.width ?? 0).toInt();
        int height = (image.height ?? 0).toInt();
        bool isSquare = width == height;

        if (isSquare) {
          return Transform.scale(
            scale: 1.875,
            child: image,
          );
        } else {
          return image;
        }
      },
    );
  }
}

class StoreItemWidget extends StatefulWidget {
  const StoreItemWidget({
    super.key,
    required this.containerChild,
    required this.isSelected,
    required this.onTap,
  });

  final Widget containerChild;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  _StoreItemWidgetState createState() => _StoreItemWidgetState();
}

class _StoreItemWidgetState extends State<StoreItemWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap();
        _handleScaleAnimation();
      },
      child: IntrinsicHeight(
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: widget.isSelected
                      ? Border.all(color: PZColors.pzGreen, width: 2)
                      : Border.all(color: PZColors.pzGrey, width: 1),
                ),
                clipBehavior: Clip.hardEdge,
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    widget.containerChild,
                    if (widget.isSelected)
                      // SizedBox(
                      //   child: BackdropFilter(
                      //     filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                      //     child: Container(
                      //       color: PZColors.pzGreen.withOpacity(0.3),
                      //     ),
                      //   ),
                      // ),
                      if (widget.isSelected)
                        const Icon(
                          Icons.check_circle_rounded,
                          color: PZColors.pzGreen,
                          size: 15.0,
                        ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleScaleAnimation() {
    if (widget.isSelected) {
      _animationController.reverse(from: 1.0);
    } else {
      _animationController.forward(from: 0.0);
    }
  }
}
