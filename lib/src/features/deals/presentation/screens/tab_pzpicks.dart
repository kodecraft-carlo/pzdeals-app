import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:pzdeals/src/common_widgets/products_display.dart';
import 'package:pzdeals/src/constants/index.dart';
import 'package:pzdeals/src/features/deals/deals.dart';
import 'package:pzdeals/src/state/layout_type_provider.dart';

class PZPicksScreenWidget extends ConsumerStatefulWidget {
  const PZPicksScreenWidget({super.key});
  @override
  PZPicksScreenWidgetState createState() => PZPicksScreenWidgetState();
}

class PZPicksScreenWidgetState extends ConsumerState<PZPicksScreenWidget>
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
    final pzpicksState = ref.watch(tabPzPicksProvider);
    if (pzpicksState.isLoading && pzpicksState.products.isEmpty) {
      return const Center(child: CircularProgressIndicator.adaptive());
    } else if (pzpicksState.products.isEmpty) {
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
      final productData = pzpicksState.products;
      final layoutType = ref.watch(layoutTypeProvider);
      return Column(
        children: [
          const SizedBox(
            height: Sizes.paddingAllSmall,
          ),
          const Text(
            "This is a sample description of this tab",
            style:
                TextStyle(color: Colors.black54, fontSize: Sizes.bodyFontSize),
          ),
          Expanded(
            child: ProductsDisplay(
              productData: productData,
              layoutType: layoutType,
              scrollKey: 'tabPzpicks',
              onRefresh: () => pzpicksState.refreshDeals(),
            ),
          ),
          if (pzpicksState.isLoading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: Sizes.paddingAll),
              child: Center(child: CircularProgressIndicator.adaptive()),
            ),
        ],
      );
    }
  }
}
