import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:pzdeals/src/common_widgets/custom_scaffold.dart';
import 'package:pzdeals/src/common_widgets/product_dialog.dart';
import 'package:pzdeals/src/common_widgets/products_display.dart';
import 'package:pzdeals/src/constants/index.dart';
import 'package:pzdeals/src/features/deals/models/index.dart';
import 'package:pzdeals/src/features/deals/presentation/widgets/index.dart';
import 'package:pzdeals/src/features/deals/services/fetch_collections.dart';
import 'package:pzdeals/src/features/deals/services/fetch_deals.dart';
import 'package:pzdeals/src/features/deals/state/provider_collections.dart';
import 'package:pzdeals/src/features/navigationwidget.dart';
import 'package:pzdeals/src/state/layout_type_provider.dart';

final productCollectionProvider =
    ChangeNotifierProvider<ProductCollectionNotifier>(
        (ref) => ProductCollectionNotifier());

class CollectionDisplayScreenWidget extends ConsumerStatefulWidget {
  const CollectionDisplayScreenWidget(
      {super.key,
      required this.collectionTitle,
      required this.collectionId,
      this.keyword = ""});

  final String collectionTitle;
  final int collectionId;
  final String keyword;

  @override
  CollectionDisplayScreenWidgetState createState() =>
      CollectionDisplayScreenWidgetState();
}

class CollectionDisplayScreenWidgetState
    extends ConsumerState<CollectionDisplayScreenWidget>
    with TickerProviderStateMixin {
  late final AnimationController _animationController;
  final _scrollController = ScrollController(keepScrollOffset: true);
  final FetchCollectionService collectionService = FetchCollectionService();
  final FetchProductDealService productDealService = FetchProductDealService();
  String paramcollectionName = '';
  String paramcollectionId = '';
  String keyword = '';
  String productId = '';

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this);
    _scrollController.addListener(_onScroll);
    Future(() {
      if (widget.collectionTitle != '' && widget.collectionId > 0) {
        ref.watch(productCollectionProvider).setBoxCollectionName(
            widget.collectionTitle,
            '${widget.collectionTitle.trim()}_${widget.collectionId}');
      }
    });

    Future(() {
      final arguments = ModalRoute.of(context)!.settings.arguments;
      if (arguments != null && arguments is Map<String, dynamic>) {
        keyword = arguments['value'] as String;
        productId = arguments['product_id'] as String;
        debugPrint('keyword: $keyword');
        if (keyword != '' && productId != '') {
          getCollectionIdAndName(keyword);
        }
      }
    });
  }

  void showProductDeal(int productId) {
    loadProduct(productId).then((product) {
      showDialog(
        context: context,
        useRootNavigator: false,
        barrierDismissible: true,
        builder: (context) => ScaffoldMessenger(
          child: Builder(
            builder: (context) => Scaffold(
              backgroundColor: Colors.transparent,
              body: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                behavior: HitTestBehavior.opaque,
                child: GestureDetector(
                  onTap: () {},
                  child: ProductContentDialog(
                    hasDescription: product.productDealDescription != null &&
                        product.productDealDescription != '',
                    productData: product,
                    content: ProductDealDescription(
                      snackbarContext: context,
                      productData: product,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  Future<ProductDealcardData> loadProduct(int productId) async {
    final product = await productDealService.fetchProductInfo(productId);
    return product;
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  bool _isLoading = false;

  void _onScroll() async {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (_isLoading) {
        return;
      }

      _isLoading = true;
      await ref.read(productCollectionProvider).loadMoreProducts();
      _isLoading = false;
    }
  }

  void scrollToTop() {
    _scrollController.animateTo(
      0.0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void getCollectionIdAndName(String keyword) async {
    final collectionData =
        await collectionService.fetchCollectionIdAndName(keyword);
    final explodedCollectionData = collectionData.split('~');
    paramcollectionId = explodedCollectionData[0];
    paramcollectionName = explodedCollectionData[1];

    debugPrint('collection name: $paramcollectionName');

    ref.read(productCollectionProvider).setBoxCollectionName(
        paramcollectionName,
        '${paramcollectionName.trim()}_$paramcollectionId');

    showProductDeal(int.parse(productId));
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('collectionTitle: ${widget.collectionTitle}');
    debugPrint('paramcollectionName: $paramcollectionName');
    final layoutType = ref.watch(layoutTypeProvider);
    final productCollectionState = ref.watch(productCollectionProvider);

    Widget body;
    if (productCollectionState.isLoading &&
        productCollectionState.products.isEmpty) {
      body = const Center(child: CircularProgressIndicator.adaptive());
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
      body = Stack(
        children: [
          Positioned.fill(
              child: ProductsDisplay(
            scrollController: _scrollController,
            productData: productData,
            layoutType: layoutType,
            onRefresh: () async {
              HapticFeedback.mediumImpact();
              productCollectionState.refreshDeals();
            },
          )),
          if (productCollectionState.isLoading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: Sizes.paddingAll),
              child: Align(
                  alignment: Alignment.topCenter,
                  child: CircularProgressIndicator.adaptive()),
            ),
        ],
      );
    }
    return CustomScaffoldWidget(
        scaffold: Scaffold(
          appBar: PreferredSize(
              preferredSize: const Size.fromHeight(kToolbarHeight),
              child: GestureDetector(
                onTap: () {
                  scrollToTop();
                },
                child: AppBar(
                  title: Text(
                    widget.collectionTitle != ''
                        ? widget.collectionTitle == 'Toys Deals'
                            ? 'Toy Deals'
                            : widget.collectionTitle
                        : paramcollectionName,
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
              )),
          body: body,
        ),
        scrollAction: scrollToTop);
  }
}
