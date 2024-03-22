import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:pzdeals/src/common_widgets/text_widget.dart';
import 'package:pzdeals/src/constants/index.dart';
import 'package:pzdeals/src/features/deals/deals.dart';
import 'package:pzdeals/src/features/deals/models/index.dart';
import 'package:pzdeals/src/features/deals/presentation/widgets/index.dart';
import 'package:pzdeals/src/features/deals/services/fetch_foryou.dart';

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
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final foryouState = ref.watch(tabForYouProvider);
    final FetchForYouService fetchForYouService = FetchForYouService();
    final List<Map<String, dynamic>> dataMap =
        foryouState.collectionsMap.isNotEmpty &&
                foryouState.isSelectionApplied == true
            ? foryouState.collectionsMap
            : foryouState.defaultCollections;
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ForYouBannerWidget(),
          Padding(
              padding: const EdgeInsets.all(Sizes.paddingAll),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (Map<String, dynamic> map in dataMap)
                    FutureBuilder(
                        future: fetchForYouService.fetchForYouDeals(
                            map['collection_id'], 4, map['collection_name']),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const SizedBox.shrink();
                          } else if (snapshot.hasError) {
                            return Container(
                                margin: const EdgeInsets.only(
                                  bottom: Sizes.marginBottom,
                                ),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      TextWidget(
                                          text:
                                              '${map['collection_name']} Deals',
                                          textDisplayType:
                                              TextDisplayType.sectionTitle),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Card(
                                              margin: const EdgeInsets.only(
                                                top: Sizes.marginTopSmall,
                                                bottom: Sizes.marginBottomSmall,
                                              ),
                                              color: PZColors.pzWhite,
                                              surfaceTintColor:
                                                  PZColors.pzWhite,
                                              elevation: 0,
                                              shape: RoundedRectangleBorder(
                                                side: const BorderSide(
                                                    color: PZColors.pzLightGrey,
                                                    width: 1.0),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        Sizes.cardBorderRadius),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.all(
                                                    Sizes.paddingAllSmall),
                                                child: Column(
                                                  children: [
                                                    Lottie.asset(
                                                      'assets/images/lottie/empty.json',
                                                      height: 120,
                                                      fit: BoxFit.fitHeight,
                                                      frameRate: FrameRate.max,
                                                      controller:
                                                          _animationController,
                                                      onLoaded: (composition) {
                                                        _animationController
                                                          ..duration =
                                                              composition
                                                                  .duration
                                                          ..forward();
                                                      },
                                                    ),
                                                    const SizedBox(
                                                        height: Sizes
                                                            .spaceBetweenContentSmall),
                                                    Text(
                                                      "There are no ${map['collection_name']} Deals available at the moment. Please check back later.",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: const TextStyle(
                                                          fontSize: Sizes
                                                              .fontSizeMedium,
                                                          color:
                                                              PZColors.pzGrey),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      )
                                    ]));
                          } else {
                            final List? productData = snapshot.data;
                            if (productData != null) {
                              return ForYouCollectionList(
                                title: '${map['collection_name']} Deals',
                                collectionId: map['collection_id'],
                                productData:
                                    productData as List<ProductDealcardData>,
                              );
                            } else {
                              return const SizedBox.shrink();
                            }
                          }
                        })
                ],
              )),
        ],
      ),
    );
  }
}
