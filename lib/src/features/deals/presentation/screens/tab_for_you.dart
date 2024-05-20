import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:pzdeals/src/actions/navigate_screen.dart';
import 'package:pzdeals/src/common_widgets/text_widget.dart';
import 'package:pzdeals/src/constants/index.dart';
import 'package:pzdeals/src/features/deals/deals.dart';
import 'package:pzdeals/src/features/deals/models/index.dart';
import 'package:pzdeals/src/features/deals/presentation/screens/screen_collection_selection.dart';
import 'package:pzdeals/src/features/deals/presentation/widgets/index.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ForYouWidget extends ConsumerStatefulWidget {
  const ForYouWidget({super.key});
  @override
  ForYouWidgetState createState() => ForYouWidgetState();
}

class ForYouWidgetState extends ConsumerState<ForYouWidget>
    with TickerProviderStateMixin {
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this);
    // Future(() {
    //   ref.read(tabForYouProvider).loadDataFromSelectedCollection();
    // });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final foryouState = ref.watch(tabForYouProvider);
    final List<Map<String, dynamic>> dataMap = foryouState.collectionProducts;

    List<Widget> sectionContent = [];
    if (dataMap.isNotEmpty) {
      //check each collection if it has products
      sectionContent = dataMap.map((map) {
        if (map['products'] != null) {
          return FutureBuilder<List<ProductDealcardData>>(
            future: map[
                'products'], // Assuming map['products'] returns Future<List<ProductDealcardData>>
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // While data is loading
                return const SizedBox.shrink();
              } else if (snapshot.hasError) {
                // If any error occurs
                return noForYouData(map['collection_name']);
              } else {
                if (snapshot.data == null || snapshot.data!.isEmpty) {
                  return noForYouData(map['collection_name']);
                }
                // Data loaded successfully
                final List<ProductDealcardData> productList = snapshot.data!;
                return ForYouCollectionList(
                  title: '${map['collection_name']} Deals',
                  collectionId: map['collection_id'],
                  productData: productList,
                );
              }
            },
          );
        } else {
          return noForYouData(map['collection_name']);
        }
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
                          child: foryouState.hasSelectedCollectionsFromCache
                              ? customizeHereLink()
                              : const SizedBox.shrink(),
                        )
                      ],
                    )),
              ),
              !foryouState.hasSelectedCollectionsFromCache
                  ? const ForYouBannerWidget()
                  : const SizedBox.shrink(),
              Skeletonizer(
                enabled: foryouState.isForYouCollectionProductsLoading,
                child: Container(
                  margin: const EdgeInsets.all(Sizes.paddingAll),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: sectionContent,
                  ),
                ),
              ),
            ],
          ),
        ),
        onRefresh: () async {
          await ref.read(tabForYouProvider).getProductsFromSelectedCollection();
        });
  }

  Widget noForYouData(String collectionName) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      TextWidget(
          text: '$collectionName Deals',
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
                      "There are no $collectionName Deals available at the moment. Please check back later.",
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

  Widget customizeHereLink() {
    return const NavigateScreenWidget(
        destinationWidget: CollectionSelectionWidget(),
        animationDirection: 'bottomToTop',
        childWidget: Text(
          'Customize Here',
          style: TextStyle(
              textBaseline: TextBaseline.alphabetic,
              color: PZColors.hyperlinkColor,
              fontSize: Sizes.bodyFontSize,
              fontStyle: FontStyle.italic),
          textAlign: TextAlign.center,
        ));
  }
}
