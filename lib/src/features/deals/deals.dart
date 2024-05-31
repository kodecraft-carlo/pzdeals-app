import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pzdeals/src/common_widgets/sliver_appbar.dart';
import 'package:pzdeals/src/constants/color_constants.dart';
import 'package:pzdeals/src/features/deals/presentation/screens/index.dart';
import 'package:pzdeals/src/features/deals/presentation/widgets/index.dart';
import 'package:pzdeals/src/features/deals/state/provider_creditcards.dart';
import 'package:pzdeals/src/features/deals/state/provider_frontpage.dart';
import 'package:pzdeals/src/features/deals/state/provider_pzpicks.dart';

final tabFrontPageProvider = ChangeNotifierProvider<TabFrontPageNotifier>(
    (ref) => TabFrontPageNotifier());
final tabPzPicksProvider =
    ChangeNotifierProvider<TabPzPicksNotifier>((ref) => TabPzPicksNotifier());
final creditcardsProvider =
    ChangeNotifierProvider<CreditCardsNotifier>((ref) => CreditCardsNotifier());

class DealsTabControllerWidget extends ConsumerStatefulWidget {
  const DealsTabControllerWidget({super.key});
  @override
  DealsTabControllerWidgetState createState() =>
      DealsTabControllerWidgetState();
}

class DealsTabControllerWidgetState
    extends ConsumerState<DealsTabControllerWidget>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ForYouWidgetState> _foryoupageKey =
      GlobalKey<ForYouWidgetState>();
  final GlobalKey<FrontPageDealsWidgetState> _frontpageKey =
      GlobalKey<FrontPageDealsWidgetState>();
  final GlobalKey<PZPicksScreenWidgetState> _pzpicksKey =
      GlobalKey<PZPicksScreenWidgetState>();
  final GlobalKey<NestedScrollViewState> dealsScreenKey =
      GlobalKey<NestedScrollViewState>();

  final _scrollController = ScrollController(keepScrollOffset: true);
  late TabController tabController;
  bool _isAtBottomPzPicks = false;
  bool _isAtBottomFrontPage = false;
  bool _isAtBottomForYou = false;
  String id = '';

  @override
  void initState() {
    super.initState();
    dealsScreenKey.currentState?.innerController.addListener(_onScroll);
    _scrollController.addListener(_onScroll);
    tabController = TabController(
      length: 3,
      initialIndex: 1,
      vsync: this,
    );
  }

  @override
  void dispose() {
    tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (tabController.index == 0) {
      _isAtBottomForYou = false;
    }
    if (tabController.index == 1) {
      _isAtBottomFrontPage = false;
    }
    if (tabController.index == 2) {
      _isAtBottomPzPicks = false;
    }
  }

  void scrollToTop() {
    dealsScreenKey.currentState?.innerController.animateTo(
      0.0, // Scroll to the top of the list
      duration:
          const Duration(milliseconds: 300), // Adjust the duration as needed
      curve: Curves.easeInOut, // Adjust the curve as needed
    );
    dealsScreenKey.currentState?.outerController.animateTo(
      0.0, // Scroll to the top of the list
      duration:
          const Duration(milliseconds: 300), // Adjust the duration as needed
      curve: Curves.easeInOut, // Adjust the curve as needed
    );
  }

  //set tab index
  void setTabIndex(int index) {
    tabController.animateTo(index);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 1,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: NestedScrollView(
            key: dealsScreenKey,
            scrollBehavior: const CupertinoScrollBehavior(),
            controller: _scrollController,
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBarWidget(
                    innerBoxIsScrolled: innerBoxIsScrolled,
                    searchFieldWidget: const HomescreenSearchFieldWidget(
                      hintText: "Search deals",
                    )),
                // const SliverToBoxAdapter(
                //   child: CreditCardDealsWidget(),
                // ),
                SliverAppBar(
                  elevation: 3.0,
                  backgroundColor: PZColors.pzWhite,
                  automaticallyImplyLeading: false,
                  floating: false,
                  pinned: true,
                  forceElevated: innerBoxIsScrolled,
                  primary: true,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      color: PZColors
                          .pzWhite, // Set background color to transparent
                    ),
                    collapseMode: CollapseMode.pin,
                  ),
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(0),
                    child: Builder(builder: (BuildContext context) {
                      return TabBar(
                        controller: tabController,
                        indicatorWeight: 4,
                        indicatorColor: PZColors.pzOrange,
                        dividerColor: PZColors.pzOrange,
                        overlayColor:
                            MaterialStateProperty.all(Colors.transparent),
                        labelStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: PZColors.pzBlack,
                            fontFamily: 'Poppins'),
                        unselectedLabelStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: PZColors.pzGrey,
                            fontFamily: 'Poppins'),
                        tabs: <Widget>[
                          GestureDetector(
                            onTap: () => {
                              debugPrint('for you tapped'),
                              tabController.animateTo(0),
                              if (_foryoupageKey.currentState != null)
                                {
                                  scrollToTop(),
                                }
                            },
                            child: const Tab(
                              text: 'For You',
                            ),
                          ),
                          GestureDetector(
                            onTap: () => {
                              debugPrint('front page tapped'),
                              tabController.animateTo(1),
                              if (_frontpageKey.currentState != null)
                                {
                                  scrollToTop(),
                                }
                            },
                            child: const Tab(
                              text: 'PzPicks',
                            ),
                          ),
                          GestureDetector(
                            onTap: () => {
                              debugPrint('pz picks tapped'),
                              tabController.animateTo(2),
                              if (_pzpicksKey.currentState != null)
                                {
                                  scrollToTop(),
                                }
                            },
                            child: const Tab(
                              text: 'Flash Deals',
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                  titleSpacing: 0,
                ),
              ];
            },
            body: TabBarView(
              controller: tabController,
              children: <Widget>[
                ForYouWidget(
                    key: _foryoupageKey,
                    tabController: tabController,
                    dealsKey: dealsScreenKey),
                NotificationListener<ScrollNotification>(
                  child: FrontPageDealsWidget(key: _frontpageKey),
                  onNotification: (ScrollNotification scrollInfo) {
                    if (scrollInfo.metrics.pixels >=
                        scrollInfo.metrics.maxScrollExtent - 300) {
                      if (!_isAtBottomFrontPage) {
                        _isAtBottomFrontPage = true;
                        ref.read(tabFrontPageProvider).loadMoreProducts();
                      }
                      if (!ref.watch(tabFrontPageProvider).isLoading) {
                        _isAtBottomFrontPage = false;
                      }
                    } else {
                      _isAtBottomFrontPage = false;
                    }
                    return false;
                  },
                ),
                NotificationListener<ScrollNotification>(
                  child: PZPicksScreenWidget(key: _pzpicksKey),
                  onNotification: (ScrollNotification scrollInfo) {
                    if (scrollInfo.metrics.pixels >=
                        scrollInfo.metrics.maxScrollExtent - 300) {
                      if (!_isAtBottomPzPicks) {
                        _isAtBottomPzPicks = true;
                        ref.read(tabPzPicksProvider).loadMoreProducts();
                      }
                      if (!ref.watch(tabPzPicksProvider).isLoading) {
                        _isAtBottomPzPicks = false;
                      }
                    } else {
                      _isAtBottomPzPicks = false;
                    }
                    return false;
                  },
                ),
              ],
            )),
      ),
    );
  }
}
