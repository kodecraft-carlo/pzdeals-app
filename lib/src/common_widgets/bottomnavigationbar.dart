import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pzdeals/src/constants/index.dart';
import 'package:pzdeals/src/features/navigationwidget.dart';
import 'package:pzdeals/src/features/notifications/state/notification_provider.dart';

class BottomNavigationBarWidget extends ConsumerStatefulWidget {
  final int currentPageIndex;
  const BottomNavigationBarWidget({super.key, this.currentPageIndex = 0});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      BottomNavigationBarWidgetState();
}

class BottomNavigationBarWidgetState
    extends ConsumerState<BottomNavigationBarWidget> {
  late int currentPageIndex;

  @override
  void initState() {
    super.initState();
    currentPageIndex = widget.currentPageIndex;
  }

  @override
  Widget build(BuildContext context) {
    double getFontSize(BuildContext context) {
      double screenWidth = MediaQuery.of(context).size.width;
      if (screenWidth < 350) {
        return 10.0;
      } else if (screenWidth < 400) {
        return 11.0;
      } else {
        return 12.0;
      }
    }

    void destinationSelected(int index) {
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              NavigationWidget(
            initialPageIndex: index,
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 150),
        ),
      );
      setState(() {
        currentPageIndex = index;
      });
    }

    return SafeArea(
      top: false,
      child: Container(
        height: 65,
        decoration: BoxDecoration(
          boxShadow: [
            //borderside at the top if platform is ios and box shadow if platform is android
            if (Theme.of(context).platform == TargetPlatform.android)
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
          ],
          border: Theme.of(context).platform == TargetPlatform.iOS
              ? const Border(top: BorderSide(color: Colors.black12, width: 0.5))
              : null,
        ),
        child: Theme(
          data: ThemeData(
            fontFamily: 'Poppins',
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            textTheme: Theme.of(context).textTheme.copyWith(
                  bodySmall: TextStyle(
                      fontSize: getFontSize(
                          context)), // Use the helper function from the previous response
                ),
          ),
          child: SizedBox(
            height: 65,
            child: SafeArea(
                child: BottomNavigationBar(
              currentIndex: currentPageIndex,
              elevation: 0,
              onTap: destinationSelected,
              selectedItemColor: Colors.black87,
              unselectedItemColor: Colors.black54,
              selectedIconTheme:
                  const IconThemeData(size: 25, color: Colors.black87),
              unselectedIconTheme:
                  const IconThemeData(size: 25, color: Colors.black54),
              selectedLabelStyle: TextStyle(
                fontSize: getFontSize(context),
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: TextStyle(
                fontSize: getFontSize(context),
                fontWeight: FontWeight.w600,
              ),
              showSelectedLabels: true,
              showUnselectedLabels: true,
              enableFeedback: true,
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.white,
              items: [
                BottomNavigationBarItem(
                  icon: currentPageIndex == 0
                      ? const Icon(Icons.local_offer_rounded)
                      : const Icon(Icons.local_offer_outlined),
                  label: 'Deals',
                ),
                BottomNavigationBarItem(
                  icon: currentPageIndex == 1
                      ? const Icon(Icons.store_rounded)
                      : const Icon(Icons.store_outlined),
                  label: 'Promos',
                ),
                BottomNavigationBarItem(
                  icon: badges.Badge(
                    showBadge: ref.watch(notificationsProvider).unreadCount > 0,
                    badgeContent: Text(
                      ref.watch(notificationsProvider).unreadCount.toString(),
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                    ),
                    position: badges.BadgePosition.topEnd(top: -9, end: -20),
                    badgeStyle: const badges.BadgeStyle(
                      badgeColor: PZColors.pzOrange,
                      elevation: 0,
                    ),
                    badgeAnimation: const badges.BadgeAnimation.fade(
                      animationDuration: Duration(milliseconds: 200),
                      colorChangeAnimationDuration: Duration(milliseconds: 200),
                      loopAnimation: false,
                      curve: Curves.fastOutSlowIn,
                      colorChangeAnimationCurve: Curves.easeInCubic,
                    ),
                    child: currentPageIndex == 2
                        ? const Icon(Icons.notifications_active_rounded)
                        : const Icon(Icons.notifications_outlined),
                  ),
                  label: 'Notifications',
                ),
                BottomNavigationBarItem(
                  icon: currentPageIndex == 3
                      ? const Icon(Icons.campaign_rounded)
                      : const Icon(Icons.campaign_outlined),
                  label: 'Deal Alerts',
                ),
                BottomNavigationBarItem(
                  icon: currentPageIndex == 4
                      ? const Icon(Icons.more_horiz)
                      : const Icon(Icons.more_horiz),
                  label: 'More',
                ),
              ],
            )),
          ),
        ),
      ),
    );
  }
}
