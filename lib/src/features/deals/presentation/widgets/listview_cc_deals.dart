import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pzdeals/src/actions/navigate_screen.dart';
import 'package:pzdeals/src/constants/color_constants.dart';
import 'package:pzdeals/src/constants/sizes.dart';
import 'package:pzdeals/src/features/deals/deals.dart';
import 'package:pzdeals/src/features/deals/presentation/screens/index.dart';
import 'package:pzdeals/src/features/deals/presentation/widgets/index.dart';
import 'package:pzdeals/src/features/deals/services/fetch_creditcards.dart';

class CreditCardDealsWidget extends ConsumerWidget {
  const CreditCardDealsWidget({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final creditcardState = ref.watch(creditcardsProvider);
    final FetchCreditCardsDealService fetchCreditCardsDealService =
        FetchCreditCardsDealService();
    return Container(
      color: PZColors.pzLightGrey,
      padding: const EdgeInsets.only(
        top: Sizes.containerPaddingTop,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.only(
              left: Sizes.paddingLeft,
              right: Sizes.paddingRight,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Credit Cards',
                  style: TextStyle(
                    fontSize: Sizes.bodyFontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                creditcardState.creditcards.isEmpty
                    ? const SizedBox()
                    : const Expanded(
                        child: NavigateScreenWidget(
                            destinationWidget: CreditCardDealsScreen(),
                            animationDirection: 'leftToRight',
                            childWidget: Text('View more >',
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  fontSize: Sizes.bodyFontSize,
                                  color: PZColors.pzOrange,
                                  fontWeight: FontWeight.w600,
                                ))),
                      ),
              ],
            ),
          ),
          const SizedBox(height: Sizes.spaceBetweenContent),
          Column(
            children: [
              FutureBuilder(
                future: fetchCreditCardsDealService.fetchBannerCreditCardDeals(
                    1, 5),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                        child: CircularProgressIndicator.adaptive());
                  } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    return Padding(
                      padding: const EdgeInsets.only(
                          left: Sizes.paddingLeft, right: Sizes.paddingRight),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            for (int i = 0; i < snapshot.data!.length; i++)
                              CreditCardItem(
                                displayType: 'listView',
                                creditCardDealData: snapshot.data![i],
                              ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return const Center(
                        child: Text(
                      'There are no deals available at the moment. Please check back later.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: Sizes.fontSizeSmall,
                          color: PZColors.pzGrey),
                    ));
                  }
                },
              ),

              // if (creditcardState.isLoading &&
              //     creditcardState.creditcards.isEmpty)
              //   const Center(
              //       child: CircularProgressIndicator(color: PZColors.pzOrange))
              // else if (creditcardState.creditcards.isEmpty)
              //   const Center(
              //       child: Text(
              //     'There are no deals available at the moment. Please check back later.',
              //     textAlign: TextAlign.center,
              //     style: TextStyle(
              //         fontSize: Sizes.fontSizeMedium, color: PZColors.pzGrey),
              //   ))
              // else
              //   Padding(
              //     padding: const EdgeInsets.only(
              //         left: Sizes.paddingLeft, right: Sizes.paddingRight),
              //     child: SingleChildScrollView(
              //       scrollDirection: Axis.horizontal,
              //       child: Row(
              //         mainAxisSize: MainAxisSize.min,
              //         children: [
              //           for (int i = 0;
              //               i < creditcardState.creditcards.length;
              //               i++)
              //             CreditCardItem(
              //               displayType: 'listView',
              //               creditCardDealData: creditcardState.creditcards[i],
              //             ),
              //         ],
              //       ),
              //     ),
              //   ),
            ],
          ),
          const SizedBox(height: Sizes.spaceBetweenContent),
        ],
      ),
    );
  }
}
