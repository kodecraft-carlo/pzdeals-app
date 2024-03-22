import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:pzdeals/src/common_widgets/products_display.dart';
import 'package:pzdeals/src/constants/index.dart';
import 'package:pzdeals/src/features/deals/state/provider_collections.dart';
import 'package:pzdeals/src/state/layout_type_provider.dart';

final productCollectionProvider =
    ChangeNotifierProvider<ProductCollectionNotifier>(
        (ref) => ProductCollectionNotifier());

class CollectionDisplayScreenWidget extends ConsumerStatefulWidget {
  const CollectionDisplayScreenWidget(
      {super.key, required this.collectionTitle, required this.collectionId});

  final String collectionTitle;
  final int collectionId;

  @override
  CollectionDisplayScreenWidgetState createState() =>
      CollectionDisplayScreenWidgetState();
}

class CollectionDisplayScreenWidgetState
    extends ConsumerState<CollectionDisplayScreenWidget>
    with TickerProviderStateMixin {
  late final AnimationController _animationController;
  final _scrollController = ScrollController(keepScrollOffset: true);

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this);
    _scrollController.addListener(_onScroll);
    Future(() => ref.watch(productCollectionProvider).setBoxCollectionName(
        widget.collectionTitle,
        '${widget.collectionTitle.trim()}_${widget.collectionId}'));
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
      ref.read(productCollectionProvider).loadMoreProducts();
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
    final layoutType = ref.watch(layoutTypeProvider);
    final productCollectionState = ref.watch(productCollectionProvider);
    Widget body;
    if (productCollectionState.isLoading &&
        productCollectionState.products.isEmpty) {
      body = const Center(
          child: CircularProgressIndicator(color: PZColors.pzOrange));
    } else if (productCollectionState.products.isEmpty) {
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
              Text(
                'There are no ${widget.collectionTitle} available at the moment. Please check back later.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: Sizes.fontSizeMedium, color: PZColors.pzGrey),
              ),
            ],
          ));
    } else {
      final productData = productCollectionState.products;
      body = Column(
        children: [
          Expanded(
              child: ProductsDisplay(
            scrollController: _scrollController,
            productData: productData,
            layoutType: layoutType,
          )),
          if (productCollectionState.isLoading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: Sizes.paddingAll),
              child: Center(
                  child: CircularProgressIndicator(color: PZColors.pzOrange)),
            ),
        ],
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.collectionTitle,
          style: const TextStyle(
            color: PZColors.pzBlack,
            fontWeight: FontWeight.w700,
            fontSize: Sizes.appBarFontSize,
          ),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        surfaceTintColor: PZColors.pzWhite,
        backgroundColor: PZColors.pzWhite,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: body,
    );
  }
}
