import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:pzdeals/src/actions/navigate_screen.dart';
import 'package:pzdeals/src/common_widgets/text_widget.dart';
import 'package:pzdeals/src/constants/index.dart';
import 'package:pzdeals/src/features/deals/deals.dart';
import 'package:pzdeals/src/features/deals/models/index.dart';
import 'package:pzdeals/src/features/deals/presentation/screens/screen_collection_selection.dart';
import 'package:pzdeals/src/features/deals/presentation/widgets/index.dart';
import 'package:pzdeals/src/features/deals/services/fetch_foryou.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ForYouWidget extends ConsumerStatefulWidget {
  const ForYouWidget(
      {super.key, required this.tabController, required this.dealsKey});
  final TabController tabController;
  final GlobalKey<NestedScrollViewState> dealsKey;
  @override
  ForYouWidgetState createState() => ForYouWidgetState();
}

class ForYouWidgetState extends ConsumerState<ForYouWidget>
    with AutomaticKeepAliveClientMixin {
  final FetchForYouService forYouService = FetchForYouService();
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final forYouState = ref
        .watch(tabForYouProvider.select((value) => value.collectionProducts));

    List<Widget> sectionContent = [];
    if (forYouState.isNotEmpty) {
      sectionContent = forYouState.map((map) {
        return FutureBuilder<List<ProductDealcardData>>(
          future: forYouService.fetchForYouDeals(
              map['collection_id'], 30, map['collection_name']),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Skeletonizer(
                enabled: true,
                child: ForYouCollectionList(
                    collectionId: 0,
                    title: 'Collection Title',
                    productData: List.filled(
                        5,
                        ProductDealcardData(
                            productId: 0,
                            productName: 'Product Name In For You Collection',
                            price: '0.00',
                            storeAssetImage: 'assets/images/pzdeals_store.png',
                            oldPrice: '0.00',
                            imageAsset: 'assets/images/pzdeals.png',
                            discountPercentage: 0,
                            assetSourceType: 'asset',
                            barcodeLink: 'loading'))),
              );
            } else if (snapshot.hasError) {
              return NoForYouData(collectionName: map['collection_name']);
            } else {
              if (snapshot.data == null || snapshot.data!.isEmpty) {
                return NoForYouData(collectionName: map['collection_name']);
              }
              final List<ProductDealcardData> productList = snapshot.data!;
              return ForYouCollectionList(
                title: '${map['collection_name']} Deals',
                collectionId: map['collection_id'],
                productData: productList,
              );
            }
          },
        );
      }).toList();
    }
    return RefreshIndicator.adaptive(
        color: PZColors.pzOrange,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: Sizes.paddingAllSmall,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: Sizes.paddingAll),
                child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        const TextSpan(
                          text: Wordings.descForYou,
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              color: Colors.black54,
                              fontSize: Sizes.bodyFontSize),
                        ),
                        const TextSpan(text: ' '),
                        WidgetSpan(
                          child: ref.watch(tabForYouProvider.select((value) =>
                                  value.hasSelectedCollectionsFromCache))
                              ? const CustomizeHereLink()
                              : const SizedBox.shrink(),
                        )
                      ],
                    )),
              ),
              !ref.watch(tabForYouProvider
                      .select((value) => value.hasSelectedCollectionsFromCache))
                  ? const ForYouBannerWidget()
                  : const SizedBox.shrink(),
              Container(
                margin: const EdgeInsets.all(Sizes.paddingAll),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: sectionContent,
                ),
              )
            ],
          ),
        ),
        onRefresh: () async {
          await widget.dealsKey.currentState?.innerController.animateTo(
            -10.0,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOut,
          );

          if (widget.tabController.index == 0) {
            HapticFeedback.mediumImpact();
            await ref
                .read(tabForYouProvider)
                .getProductsFromSelectedCollection();
          }
        });
  }
}

class NoForYouData extends StatefulWidget {
  const NoForYouData({super.key, required this.collectionName});

  final String collectionName;
  @override
  _NoForYouDataState createState() => _NoForYouDataState();
}

class _NoForYouDataState extends State<NoForYouData>
    with TickerProviderStateMixin {
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      TextWidget(
          text: '${widget.collectionName} Deals',
          textDisplayType: TextDisplayType.sectionTitle),
      Row(
        children: [
          Expanded(
            child: Card(
              margin: const EdgeInsets.only(
                top: Sizes.marginTopSmall,
                bottom: Sizes.marginBottomSmall,
              ),
              color: PZColors.pzWhite,
              surfaceTintColor: PZColors.pzWhite,
              elevation: 0,
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: PZColors.pzLightGrey, width: 1.0),
                borderRadius: BorderRadius.circular(Sizes.cardBorderRadius),
              ),
              child: Padding(
                padding: const EdgeInsets.all(Sizes.paddingAllSmall),
                child: Column(
                  children: [
                    Lottie.asset(
                      'assets/images/lottie/empty.json',
                      height: 120,
                      fit: BoxFit.fitHeight,
                      frameRate: FrameRate.max,
                      controller: _animationController,
                      onLoaded: (composition) {
                        _animationController
                          ..duration = composition.duration
                          ..forward();
                      },
                    ),
                    const SizedBox(height: Sizes.spaceBetweenContentSmall),
                    Text(
                      "There are no ${widget.collectionName} Deals available at the moment. Please check back later.",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: Sizes.fontSizeMedium,
                          color: PZColors.pzGrey),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      )
    ]);
  }
}

class CustomizeHereLink extends StatelessWidget {
  const CustomizeHereLink({super.key});

  @override
  Widget build(BuildContext context) {
    return const NavigateScreenWidget(
        destinationWidget: CollectionSelectionWidget(),
        animationDirection: 'bottomToTop',
        childWidget: Text(
          'Tap to change',
          style: TextStyle(
              textBaseline: TextBaseline.alphabetic,
              color: PZColors.hyperlinkColor,
              fontSize: Sizes.bodyFontSize,
              fontStyle: FontStyle.italic),
          textAlign: TextAlign.center,
        ));
  }
}
