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
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: Sizes.paddingAllSmall,
          ),
          const Align(
            alignment: Alignment.center,
            child: Text(
              "This is a sample description of this tab",
              style: TextStyle(
                  color: Colors.black54, fontSize: Sizes.bodyFontSize),
            ),
          ),
          const ForYouBannerWidget(),
          Consumer(builder: (context, ref, _) {
            final foryouState = ref.watch(tabForYouProvider);

            final List<Map<String, dynamic>> dataMap =
                foryouState.collectionProducts;

            if (foryouState.isForYouCollectionProductsLoading &&
                dataMap.isEmpty) {
              // While data is loading
              return const Center(child: CircularProgressIndicator());
            } else {
              List<Widget> sectionContent = [];
              if (dataMap.isNotEmpty) {
                //check each collection if it has products
                sectionContent = dataMap.map((map) {
                  if (map['products'] != null) {
                    return FutureBuilder<List<ProductDealcardData>>(
                      future: map[
                          'products'], // Assuming map['products'] returns Future<List<ProductDealcardData>>
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          // While data is loading
                          return const SizedBox.shrink();
                        } else if (snapshot.hasError) {
                          // If any error occurs
                          return Text('Error: ${snapshot.error}');
                        } else {
                          // Data loaded successfully
                          final List<ProductDealcardData> productList =
                              snapshot.data!;
                          return ForYouCollectionList(
                            title: '${map['collection_name']} Deals',
                            collectionId: map['collection_id'],
                            productData: productList,
                          );
                        }
                      },
                    );
                  } else {
                    return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextWidget(
                              text: '${map['collection_name']} Deals',
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
                                    side: const BorderSide(
                                        color: PZColors.pzLightGrey,
                                        width: 1.0),
                                    borderRadius: BorderRadius.circular(
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
                                          controller: _animationController,
                                          onLoaded: (composition) {
                                            _animationController
                                              ..duration = composition.duration
                                              ..forward();
                                          },
                                        ),
                                        const SizedBox(
                                            height:
                                                Sizes.spaceBetweenContentSmall),
                                        Text(
                                          "There are no ${map['collection_name']} Deals available at the moment. Please check back later.",
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
                }).toList();
              }

              return Container(
                margin: const EdgeInsets.all(Sizes.paddingAll),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: sectionContent,
                ),
              );
            }
          }),
        ],
      ),
    );
  }
}
