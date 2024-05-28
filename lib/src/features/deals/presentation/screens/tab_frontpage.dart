import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:pzdeals/src/common_widgets/products_display.dart';
import 'package:pzdeals/src/constants/index.dart';
import 'package:pzdeals/src/features/deals/deals.dart';
import 'package:pzdeals/src/state/layout_type_provider.dart';

class FrontPageDealsWidget extends ConsumerStatefulWidget {
  const FrontPageDealsWidget({super.key});
  @override
  FrontPageDealsWidgetState createState() => FrontPageDealsWidgetState();
}

class FrontPageDealsWidgetState extends ConsumerState<FrontPageDealsWidget>
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
    final frontpageState = ref.watch(tabFrontPageProvider);
    if (frontpageState.isLoading && frontpageState.products.isEmpty) {
      return const Center(child: CircularProgressIndicator.adaptive());
    } else if (frontpageState.products.isEmpty) {
      return Padding(
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
              const Text(
                'There are no deals available at the moment. Please check back later.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: Sizes.fontSizeMedium, color: PZColors.pzGrey),
              ),
            ],
          ));
    } else {
      final productData = frontpageState.products;
      final layoutType = ref.watch(layoutTypeProvider);
      return Stack(
        children: [
          Positioned.fill(
            child: Column(
              children: [
                const SizedBox(
                  height: Sizes.paddingAllSmall,
                ),
                const Padding(
                    padding: EdgeInsets.symmetric(horizontal: Sizes.paddingAll),
                    child: Text(
                      Wordings.descFrontPage,
                      style: TextStyle(
                          color: Colors.black54, fontSize: Sizes.bodyFontSize),
                      textAlign: TextAlign.center,
                    )),
                Expanded(
                    child: ProductsDisplay(
                  productData: productData,
                  layoutType: layoutType,
                  onRefresh: () async {
                    HapticFeedback.mediumImpact();
                    frontpageState.refreshDeals();
                  },
                )),
              ],
            ),
          ),
          if (frontpageState.isLoading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: Sizes.paddingAll),
              child: Align(
                  alignment: Alignment.topCenter,
                  child: CircularProgressIndicator.adaptive()),
            ),
        ],
      );
    }
  }
}
