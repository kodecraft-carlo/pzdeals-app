import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:pzdeals/src/common_widgets/category_image.dart';
import 'package:pzdeals/src/constants/color_constants.dart';
import 'package:pzdeals/src/constants/sizes.dart';
import 'package:pzdeals/src/features/deals/deals.dart';
import 'dart:io' show Platform;

class CollectionSelectionWidget extends ConsumerStatefulWidget {
  const CollectionSelectionWidget({super.key});

  @override
  _CollectionSelectionWidgetState createState() =>
      _CollectionSelectionWidgetState();
}

class _CollectionSelectionWidgetState
    extends ConsumerState<CollectionSelectionWidget>
    with TickerProviderStateMixin {
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this);
    Future(() {
      // ref.read(tabForYouProvider).loadCollections();
      ref.read(tabForYouProvider).resetCollectionMap();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final foryouState = ref.watch(tabForYouProvider);
    double screenWidth = MediaQuery.of(context).size.width;
    double itemWidth = screenWidth / 3;
    Widget body;

    if (foryouState.isLoading && foryouState.collections.isEmpty) {
      body = const Center(child: CircularProgressIndicator.adaptive());
    } else if (foryouState.collections.isEmpty) {
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
                'There are no deal collections available at the moment. Please check back later.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: Sizes.fontSizeMedium, color: PZColors.pzGrey),
              ),
            ],
          ));
    } else {
      final collectionData = foryouState.collections;
      body = GridView.builder(
        primary: false,
        padding: const EdgeInsets.all(Sizes.paddingAll),
        itemCount: collectionData.length,
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: itemWidth,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            childAspectRatio: 2 / 2.5),
        itemBuilder: (BuildContext context, int index) {
          final collection = collectionData[index];
          return GridItemWidget(
              containerChild: CategoryImageWidget(
                imageAsset: collection.imageAsset,
                sourceType: collection.assetSourceType,
              ),
              categoryLabel: collection.title,
              isSelected: foryouState.isCollectionIdExisting(collection.id),
              onTap: () {
                foryouState.toggleCollectionMap(
                    collection.id, collection.title);
              });
        },
      );
    }

    return SafeArea(
      top: false,
      bottom: Platform.isIOS ? false : true,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: PZColors.pzWhite,
          automaticallyImplyLeading: false,
          title: const Text(
            'Select Collection to show on \'For You\'',
            style: TextStyle(
              color: PZColors.pzBlack,
              fontWeight: FontWeight.w600,
              fontSize: Sizes.fontSizeMedium,
            ),
            textAlign: TextAlign.center,
          ),
          actions: [
            foryouState.collections.isEmpty
                ? IconButton(
                    icon: const Icon(Icons.close),
                    iconSize: Sizes.screenCloseIconSize,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                : const SizedBox(),
          ],
        ),
        body: body,
        bottomNavigationBar: foryouState.collections.isNotEmpty
            ? const BottomSheetWidget()
            : const SizedBox(),
      ),
    );
  }
}

class BottomSheetWidget extends StatelessWidget {
  const BottomSheetWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding:
          EdgeInsets.only(bottom: Platform.isIOS ? 5 : 0), // Keyboard padding
      margin: const EdgeInsets.all(Sizes.paddingAll),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Consumer(builder: (context, ref, child) {
                final foryouState = ref.watch(tabForYouProvider);
                return Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(Sizes.buttonBorderRadius),
                        ),
                        backgroundColor: PZColors.pzOrange,
                        minimumSize: const Size(150, 40),
                        elevation: Sizes.buttonElevation),
                    onPressed: foryouState.collectionsMap.isNotEmpty
                        ? () {
                            Navigator.of(context).pop();
                            foryouState.applySelectedCollections();
                            debugPrint('Apply Selection pressed');
                          }
                        : null,
                    child: const Text(
                      'Apply Selection',
                      style: TextStyle(color: PZColors.pzWhite),
                    ),
                  ),
                );
              }),
            ],
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                    color: PZColors.pzBlack, fontWeight: FontWeight.w600),
              ))
        ],
      ),
    );
  }
}

class GridItemWidget extends StatefulWidget {
  const GridItemWidget({
    super.key,
    required this.containerChild,
    required this.categoryLabel,
    required this.isSelected,
    required this.onTap,
  });

  final Widget containerChild;
  final String categoryLabel;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  _GridItemWidgetState createState() => _GridItemWidgetState();
}

class _GridItemWidgetState extends State<GridItemWidget>
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
            mainAxisSize:
                MainAxisSize.min, // Ensure the column takes minimum height
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(Sizes.containerBorderRadius),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.4),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                clipBehavior: Clip.hardEdge,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    widget.containerChild,
                    if (widget.isSelected)
                      SizedBox.square(
                        dimension: 80,
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                          child: Container(
                            color: PZColors.pzGreen.withOpacity(0.3),
                          ),
                        ),
                      ),
                    if (widget.isSelected)
                      const Icon(
                        Icons.check_circle_rounded,
                        color: PZColors.pzWhite,
                        size: 40.0,
                      ),
                  ],
                ),
              ),
              const SizedBox(
                height: Sizes.spaceBetweenContent,
              ),
              Text(
                widget.categoryLabel,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: widget.isSelected ? Colors.black : PZColors.pzBlack,
                ),
                textAlign: TextAlign.center,
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
