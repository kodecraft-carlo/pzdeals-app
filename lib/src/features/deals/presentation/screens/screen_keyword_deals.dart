import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:pzdeals/src/common_widgets/product_dialog.dart';
import 'package:pzdeals/src/common_widgets/products_display.dart';
import 'package:pzdeals/src/constants/index.dart';
import 'package:pzdeals/src/features/deals/models/index.dart';
import 'package:pzdeals/src/features/deals/presentation/widgets/product_deal_description.dart';
import 'package:pzdeals/src/features/deals/services/fetch_deals.dart';
import 'package:pzdeals/src/features/deals/state/provider_notificationdeals.dart';
import 'package:pzdeals/src/features/navigationwidget.dart';
import 'package:pzdeals/src/state/layout_type_provider.dart';

final notificationDealsProvider =
    ChangeNotifierProvider<NotificationDealsNotifier>(
        (ref) => NotificationDealsNotifier());

class KeywordDealsScreen extends ConsumerStatefulWidget {
  const KeywordDealsScreen({super.key});

  @override
  KeywordDealsScreenState createState() => KeywordDealsScreenState();
}

class KeywordDealsScreenState extends ConsumerState<KeywordDealsScreen>
    with TickerProviderStateMixin {
  FetchProductDealService productDealService = FetchProductDealService();

  late final AnimationController _animationController;
  final _scrollController = ScrollController(keepScrollOffset: false);
  String title = '';
  String keyword = '';
  String id = '';

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this);
    _scrollController.addListener(_onScroll);

    Future(() {
      final arguments = ModalRoute.of(context)!.settings.arguments;

      if (arguments != null && arguments is Map<String, dynamic>) {
        keyword = arguments['keyword'] as String;
        title = arguments['title'] as String;
        id = arguments['product_id'] as String;
        debugPrint('id: $id');
        ref.read(notificationDealsProvider).setDealType(keyword, 'keyword');
        if (id != '') {
          showProductDeal(int.parse(id));
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

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      ref.read(notificationDealsProvider).loadMoreProducts();
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
    final keywordDealsState = ref.watch(notificationDealsProvider);

    if (keywordDealsState.isLoading && keywordDealsState.products.isEmpty) {
      searchResultWidget = const Expanded(
          child: Center(child: CircularProgressIndicator.adaptive()));
    } else if (keywordDealsState.products.isEmpty) {
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
                'There are no deals available for this keyword. Please try again.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: Sizes.fontSizeMedium, color: PZColors.pzGrey),
              ),
            ],
          ),
        ),
      );
    } else {
      final productData = keywordDealsState.products;
      final layoutType = ref.watch(layoutTypeProvider);
      searchResultWidget = Flexible(
        child: ProductsDisplay(
          onRefresh: () async {
            // ref.read(notificationDealsProvider).refreshProducts();
          },
          productData: productData,
          layoutType: layoutType,
          scrollKey: 'keywordDealsScreen',
          scrollController: _scrollController,
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
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
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const NavigationWidget(
                          initialPageIndex: 0,
                        )));
          },
        ),
      ),
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Sizes.paddingAll),
          child: Text.rich(
            TextSpan(
              text: "Deals matching keyword '",
              style: const TextStyle(
                fontSize: Sizes.bodyFontSize,
                fontWeight: FontWeight.w500,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: keyword,
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
        searchResultWidget,
      ]),
    );
  }
}
