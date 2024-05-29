import 'dart:ui';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:pzdeals/src/actions/show_browser.dart';
import 'package:pzdeals/src/common_widgets/bouncing_arrow_down.dart';
import 'package:pzdeals/src/common_widgets/button_browser.dart';
import 'package:pzdeals/src/common_widgets/product_deal_actions.dart';
import 'package:pzdeals/src/constants/index.dart';
import 'package:pzdeals/src/features/deals/models/index.dart';

class ProductContentDialog extends StatefulWidget {
  final Widget content;
  final ProductDealcardData productData;
  final bool? hasDescription;

  const ProductContentDialog(
      {super.key,
      required this.content,
      required this.productData,
      this.hasDescription = true});

  @override
  _ProductContentDialogState createState() => _ProductContentDialogState();
}

class _ProductContentDialogState extends State<ProductContentDialog> {
  bool showMore = false;
  bool _isScrollingDown = false;
  final scrollController = ScrollController();
  bool _showAffiliateLinkDescription = false;
  // final GlobalKey widgetKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    //scrolldown
    if (scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      setState(() {
        _isScrollingDown = true;
      });
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        setState(() {
          _showAffiliateLinkDescription = true;
        });
      }
    } else if (scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      //scrollup
      setState(() {
        _isScrollingDown = false;
        _showAffiliateLinkDescription = false;
      });
    }
  }

  void onDispose() {
    scrollController.dispose();
    super.dispose();
  }

  // bool isMarkerVisible() {
  //   final RenderBox renderBox =
  //       widgetKey.currentContext!.findRenderObject() as RenderBox;
  //   final widgetSize = renderBox.size;
  //   final widgetPosition = renderBox.localToGlobal(Offset.zero);

  //   final scrollPosition = scrollController.position;
  //   final isVisible = widgetPosition.dy >= scrollPosition.pixels &&
  //       widgetPosition.dy + widgetSize.height <=
  //           scrollPosition.pixels + scrollPosition.viewportDimension;

  //   // debugPrint('Is marker visible: $isVisible');
  //   return isVisible;
  // }

  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      setState(() {
        showMore = scrollController.position.maxScrollExtent > 0;
        // debugPrint('showMore: $showMore');
      });
      // isMarkerVisible();
    });
    double screenHeight = MediaQuery.of(context).size.height;
    double dialogHeight = screenHeight / 1.32;

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Dialog(
        surfaceTintColor: PZColors.pzWhite,

        // scrollable: true,
        // contentPadding: EdgeInsets.zero,
        // actionsPadding: const EdgeInsets.symmetric(
        //     horizontal: Sizes.paddingAll, vertical: Sizes.paddingAllSmall),
        backgroundColor: PZColors.pzWhite,
        shadowColor: PZColors.pzBlack,
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Sizes.dialogBorderRadius),
        ),
        child: SizedBox(
          height: dialogHeight,
          child: Stack(
            children: [
              Column(
                children: [
                  // Add some padding
                  Expanded(
                    child: ShaderMask(
                      shaderCallback: (Rect bounds) {
                        return const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: <Color>[Colors.transparent, Colors.white],
                          stops: <double>[0.85, 1.0],
                        ).createShader(bounds);
                      },
                      blendMode: BlendMode.dstOut,
                      child: Stack(
                        children: [
                          SingleChildScrollView(
                            controller: scrollController,
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                top: Sizes.paddingTop,
                                left: Sizes.paddingLeft,
                                right: Sizes.paddingRight,
                                bottom: Sizes.paddingBottom,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  widget.content,
                                  const SizedBox(
                                    height: Sizes.spaceBetweenSectionsXL,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (_showAffiliateLinkDescription)
                            Align(
                                alignment: Alignment.bottomCenter,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: Sizes.paddingAll,
                                      right: Sizes.paddingAll,
                                      bottom: Sizes.paddingAll),
                                  child: affiliateLinkDescription(),
                                ))
                        ],
                      ),
                    ),
                  ),
                  showMore == true &&
                          !_isScrollingDown &&
                          (widget.hasDescription == true ||
                              (widget.hasDescription == false &&
                                  widget.productData.tagDealDescription != '' &&
                                  (widget.productData.sku != null &&
                                      widget.productData.sku != '')))
                      ? GestureDetector(
                          onTap: () {
                            scrollController.animateTo(
                                scrollController.position.maxScrollExtent,
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeOut);
                            setState(() {
                              _isScrollingDown = true;
                            });
                          },
                          child: const BouncingArrowIcon(
                            height: 45,
                            bounceText: 'Scroll down for more',
                          ),
                        )
                      : const SizedBox.shrink(),
                  ProductDealActions(
                    productData: widget.productData,
                  ),
                  widget.productData.barcodeLink != ''
                      ? Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: Sizes.paddingAll,
                              vertical: Sizes.paddingAllSmall),
                          child: OpenBrowserButton(
                            buttonLabel: 'See Deal',
                            url: widget.productData.barcodeLink ?? '',
                          ))
                      : const SizedBox(
                          height: Sizes.spaceBetweenSectionsXL,
                        ),
                ],
              ),
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: const Icon(
                    Icons.close,
                    size: Sizes.largeIconSize,
                  ),
                  // style: ButtonStyle(
                  //   shape: MaterialStateProperty.all<OutlinedBorder>(
                  //     RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(
                  //           50), // Set a large value for circular shape
                  //       side: BorderSide(
                  //           color: Colors.white,
                  //           width: 2), // Add a white stroke
                  //     ),
                  //   ),
                  // ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget affiliateLinkDescription() {
    return Row(
      children: [
        Expanded(
            child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(children: [
            const TextSpan(
                text: 'We may earn commission from ',
                style: TextStyle(
                    color: PZColors.pzBlack,
                    fontSize: Sizes.fontSizeXSmall / 1.2,
                    fontFamily: 'Poppins',
                    fontStyle: FontStyle.italic)),
            TextSpan(
                text: 'affiliate links',
                style: const TextStyle(
                    fontSize: Sizes.fontSizeXSmall / 1.2,
                    fontStyle: FontStyle.italic,
                    fontFamily: 'Poppins',
                    color: PZColors.hyperlinkColor),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    openBrowser(
                        'https://www.pzdeals.com/pages/advertiser-disclosure');
                  }),
            const TextSpan(
                text: '. We appreciate your support!',
                style: TextStyle(
                    color: PZColors.pzBlack,
                    fontSize: Sizes.fontSizeXSmall / 1.2,
                    fontFamily: 'Poppins',
                    fontStyle: FontStyle.italic))
          ]),
        ))
      ],
    );
  }
}
