import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pzdeals/src/common_widgets/custom_scaffold.dart';
import 'package:pzdeals/src/common_widgets/scrollbar.dart';
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
  final GlobalKey<NestedScrollViewState> globalKeyCreditCards =
      GlobalKey<NestedScrollViewState>();

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

  bool _isLoading = false;

  void _onScroll() async {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (_isLoading) {
        return;
      }

      _isLoading = true;
      await ref.read(creditcardsProvider).loadMoreCreditCards();
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

  @override
  Widget build(BuildContext context) {
    final creditcardState = ref.watch(creditcardsProvider);
    return CustomScaffoldWidget(
        scaffold: Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: GestureDetector(
                onTap: scrollToTop,
                child: AppBar(
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
                )),
          ),
          body: RefreshIndicator.adaptive(
            color: PZColors.pzOrange,
            child: ScrollbarWidget(
              scrollController: _scrollController,
              child: SingleChildScrollView(
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
                            child: CircularProgressIndicator.adaptive())
                      else if (creditcardState.creditcards.isEmpty)
                        const Center(
                            child: Text(
                          'There are no credit card deals available at the moment. Please check back later.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: Sizes.fontSizeMedium,
                              color: PZColors.pzGrey),
                        ))
                      else
                        for (int i = 0;
                            i < creditcardState.creditcards.length;
                            i++)
                          CreditCardItem(
                            displayType: 'scrollView',
                            creditCardDealData: creditcardState.creditcards[i],
                          ),
                      const SizedBox(height: Sizes.spaceBetweenContent),
                      if (creditcardState.isLoading &&
                          creditcardState.creditcards.isNotEmpty)
                        const Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: Sizes.paddingAll),
                          child: Center(
                              child: CircularProgressIndicator.adaptive()),
                        )
                    ],
                  ),
                ),
              ),
            ),
            onRefresh: () => creditcardState.refreshCreditCards(),
          ),
        ),
        scrollAction: scrollToTop);
  }
}
