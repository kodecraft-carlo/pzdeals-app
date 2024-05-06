import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pzdeals/src/constants/color_constants.dart';
import 'package:pzdeals/src/constants/sizes.dart';

class EmptyDataPlaceholderWidget extends StatefulWidget {
  const EmptyDataPlaceholderWidget(
      {super.key, this.isCard = false, required this.message});
  final bool isCard;
  final String message;
  @override
  EmptyDataPlaceholderWidgetState createState() =>
      EmptyDataPlaceholderWidgetState();
}

class EmptyDataPlaceholderWidgetState extends State<EmptyDataPlaceholderWidget>
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
    return widget.isCard
        ? Card(
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
                    widget.message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: Sizes.fontSizeMedium, color: PZColors.pzGrey),
                  ),
                ],
              ),
            ),
          )
        : Center(
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
                Text(
                  widget.message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: Sizes.fontSizeMedium, color: PZColors.pzGrey),
                ),
                const SizedBox(height: Sizes.spaceBetweenContentSmall),
              ],
            ),
          );
  }
}
