import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pzdeals/src/constants/color_constants.dart';
import 'package:pzdeals/src/constants/sizes.dart';
import 'package:pzdeals/src/features/account/presentation/screens/index.dart';
import 'package:pzdeals/src/features/account/presentation/widgets/account_card.dart';
import 'package:pzdeals/src/features/account/presentation/widgets/login_card.dart';
import 'package:pzdeals/src/state/auth_user_data.dart';

class AccountWidget extends ConsumerWidget {
  const AccountWidget({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authUserState = ref.watch(authUserDataProvider);
    Widget tabBars;
    Widget tabBarView;
    if (authUserState.isAuthenticated) {
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
            text: 'Notification',
          ),
          Tab(
            text: 'Layout',
          ),
        ],
      );

      tabBarView = TabBarView(
        children: <Widget>[
          authUserState.isAuthenticated == true
              ? const NotificationScreen()
              : const SizedBox(),
          const LayoutScreen(),
        ],
      );
    } else {
      tabBars = TabBar(
        indicatorWeight: 4,
        tabAlignment: TabAlignment.start,
        isScrollable: true,
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
            text: 'Layout',
          ),
        ],
      );

      tabBarView = const TabBarView(
        children: <Widget>[
          LayoutScreen(),
        ],
      );
    }
    return SafeArea(
        top: false,
        child: DefaultTabController(
          length: authUserState.isAuthenticated ? 2 : 1,
          child: Scaffold(
            backgroundColor: Colors.white,
            body: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    elevation: 3.0,
                    backgroundColor: PZColors.pzWhite,
                    automaticallyImplyLeading: false,
                    title: const Text(
                      "Account",
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
        ));
  }
}
