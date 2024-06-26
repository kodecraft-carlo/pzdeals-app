import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:pzdeals/src/actions/launch_url.dart';
import 'package:pzdeals/src/actions/show_browser.dart';
import 'package:pzdeals/src/common_widgets/bouncing_arrow_down.dart';
import 'package:pzdeals/src/common_widgets/button_browser.dart';
import 'package:pzdeals/src/common_widgets/button_see_deal.dart';
import 'package:pzdeals/src/common_widgets/loading_dialog.dart';
import 'package:pzdeals/src/common_widgets/product_deal_actions.dart';
import 'package:pzdeals/src/common_widgets/store_icon.dart';
import 'package:pzdeals/src/constants/index.dart';
import 'package:pzdeals/src/features/deals/models/index.dart';
import 'package:pzdeals/src/models/index.dart';

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
  bool isUrlLoading = false;
  // final GlobalKey widgetKey = GlobalKey();
  bool _isCallbackAdded = false;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_onScroll);
    if (!_isCallbackAdded) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        debugPrint('ProductContentDialog addPostFrameCallback');
        if (mounted) {
          setState(() {
            showMore = scrollController.position.maxScrollExtent > 0;
            // debugPrint('showMore: $showMore');
          });
        }
        _isCallbackAdded = true; // Ensure the callback is not added again
      });
    }
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
    debugPrint('ProductContentDialog build');
    // SchedulerBinding.instance.addPostFrameCallback((_) {
    //   debugPrint('ProductContentDialog addPostFrameCallback');
    //   setState(() {
    //     showMore = scrollController.position.maxScrollExtent > 0;
    //     // debugPrint('showMore: $showMore');
    //   });
    //   // isMarkerVisible();
    // });
    double screenHeight = MediaQuery.of(context).size.height;
    double dialogHeight = screenHeight / 1.22;

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Dialog(
        alignment: Alignment.topCenter,
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Sizes.dialogBorderRadius),
        ),
        child: SizedBox(
          // height: dialogHeight,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(Sizes.dialogBorderRadius),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: Container(
                                height: 50,
                                width: 50,
                                padding:
                                    widget.productData.storeName == 'Amazon'
                                        ? const EdgeInsets.only(top: 5)
                                        : const EdgeInsets.all(0),
                                margin: const EdgeInsets.only(
                                    bottom: Sizes.paddingBottom / 1.5),
                                clipBehavior: Clip.hardEdge,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(
                                      Sizes.cardBorderRadius / 1.65),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.2),
                                      spreadRadius: 3,
                                      blurRadius: 9,
                                    ),
                                  ],
                                ),
                                child: StoreIcon(
                                  storeData: StoreData(
                                      assetSourceType: 'network',
                                      storeAssetImage:
                                          widget.productData.storeAssetImage,
                                      storeName: 'Stores',
                                      handle: 'pzdeals',
                                      id: 1),
                                ),
                              ),
                            ),
                            // Align(
                            //   child: Padding(
                            //     padding: const EdgeInsets.only(
                            //         bottom: Sizes.paddingAllSmall),
                            //     child: Text(
                            //       widget.productData.storeName ?? 'PzDeals',
                            //       maxLines: 2,
                            //       textAlign: TextAlign.center,
                            //       overflow: TextOverflow.ellipsis,
                            //       style: const TextStyle(
                            //           color: PZColors.pzWhite,
                            //           shadows: [
                            //             Shadow(
                            //               offset: Offset(1.0, 1.0),
                            //               blurRadius: 15.0,
                            //               color: Color.fromARGB(255, 0, 0, 0),
                            //             ),
                            //             // Add more shadows here if needed
                            //           ],
                            //           fontSize: Sizes.fontSizeMedium,
                            //           fontWeight: FontWeight.w600),
                            //       textScaler: MediaQuery.textScalerOf(context),
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                      color: PZColors.pzWhite,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(Sizes.cardBorderRadius),
                          topRight: Radius.circular(Sizes.cardBorderRadius)),
                      // boxShadow: [
                      //   BoxShadow(
                      //     color: Colors.grey.withOpacity(0.2),
                      //     spreadRadius: 3,
                      //     blurRadius: 9,
                      //   ),
                      // ],
                    ),
                    // padding: const EdgeInsets.only(top: Sizes.paddingAllSmall),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Add some padding
                        Flexible(
                          child: ShaderMask(
                            shaderCallback: (Rect bounds) {
                              return const LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: <Color>[
                                  Colors.transparent,
                                  Colors.white
                                ],
                                stops: <double>[0.90, 1.0],
                              ).createShader(bounds);
                            },
                            blendMode: BlendMode.dstOut,
                            child: Stack(
                              children: [
                                SingleChildScrollView(
                                  controller: scrollController,
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      top: Sizes.paddingTopSmall,
                                      left: Sizes.paddingLeft,
                                      right: Sizes.paddingRight,
                                      // bottom: Sizes.paddingBottom,
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
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
                                          bottom: Sizes.paddingAllSmall),
                                      child: affiliateLinkDescription(),
                                    ),
                                  ),
                                Align(
                                  alignment: Alignment.topRight,
                                  child: IconButton(
                                    highlightColor: Colors.transparent,
                                    icon: const Icon(
                                      Icons.close,
                                      size: Sizes.largeIconSize,
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        showMore == true &&
                                !_isScrollingDown &&
                                (widget.hasDescription == true ||
                                    (widget.hasDescription == false &&
                                        widget.productData.tagDealDescription !=
                                            '' &&
                                        (widget.productData.sku != null &&
                                            widget.productData.sku != '')))
                            ? GestureDetector(
                                onTap: () {
                                  scrollController.animateTo(
                                      scrollController.position.maxScrollExtent,
                                      duration:
                                          const Duration(milliseconds: 500),
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
                      ],
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    color: PZColors.pzWhite,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(Sizes.cardBorderRadius),
                        bottomRight: Radius.circular(Sizes.cardBorderRadius)),
                    // boxShadow: [
                    //   BoxShadow(
                    //     color: Colors.grey.withOpacity(0.2),
                    //     spreadRadius: 3,
                    //     blurRadius: 9,
                    //   ),
                    // ],
                  ),
                  padding: const EdgeInsets.only(bottom: Sizes.paddingAllSmall),
                  child: Column(
                    children: [
                      ProductDealActions(
                        productData: widget.productData,
                      ),
                      widget.productData.barcodeLink != ''
                          ? Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: Sizes.paddingAll,
                                  vertical: Sizes.paddingAllSmall),
                              child: SeeDealButton(
                                buttonLabel: 'See Deal',
                                onPressed: () {
                                  HapticFeedback.mediumImpact();
                                  if (widget.productData.storeName
                                              ?.toLowerCase() ==
                                          'amazon' ||
                                      widget.productData.storeName
                                              ?.toLowerCase() ==
                                          'walmart') {
                                    LoadingDialog.show(context);
                                    Future.wait([
                                      launchDealUrl(
                                          widget.productData.barcodeLink ?? '')
                                    ]).whenComplete(
                                        () => LoadingDialog.hide(context));
                                  } else {
                                    openBrowser(
                                        widget.productData.barcodeLink ?? '');
                                  }
                                },
                              ),
                            )
                          : const SizedBox(
                              height: Sizes.spaceBetweenSectionsXL,
                            ),
                    ],
                  ),
                )
              ],
            ),
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
