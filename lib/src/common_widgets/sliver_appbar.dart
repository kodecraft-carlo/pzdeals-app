import 'package:flutter/material.dart';
import 'package:pzdeals/src/actions/navigate_screen.dart';
import 'package:pzdeals/src/common_widgets/appbar_icon.dart';
import 'package:pzdeals/src/features/account/account.dart';
import 'package:pzdeals/src/constants/color_constants.dart';
import 'package:pzdeals/src/constants/sizes.dart';

class SliverAppBarWidget extends StatelessWidget {
  const SliverAppBarWidget(
      {super.key,
      required this.innerBoxIsScrolled,
      required this.searchFieldWidget});

  final bool innerBoxIsScrolled;
  final Widget searchFieldWidget;
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: PZColors.pzWhite,
      automaticallyImplyLeading: false,
      primary: true,
      title: Row(
        children: [
          const AppbarIcon(),
          const SizedBox(width: 8),
          Expanded(
            child: searchFieldWidget,
          ),
        ],
      ),
      actions: const [
        Padding(
          padding: EdgeInsets.only(right: Sizes.paddingRight),
          child: NavigateScreenWidget(
              destinationWidget: AccountWidget(),
              animationDirection: 'bottomToTop',
              childWidget: Icon(
                Icons.account_circle_outlined,
                color: PZColors.pzOrange,
              )),
        ),
      ],
      floating: false,
      pinned: true,
      forceElevated: innerBoxIsScrolled,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          color: PZColors.pzWhite, // Set background color to transparent
        ),
        collapseMode: CollapseMode.pin,
      ),
    );
  }
}
