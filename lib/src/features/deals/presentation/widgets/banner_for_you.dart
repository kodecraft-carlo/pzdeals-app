import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:pzdeals/src/actions/navigate_screen.dart';
import 'package:pzdeals/src/constants/index.dart';
import 'package:pzdeals/src/features/deals/presentation/screens/screen_collection_selection.dart';

class ForYouBannerWidget extends StatefulWidget {
  const ForYouBannerWidget({super.key});
  @override
  ForYouBannerWidgetState createState() => ForYouBannerWidgetState();
}

class ForYouBannerWidgetState extends State<ForYouBannerWidget>
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
    return NavigateScreenWidget(
        destinationWidget: const CollectionSelectionWidget(),
        animationDirection: 'bottomToTop',
        childWidget: Padding(
          padding: const EdgeInsets.only(
              top: Sizes.paddingTopSmall,
              left: Sizes.paddingLeft,
              right: Sizes.paddingRight),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(Sizes.containerBorderRadius),
              border: Border.all(
                color: PZColors.pzOrange,
                width: 3.0,
              ),
            ),
            height: 120,
            width: double.infinity,
            clipBehavior: Clip.hardEdge,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  right: 10,
                  bottom: -75,
                  child: Lottie.asset(
                    'assets/images/lottie/pz_deals_custom_foryou.json',
                    height: 190,
                    fit: BoxFit.fitHeight,
                    repeat: true,
                    animate: true,
                    frameRate: FrameRate.max,
                    controller: _animationController,
                    onLoaded: (composition) {
                      _animationController
                        ..duration = composition.duration
                        ..repeat();
                    },
                  ),
                ),
                Positioned(
                    left: 15,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          Wordings.bannerTitle,
                          style: TextStyle(
                            color: PZColors.pzOrange,
                            fontSize: Sizes.fontSizeXLarge,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(
                          width: 210,
                          child: Text(
                            Wordings.bannerDesc,
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontSize: 10,
                            ),
                            maxLines: 3,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Container(
                          decoration: BoxDecoration(
                            color: PZColors.pzOrange,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 5),
                          child: const Text(
                            'Start',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 12),
                          ),
                        )
                      ],
                    ))
              ],
            ),
          ),
        ));
  }
}
