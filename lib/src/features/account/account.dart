import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pzdeals/src/constants/color_constants.dart';
import 'package:pzdeals/src/constants/sizes.dart';
import 'package:pzdeals/src/features/account/presentation/screens/index.dart';
import 'package:pzdeals/src/features/account/presentation/widgets/account_card.dart';
import 'package:pzdeals/src/features/account/presentation/widgets/login_card.dart';
import 'package:pzdeals/src/state/auth_user_data.dart';
import 'dart:io' show Platform;

import 'package:pzdeals/src/state/media_query_provider.dart';
import 'package:pzdeals/src/utils/helpers/check_screen_size.dart';

class AccountWidget extends ConsumerStatefulWidget {
  const AccountWidget({super.key});
  @override
  AccountWidgetState createState() => AccountWidgetState();
}

class AccountWidgetState extends ConsumerState<AccountWidget> {
  @override
  Widget build(BuildContext context) {
    final authUserState = ref.watch(authUserDataProvider);
    final mediaQueryState = ref.watch(mediaqueryProvider);
    bool smallScreen = isSmallScreen(context);
    Widget tabBars;
    Widget tabBarView;
    tabBars = TabBar(
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
          text: 'Notifications',
        ),
        Tab(
          text: 'Layout',
        ),
      ],
    );

    tabBarView = const TabBarView(
      children: <Widget>[
        NotificationScreen(),
        LayoutScreen(),
      ],
    );
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: TextScaler.linear(mediaQueryState.textScaler),
      ),
      child: SafeArea(
        top: false,
        bottom: Platform.isIOS ? false : true,
        child: DefaultTabController(
          length: 2,
          child: Scaffold(
            backgroundColor: Colors.white,
            body: NestedScrollView(
              physics: smallScreen == true
                  ? const AlwaysScrollableScrollPhysics()
                  : const NeverScrollableScrollPhysics(),
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    elevation: 3.0,
                    backgroundColor: PZColors.pzWhite,
                    centerTitle: false,
                    automaticallyImplyLeading: false,
                    title: const Text(
                      "Account",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: Sizes.headerFontSize,
                          fontWeight: FontWeight.w600,
                          color: PZColors.pzBlack),
                    ),
                    actions: [
                      IconButton(
                        icon: const Icon(
                          Icons.close,
                          size: 30,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                    floating: false,
                    pinned: true,
                    forceElevated: innerBoxIsScrolled,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Container(
                        color: PZColors
                            .pzWhite, // Set background color to transparent
                      ),
                      collapseMode: CollapseMode.pin,
                    ),
                  ),
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: _SliverPinnedCardDelegate(
                      child: Container(
                        height: authUserState.isAuthenticated == true ? 80 : 90,
                        color: Colors.white,
                        child: Padding(
                            padding: const EdgeInsets.only(
                                left: Sizes.paddingLeftSmall,
                                right: Sizes.paddingRightSmall),
                            child: authUserState.isAuthenticated == true
                                ? AccountCard(
                                    accountData: authUserState.userData!)
                                : const LoginCard()),
                      ),
                    ),
                  ),

                  // SliverAppBar(
                  //   titleSpacing: 0,
                  //   automaticallyImplyLeading: false,
                  //   backgroundColor: PZColors.pzWhite,
                  //   surfaceTintColor: PZColors.pzWhite,
                  //   floating: false,
                  //   pinned: true,
                  //   forceElevated: innerBoxIsScrolled,
                  //   collapsedHeight:
                  //       authUserState.isAuthenticated == true ? 60 : 70,
                  //   flexibleSpace: PreferredSize(
                  //     preferredSize: const Size.fromHeight(kToolbarHeight),
                  //     child: Padding(
                  //       padding: const EdgeInsets.only(
                  //           left: Sizes.paddingLeftSmall,
                  //           right: Sizes.paddingRightSmall),
                  //       child: SizedBox(
                  //         child: LayoutBuilder(builder: (context, constraints) {
                  //           if (authUserState.isAuthenticated == true) {
                  //             return AccountCard(
                  //                 accountData: authUserState.userData!);
                  //           } else {
                  //             return const LoginCard();
                  //           }
                  //         }),
                  //       ),
                  //     ),
                  //   ),
                  // ),
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
                    title: tabBars,
                    titleSpacing: 0,
                  ),
                ];
              },
              body: tabBarView,
            ),
          ),
        ),
      ),
    );
  }
}

class _SliverPinnedCardDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _SliverPinnedCardDelegate({required this.child});

  @override
  double get minExtent => 80;

  @override
  double get maxExtent => 80;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
