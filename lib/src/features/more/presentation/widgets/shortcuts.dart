import 'package:flutter/material.dart';
import 'package:pzdeals/src/actions/navigate_screen.dart';
import 'package:pzdeals/src/common_widgets/square_labeled_icons.dart';
import 'package:pzdeals/src/constants/index.dart';
import 'package:pzdeals/src/features/deals/presentation/screens/screen_cc_deals.dart';
import 'package:pzdeals/src/features/more/presentation/screens/index.dart';

class MoreShortcutsWidget extends StatelessWidget {
  const MoreShortcutsWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double itemWidth = screenWidth / 4;

    return GridView.count(
      padding: const EdgeInsets.all(Sizes.paddingAll),
      crossAxisCount: 4,
      crossAxisSpacing: 10,
      mainAxisSpacing: 15,
      childAspectRatio: 2 / 3,
      shrinkWrap: true,
      children: [
        NavigateScreenWidget(
          destinationWidget: const CreditCardDealsScreen(),
          childWidget: SquareLabeledIcon(
            iconTitle: 'Credit Cards',
            iconImage: 'assets/images/shortcuts/creditcards.png',
            iconAssetType: 'asset',
            borderColor: Colors.yellow.shade700,
          ),
          animationDirection: 'leftToRight',
        ),
        NavigateScreenWidget(
          destinationWidget: BlogScreenWidget(),
          childWidget: SquareLabeledIcon(
            iconTitle: 'Blogs',
            iconImage: 'assets/images/shortcuts/blogs.png',
            iconAssetType: 'asset',
            borderColor: Colors.blue.shade900,
          ),
          animationDirection: 'leftToRight',
        ),
        NavigateScreenWidget(
          destinationWidget: BookmarkedScreenWidget(),
          childWidget: const SquareLabeledIcon(
            iconTitle: 'Bookmark',
            iconImage: 'assets/images/shortcuts/bookmark.png',
            iconAssetType: 'asset',
            borderColor: Colors.blue,
          ),
          animationDirection: 'leftToRight',
        ),
        SquareLabeledIcon(
          iconTitle: 'Wish List',
          iconImage: 'assets/images/shortcuts/wishlist.png',
          iconAssetType: 'asset',
          borderColor: Colors.red.shade600,
        ),
      ],
    );
  }
}
