import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pzdeals/src/constants/index.dart';
import 'package:pzdeals/src/features/alerts/presentation/widgets/create_alert_field_button.dart';
import 'package:pzdeals/src/features/alerts/presentation/widgets/grid_popularkeywords.dart';
import 'package:pzdeals/src/features/alerts/presentation/widgets/index.dart';
import 'package:pzdeals/src/features/alerts/presentation/widgets/list_categorytoggles.dart';
import 'package:pzdeals/src/features/alerts/state/keyword_provider.dart';

class AlertsManagementScreen extends ConsumerStatefulWidget {
  const AlertsManagementScreen({super.key});

  @override
  AlertsManagementScreenState createState() => AlertsManagementScreenState();
}

class AlertsManagementScreenState
    extends ConsumerState<AlertsManagementScreen> {
  TextEditingController textController = TextEditingController();
  ScrollController scrollController = ScrollController(keepScrollOffset: true);
  final GlobalKey<NestedScrollViewState> _nestedScrollViewKey =
      GlobalKey<NestedScrollViewState>();
  bool isEditMode = false;
  // bool _showMore = false;

  @override
  void initState() {
    super.initState();
    // filteredStores = [];
    Future(() {
      // ref.read(keywordsProvider).loadSavedKeywords();
      ref.read(keywordsProvider).loadPopularKeywords();
    });
  }

  // void onButtonPressed() {
  //   if (textController.text.isNotEmpty) {
  //     if (ref.read(keywordsProvider).addKeywordLocally(
  //         KeywordData(id: 0, keyword: textController.text.trim().toLowerCase()),
  //         'input')) {
  //       // showSnackbarWithMessage(context, 'Keyword added');
  //       textController.clear();
  //       SystemChannels.textInput.invokeMethod('TextInput.hide');
  //     } else {
  //       showSnackbarWithMessage(context, 'Keyword already exists');
  //     }
  //   }
  // }

  void scrollToTop() {
    debugPrint('scrollToTop alerts');
    _nestedScrollViewKey.currentState?.innerController.animateTo(
      0.0, // Scroll to the top of the list
      duration:
          const Duration(milliseconds: 300), // Adjust the duration as needed
      curve: Curves.easeInOut, // Adjust the curve as needed
    );
    _nestedScrollViewKey.currentState?.outerController.animateTo(
      0.0, // Scroll to the top of the list
      duration:
          const Duration(milliseconds: 300), // Adjust the duration as needed
      curve: Curves.easeInOut, // Adjust the curve as needed
    );
  }

  @override
  Widget build(BuildContext context) {
    final savedKeywordData =
        ref.watch(keywordsProvider.select((value) => value.savedkeywords));
    // SchedulerBinding.instance.addPostFrameCallback((_) {
    //   setState(() {
    //     _showMore = scrollController.position.maxScrollExtent > 0;
    //   });
    // });
    if (savedKeywordData.isEmpty) {
      isEditMode = false;
    }
    debugPrint('screen alerts management build');
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: NestedScrollView(
          key: _nestedScrollViewKey,
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              // SliverToBoxAdapter(
              //   child: Padding(
              //     padding: const EdgeInsets.only(
              //         top: Sizes.paddingTopSmall,
              //         left: Sizes.paddingLeft,
              //         right: Sizes.paddingRight),
              //     child: Column(
              //       mainAxisAlignment: MainAxisAlignment.start,
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         const Text(
              //           "Create Deal Alert",
              //           style: TextStyle(
              //               fontSize: Sizes.headerFontSize,
              //               fontWeight: FontWeight.w600,
              //               color: PZColors.pzBlack),
              //         ),
              //         const Text(
              //           "Subscribe to keyword alerts and get notified on new matching deals",
              //           style: TextStyle(
              //               fontSize: Sizes.bodyFontSize,
              //               fontWeight: FontWeight.w400,
              //               color: PZColors.pzBlack),
              //         ),
              //         const SizedBox(height: Sizes.spaceBetweenSectionsXL),
              //         Row(
              //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //           children: [
              //             const Text("Saved Keywords",
              //                 style: TextStyle(
              //                     fontSize: Sizes.fontSizeMedium,
              //                     fontWeight: FontWeight.w600,
              //                     color: PZColors.pzBlack)),
              //             savedKeywordData.isNotEmpty
              //                 ? GestureDetector(
              //                     onTap: () {
              //                       setState(() {
              //                         isEditMode = !isEditMode;
              //                       });
              //                     },
              //                     child: Text(isEditMode ? "Done" : "Edit",
              //                         style: const TextStyle(
              //                             fontSize: Sizes.fontSizeMedium,
              //                             fontWeight: FontWeight.w600,
              //                             color: PZColors.pzOrange)),
              //                   )
              //                 : const SizedBox.shrink()
              //           ],
              //         ),
              //         const SizedBox(height: Sizes.spaceBetweenContentSmall),
              //         savedKeywordData.isNotEmpty
              //             ? Row(children: [
              //                 Expanded(
              //                     child: SizedBox(
              //                   height: 120,
              //                   child: RawScrollbar(
              //                       controller: scrollController,
              //                       thumbVisibility: true,
              //                       child: SingleChildScrollView(
              //                         controller: scrollController,
              //                         child: ChipSavedKeywords(
              //                           editMode: isEditMode
              //                               ? EditMode.edit
              //                               : EditMode.view,
              //                         ),
              //                       )),
              //                 ))
              //               ])
              //             : const SizedBox(
              //                 height: 120,
              //                 child: Text(
              //                   'You have no saved keywords yet.',
              //                   style: TextStyle(
              //                       color: PZColors.pzGrey,
              //                       fontStyle: FontStyle.italic,
              //                       fontSize: Sizes.fontSizeSmall),
              //                   textAlign: TextAlign.center,
              //                 ),
              //               ),
              //         const SizedBox(height: Sizes.spaceBetweenSectionsXL),
              //         TextFieldButton(
              //           textController: textController,
              //           onButtonPressed: onButtonPressed,
              //           buttonLabel: 'Create',
              //           textFieldHint: 'Enter Keyword',
              //           textfieldIcon: Icons.search,
              //         ),
              //         const SizedBox(height: Sizes.spaceBetweenSections),
              //       ],
              //     ),
              //   ),
              // ),
              SliverPersistentHeader(
                pinned: true,
                delegate: _SliverAppBarDelegate(
                    minHeight: 80,
                    maxHeight: 80,
                    child: Container(
                      color: Colors.white,
                      child: const Row(
                        children: [
                          Expanded(
                            // Move Expanded here
                            child: Padding(
                              padding: EdgeInsets.only(
                                  top: Sizes.paddingTopSmall,
                                  left: Sizes.paddingLeft,
                                  right: Sizes.paddingRight),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Create Deal Alerts",
                                    style: TextStyle(
                                        fontSize: Sizes.headerFontSize,
                                        fontWeight: FontWeight.w600,
                                        color: PZColors.pzBlack),
                                  ),
                                  Text(
                                    Wordings.descDealAlerts,
                                    maxLines: 2,
                                    style: TextStyle(
                                        fontSize: Sizes.bodyFontSize,
                                        fontWeight: FontWeight.w400,
                                        color: PZColors.pzBlack),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    )),
              ),

              // SliverAppBar(
              //   pinned: true,
              //   backgroundColor: PZColors.pzWhite,
              //   floating: false,
              //   primary: false,
              //   forceElevated: innerBoxIsScrolled,
              //   titleSpacing: 0,
              //   automaticallyImplyLeading: false,
              //   flexibleSpace: FlexibleSpaceBar(
              //       background: Container(
              //         color: PZColors
              //             .pzWhite, // Set background color to transparent
              //       ),
              //       collapseMode: CollapseMode.pin),
              //   title:
              // ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: Sizes.paddingTopSmall,
                      left: Sizes.paddingLeft,
                      right: Sizes.paddingRight),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Saved Keywords",
                              style: TextStyle(
                                  fontSize: Sizes.fontSizeMedium,
                                  fontWeight: FontWeight.w600,
                                  color: PZColors.pzBlack)),
                          savedKeywordData.isNotEmpty
                              ? GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isEditMode = !isEditMode;
                                    });
                                  },
                                  child: Text(isEditMode ? "Done" : "Edit",
                                      style: const TextStyle(
                                          fontSize: Sizes.fontSizeMedium,
                                          fontWeight: FontWeight.w600,
                                          color: PZColors.pzOrange)),
                                )
                              : const SizedBox.shrink()
                        ],
                      ),
                      const SizedBox(height: Sizes.spaceBetweenContentSmall),
                      savedKeywordData.isNotEmpty
                          ? Row(children: [
                              Expanded(
                                  child: SizedBox(
                                height: 120,
                                child: RawScrollbar(
                                    controller: scrollController,
                                    thumbVisibility: true,
                                    child: SingleChildScrollView(
                                      controller: scrollController,
                                      child: ChipSavedKeywords(
                                        editMode: isEditMode
                                            ? EditMode.edit
                                            : EditMode.view,
                                      ),
                                    )),
                              ))
                            ])
                          : const SizedBox(
                              height: 120,
                              child: Text(
                                'You have no saved keywords yet.',
                                style: TextStyle(
                                    color: PZColors.pzGrey,
                                    fontStyle: FontStyle.italic,
                                    fontSize: Sizes.fontSizeSmall),
                                textAlign: TextAlign.center,
                              ),
                            ),
                      const SizedBox(height: Sizes.spaceBetweenSectionsXL),
                    ],
                  ),
                ),
              ),
              SliverPersistentHeader(
                pinned: true,
                delegate: _SliverAppBarDelegate(
                  minHeight: 60,
                  maxHeight: 60,
                  child: Container(
                    color: PZColors.pzWhite,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: Sizes.paddingTopSmall,
                          left: Sizes.paddingLeft,
                          right: Sizes.paddingRight),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CreateAlertFieldButton(
                            textController: textController,
                            buttonLabel: 'Create',
                            textFieldHint: 'Enter Keyword',
                            textfieldIcon: Icons.search,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              SliverAppBar(
                backgroundColor: PZColors.pzWhite,
                floating: false,
                pinned: true,
                primary: false,
                forceElevated: innerBoxIsScrolled,
                automaticallyImplyLeading: false,
                flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      color: PZColors
                          .pzWhite, // Set background color to transparent
                    ),
                    collapseMode: CollapseMode.pin),
                title: TabBar(
                  indicatorWeight: 4,
                  indicatorColor: PZColors.pzOrange,
                  dividerColor: PZColors.pzOrange,
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                  labelStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: PZColors.pzBlack,
                      fontFamily: 'Poppins'),
                  unselectedLabelStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: PZColors.pzGrey,
                      fontFamily: 'Poppins'),
                  tabs: const <Widget>[
                    Tab(
                      text: 'Keyword Alerts',
                    ),
                    Tab(
                      text: 'Category Alerts',
                    ),
                  ],
                ),
                titleSpacing: 0,
              ),
              // SliverAppBar(
              //   backgroundColor: PZColors.pzWhite,
              //   floating: false,
              //   pinned: true,
              //   primary: false,
              //   forceElevated: innerBoxIsScrolled,
              //   automaticallyImplyLeading: false,
              //   flexibleSpace: FlexibleSpaceBar(
              //       background: Container(
              //         color: PZColors
              //             .pzWhite, // Set background color to transparent
              //       ),
              //       collapseMode: CollapseMode.pin),
              //   title: TabBar(
              //     indicatorWeight: 4,
              //     indicatorColor: PZColors.pzOrange,
              //     dividerColor: PZColors.pzOrange,
              //     overlayColor: MaterialStateProperty.all(Colors.transparent),
              //     labelStyle: const TextStyle(
              //         fontWeight: FontWeight.bold,
              //         color: PZColors.pzBlack,
              //         fontFamily: 'Poppins'),
              //     unselectedLabelStyle: const TextStyle(
              //         fontWeight: FontWeight.bold,
              //         color: PZColors.pzGrey,
              //         fontFamily: 'Poppins'),
              //     tabs: const <Widget>[
              //       Tab(
              //         text: 'Keyword Alerts',
              //       ),
              //       Tab(
              //         text: 'Category Alerts',
              //       ),
              //     ],
              //   ),
              //   titleSpacing: 0,
              // ),
            ];
          },
          body: TabBarView(
            // physics: const NeverScrollableScrollPhysics(),
            children: <Widget>[
              SingleChildScrollView(
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: Sizes.paddingAll),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: Sizes.spaceBetweenSections),
                      Text(
                        "Popular Keywords",
                        style: TextStyle(
                          fontSize: Sizes.fontSizeMedium,
                          fontWeight: FontWeight.w600,
                          color: PZColors.pzBlack,
                        ),
                      ),
                      Text(
                        "Click on the plus sign to subscribe to that Deal Alert.",
                        style: TextStyle(
                          fontSize: Sizes.bodyFontSize,
                          fontWeight: FontWeight.w400,
                          color: PZColors.pzBlack,
                        ),
                      ),
                      SizedBox(height: Sizes.spaceBetweenSections),
                      PopularKeywordsGrid(),
                    ],
                  ),
                ),
              ),
              SingleChildScrollView(
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: Sizes.paddingAll),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: Sizes.spaceBetweenSections),
                      Text("Category Alerts",
                          style: TextStyle(
                              fontSize: Sizes.fontSizeMedium,
                              fontWeight: FontWeight.w600,
                              color: PZColors.pzBlack)),
                      Text(
                        Wordings.descCategoryAlerts,
                        style: TextStyle(
                            fontSize: Sizes.bodyFontSize,
                            fontWeight: FontWeight.w400,
                            color: PZColors.pzBlack),
                      ),
                      SizedBox(height: Sizes.spaceBetweenSections),
                      Flexible(
                        child: CategoryNotificationToggleList(),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => max(maxHeight, minHeight);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
