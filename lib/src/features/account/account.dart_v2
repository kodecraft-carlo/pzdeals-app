import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pzdeals/src/constants/color_constants.dart';
import 'package:pzdeals/src/constants/sizes.dart';
import 'package:pzdeals/src/features/account/presentation/screens/index.dart';
import 'package:pzdeals/src/features/account/presentation/widgets/account_card.dart';
import 'package:pzdeals/src/features/account/presentation/widgets/login_card.dart';
import 'package:pzdeals/src/state/auth_user_data.dart';
import 'dart:io' show Platform;

import 'package:pzdeals/src/state/media_query_provider.dart';

class AccountWidget extends ConsumerWidget {
  const AccountWidget({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authUserState = ref.watch(authUserDataProvider);
    final mediaQueryState = ref.watch(mediaqueryProvider);
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
              physics: const NeverScrollableScrollPhysics(),
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
                  SliverToBoxAdapter(
                    child: Padding(
                        padding: const EdgeInsets.only(
                            left: Sizes.paddingLeftSmall,
                            right: Sizes.paddingRightSmall),
                        child: SizedBox(child:
                            LayoutBuilder(builder: (context, constraints) {
                          if (authUserState.isAuthenticated == true) {
                            return AccountCard(
                                accountData: authUserState.userData!);
                          } else {
                            return const LoginCard();
                          }
                        }))),
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
