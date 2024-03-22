import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pzdeals/src/common_widgets/text_widget.dart';
import 'package:pzdeals/src/constants/color_constants.dart';
import 'package:pzdeals/src/constants/sizes.dart';
import 'package:pzdeals/src/features/deals/deals.dart';
import 'package:pzdeals/src/features/deals/presentation/widgets/card_cc_deal.dart';

class CreditCardDealsScreen extends ConsumerStatefulWidget {
  const CreditCardDealsScreen({super.key});
  @override
  CreditCardDealsScreenState createState() => CreditCardDealsScreenState();
}

class CreditCardDealsScreenState extends ConsumerState<CreditCardDealsScreen>
    with TickerProviderStateMixin {
  late final AnimationController _animationController;
  final GlobalKey<NestedScrollViewState> globalKey = GlobalKey();

  final _scrollController = ScrollController(keepScrollOffset: true);

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _animationController = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      debugPrint("reach the end of the list");
      ref.read(creditcardsProvider).loadMoreCreditCards();
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
    final creditcardState = ref.watch(creditcardsProvider);
    return Scaffold(
      appBar: AppBar(
        title: const TextWidget(
          text: "Latest Credit Card Deals",
          textDisplayType: TextDisplayType.appbarTitle,
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
      body: SingleChildScrollView(
          controller: _scrollController,
          child: Padding(
            padding: const EdgeInsets.only(
              left: Sizes.paddingLeft,
              right: Sizes.paddingRight,
              bottom: Sizes.paddingBottom,
            ),
            child: Column(
              children: [
                if (creditcardState.isLoading &&
                    creditcardState.creditcards.isEmpty)
                  const Center(
                      child:
                          CircularProgressIndicator(color: PZColors.pzOrange))
                else if (creditcardState.creditcards.isEmpty)
                  const Center(
                      child: Text(
                    'There are no credit card deals available at the moment. Please check back later.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: Sizes.fontSizeMedium, color: PZColors.pzGrey),
                  ))
                else
                  for (int i = 0; i < creditcardState.creditcards.length; i++)
                    CreditCardItem(
                      displayType: 'scrollView',
                      creditCardDealData: creditcardState.creditcards[i],
                    ),
                const SizedBox(height: Sizes.spaceBetweenContent),
                if (creditcardState.isLoading)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: Sizes.paddingAll),
                    child: Center(
                        child: CircularProgressIndicator(
                            color: PZColors.pzOrange)),
                  )
              ],
            ),
          )),
    );
  }
}
