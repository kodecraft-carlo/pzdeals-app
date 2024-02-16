import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:pzdeals/src/common_widgets/sliver_appbar.dart';
import 'package:pzdeals/src/constants/color_constants.dart';
import 'package:pzdeals/src/features/deals/presentation/screens/index.dart';
import 'package:pzdeals/src/features/deals/presentation/widgets/index.dart';

class DealsTabControllerWidget extends StatelessWidget {
  const DealsTabControllerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 1,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBarWidget(
                  innerBoxIsScrolled: innerBoxIsScrolled,
                  searchFieldWidget: const HomescreenSearchFieldWidget(
                    hintText: "Search deals",
                  )),
              const SliverToBoxAdapter(
                child: CreditCardDealsWidget(),
              ),
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
                    color:
                        PZColors.pzWhite, // Set background color to transparent
                  ),
                  collapseMode: CollapseMode.pin,
                ),
                bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(0),
                    child: TabBar(
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
                      tabs: const <Widget>[
                        Tab(
                          text: 'For You',
                        ),
                        Tab(
                          text: 'Front Page',
                        ),
                        Tab(
                          text: 'PZ Picks',
                        ),
                      ],
                    )),
                titleSpacing: 0,
              ),
            ];
          },
          body: Column(
            children: [
              Expanded(
                child: TabBarView(
                  children: <Widget>[
                    const ForYouWidget(),
                    FrontPageDealsWidget(),
                    PZPicksScreenWidget()
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
