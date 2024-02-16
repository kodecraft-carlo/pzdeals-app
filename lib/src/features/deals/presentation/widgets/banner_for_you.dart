import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pzdeals/src/actions/navigate_screen.dart';
import 'package:pzdeals/src/constants/index.dart';
import 'package:pzdeals/src/features/deals/presentation/screens/screen_collection_selection.dart';

class ForYouBannerWidget extends StatelessWidget {
  const ForYouBannerWidget({super.key});

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
              color: PZColors.pzOrange,
              borderRadius: BorderRadius.circular(Sizes.containerBorderRadius),
            ),
            height: 120,
            clipBehavior: Clip.hardEdge,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  left: -3,
                  bottom: 0,
                  child: SvgPicture.asset(
                    'assets/images/for_you_banner_left.svg',
                    height: 90, // Set the desired height for the SVG
                  ),
                ),
                Positioned(
                  left: 60,
                  bottom: 0,
                  child: SvgPicture.asset(
                    'assets/images/for_you_banner_bg.svg',
                    height: 110, // Set the desired height for the SVG
                  ),
                ),
                Positioned(
                  right: -19,
                  bottom: 0,
                  child: SvgPicture.asset(
                    'assets/images/for_you_banner_right.svg',
                    height: 95, // Set the desired height for the SVG
                  ),
                ),
                const Center(
                  child: Text(
                    'Personalize For You Deals',
                    style: TextStyle(
                        color: PZColors.pzWhite,
                        fontSize: Sizes.fontSizeLarge,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.italic),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
