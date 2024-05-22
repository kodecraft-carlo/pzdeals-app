import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pzdeals/src/actions/show_snackbar.dart';
import 'package:pzdeals/src/common_widgets/textfield_button.dart';
import 'package:pzdeals/src/constants/color_constants.dart';
import 'package:pzdeals/src/constants/sizes.dart';
import 'package:pzdeals/src/features/alerts/models/index.dart';
import 'package:pzdeals/src/features/alerts/presentation/widgets/grid_popularkeywords.dart';
import 'package:pzdeals/src/features/alerts/presentation/widgets/index.dart';
import 'package:pzdeals/src/features/alerts/presentation/widgets/list_categorytoggles.dart';
import 'package:pzdeals/src/features/alerts/state/keyword_provider.dart';
import 'package:pzdeals/src/features/deals/deals.dart';

class AlertsManagementScreen extends ConsumerStatefulWidget {
  const AlertsManagementScreen({super.key});

  @override
  _AlertsManagementScreenState createState() => _AlertsManagementScreenState();
}

class _AlertsManagementScreenState
    extends ConsumerState<AlertsManagementScreen> {
  TextEditingController textController = TextEditingController();
  ScrollController scrollController = ScrollController(keepScrollOffset: true);
  bool isEditMode = false;
  // bool _showMore = false;

  @override
  void initState() {
    super.initState();
    // filteredStores = [];
    Future(() {
      ref.read(keywordsProvider).loadSavedKeywords();
      ref.read(keywordsProvider).loadPopularKeywords();
    });
  }

  void onButtonPressed() {
    if (textController.text.isNotEmpty) {
      if (ref.read(keywordsProvider).addKeywordLocally(
          KeywordData(id: 0, keyword: textController.text.trim().toLowerCase()),
          'input')) {
        // showSnackbarWithMessage(context, 'Keyword added');
        textController.clear();
        SystemChannels.textInput.invokeMethod('TextInput.hide');
      } else {
        showSnackbarWithMessage(context, 'Keyword already exists');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final keywordState = ref.watch(keywordsProvider);
    final foryouState = ref.watch(tabForYouProvider);
    // SchedulerBinding.instance.addPostFrameCallback((_) {
    //   setState(() {
    //     _showMore = scrollController.position.maxScrollExtent > 0;
    //   });
    // });
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
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
                      const Text(
                        "Create Deal Alert",
                        style: TextStyle(
                            fontSize: Sizes.headerFontSize,
                            fontWeight: FontWeight.w600,
                            color: PZColors.pzBlack),
                      ),
                      const Text(
                        "Subscribe to keyword alerts and get notified on new matching deals",
                        style: TextStyle(
                            fontSize: Sizes.bodyFontSize,
                            fontWeight: FontWeight.w400,
                            color: PZColors.pzBlack),
                      ),
                      const SizedBox(height: Sizes.spaceBetweenSectionsXL),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Saved Keywords",
                              style: TextStyle(
                                  fontSize: Sizes.fontSizeMedium,
                                  fontWeight: FontWeight.w600,
                                  color: PZColors.pzBlack)),
                          !keywordState.isLoading &&
                                  keywordState.savedkeywords.isNotEmpty
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
                      keywordState.savedkeywords.isNotEmpty
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
                      TextFieldButton(
                        textController: textController,
                        onButtonPressed: onButtonPressed,
                        buttonLabel: 'Create',
                        textFieldHint: 'Enter Keyword',
                        textfieldIcon: Icons.search,
                      ),
                      const SizedBox(height: Sizes.spaceBetweenSections),
                    ],
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
            ];
          },
          body: TabBarView(
            // physics: const NeverScrollableScrollPhysics(),
            children: <Widget>[
              Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: Sizes.paddingAll),
                  child: CustomScrollView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    slivers: <Widget>[
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(
                            vertical: Sizes.spaceBetweenSections),
                        sliver: SliverList(
                          delegate: SliverChildListDelegate(
                            <Widget>[
                              const SizedBox(
                                  height: Sizes.spaceBetweenSections),
                              const Text(
                                "Popular Keywords",
                                style: TextStyle(
                                  fontSize: Sizes.fontSizeMedium,
                                  fontWeight: FontWeight.w600,
                                  color: PZColors.pzBlack,
                                ),
                              ),
                              const Text(
                                "Click on the plus sign to subscribe",
                                style: TextStyle(
                                  fontSize: Sizes.bodyFontSize,
                                  fontWeight: FontWeight.w400,
                                  color: PZColors.pzBlack,
                                ),
                              ),
                              const SizedBox(
                                  height: Sizes.spaceBetweenSections),
                              PopularKeywordsGrid(
                                keywordsdata: keywordState.popularKeywords,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )),
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
                        "Toggle on category to get notified on new category deals",
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
