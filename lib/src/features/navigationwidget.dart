import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pzdeals/src/common_widgets/custom_scaffold.dart';
import 'package:pzdeals/src/common_widgets/product_dialog.dart';
import 'package:pzdeals/src/constants/index.dart';
import 'package:pzdeals/src/features/alerts/alerts.dart';
import 'package:pzdeals/src/features/deals/deals.dart';
import 'package:pzdeals/src/features/deals/models/index.dart';
import 'package:pzdeals/src/features/deals/presentation/widgets/product_deal_description.dart';
import 'package:pzdeals/src/features/deals/services/fetch_deals.dart';
import 'package:pzdeals/src/features/more/more.dart';
import 'package:pzdeals/src/features/notifications/notifications.dart';
import 'package:pzdeals/src/features/notifications/state/notification_provider.dart';
import 'package:pzdeals/src/features/stores/state/stores_provider.dart';
import 'package:pzdeals/src/features/stores/stores.dart';
import 'package:pzdeals/src/state/directus_auth_service.dart';
import 'package:badges/badges.dart' as badges;

class NavigationWidget extends ConsumerStatefulWidget {
  final int initialPageIndex;
  final Map<String, dynamic> arguments;
  const NavigationWidget(
      {super.key, this.initialPageIndex = 0, this.arguments = const {}});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _NavigationWidgetState();
}

class _NavigationWidgetState extends ConsumerState<NavigationWidget> {
  late int currentPageIndex;
  int unreadNotificationCount = 0;
  String id = '';
  String dealType = '';
  String notifId = '';
  FetchProductDealService productDealService = FetchProductDealService();
  final GlobalKey<DealsTabControllerWidgetState> dealsKey =
      GlobalKey<DealsTabControllerWidgetState>();
  final GlobalKey<StoresWidgetState> storesKey = GlobalKey<StoresWidgetState>();
  final GlobalKey<NotificationScreenState> notificationKey =
      GlobalKey<NotificationScreenState>();
  final GlobalKey<DealAlertsScreenState> alertsKey =
      GlobalKey<DealAlertsScreenState>();
  late List<Widget> _pages;
  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   final userAuthState = ref.watch(authUserDataProvider);
  //   final user = userAuthState.userData;

  //   if (user != null) {
  //     updateNotificationsCount(user.uid);
  //     ref.read(notificationsProvider).refreshNotification();
  //   }
  // }

  @override
  void initState() {
    super.initState();
    currentPageIndex = widget.initialPageIndex;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authService = ref.read(directusAuthServiceProvider);
      // authService.login().then((_) {
      //   debugPrint(
      //       "${DateTime.now()}: directus login successful ${authService.getAccessToken()}");
      //   refreshTokenPeriodically(ref);
      // }).catchError((error) {
      //   debugPrint('directus login error $error');
      // });
    });

    Future(() {
      if (widget.arguments.isNotEmpty) {
        debugPrint('arguments: ${widget.arguments}');
        id = widget.arguments['product_id'] as String;
        // dealType = widget.arguments['type'] as String;
        notifId = widget.arguments['notification_id'] as String;
        // if (dealType != '' && dealType == 'price_mistake') {
        //   debugPrint('from price_mistake id: $id');
        //   if (id != '') {
        //     showProductDeal(int.parse(id));
        //   }
        // } else if (dealType != '' && dealType == 'deeplink') {
        //   debugPrint('from deeplink id: $id');
        //   if (id != '') {
        //     showProductDeal(int.parse(id));
        //   }
        // } else {
        //   debugPrint('from others id: $id');
        //   if (id != '') {
        showProductDeal(int.parse(id));
        //   }
        // }
      } else {
        debugPrint('no arguments');
      }
    });
    // Future(() {
    //   final arguments = ModalRoute.of(context)!.settings.arguments;

    //   if (arguments != null && arguments is Map<String, dynamic>) {
    //     id = arguments['product_id'] as String;
    //     dealType = arguments['type'] as String;
    //     if (dealType != '' && dealType == 'price_mistake') {
    //       debugPrint('from price_mistake id: $id');
    //       if (id != '') {
    //         showProductDeal(int.parse(id));
    //       }
    //     } else if (dealType != '' && dealType == 'deeplink') {
    //       debugPrint('from deeplink id: $id');
    //       if (id != '') {
    //         showProductDeal(int.parse(id));
    //       }
    //     } else {
    //       debugPrint('from others id: $id');
    //       if (id != '') {
    //         showProductDeal(int.parse(id));
    //       }
    //     }
    //   }
    // });

    _pages = <Widget>[
      PopScope(
          canPop: false,
          onPopInvoked: (didPop) async {
            if (didPop) {
              return;
            }

            final bool exit = await onback(context);
            if (exit) {
              SystemNavigator.pop();
            }
          },
          child: DealsTabControllerWidget(key: dealsKey)),
      StoresWidget(key: storesKey),
      NotificationScreen(key: notificationKey),
      DealAlertsScreen(key: alertsKey),
      MoreScreen()
    ];
  }

  void showProductDeal(int productId) {
    ref.read(notificationsProvider).refreshNotification();
    loadProduct(productId).then((product) {
      debugPrint('notifiId: $notifId');
      if (notifId != '') {
        Future.delayed(const Duration(milliseconds: 1000), () {
          ref.read(notificationsProvider).markAsRead(notifId);
        });
      }

      showDialog(
        context: context,
        useRootNavigator: false,
        barrierDismissible: true,
        builder: (context) => ScaffoldMessenger(
          child: Builder(
            builder: (context) => Scaffold(
              backgroundColor: Colors.transparent,
              body: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                behavior: HitTestBehavior.opaque,
                child: GestureDetector(
                  onTap: () {},
                  child: ProductContentDialog(
                    productData: product,
                    content: ProductDealDescription(
                      snackbarContext: context,
                      productData: product,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  void scrollChildrenToTop() {
    if (currentPageIndex == 0) {
      dealsKey.currentState?.scrollToTop();
    }
    if (currentPageIndex == 1) {
      storesKey.currentState?.scrollToTop();
    }
    if (currentPageIndex == 2) {
      notificationKey.currentState?.scrollToTop();
    }
    if (currentPageIndex == 3) {
      alertsKey.currentState?.scrollToTop();
    }
  }

  Future<ProductDealcardData> loadProduct(int productId) async {
    final product = await productDealService.fetchProductInfo(productId);
    return product;
  }

  void refreshTokenPeriodically(WidgetRef ref) {
    final authService = ref.read(directusAuthServiceProvider);
    Timer.periodic(const Duration(minutes: 13), (timer) {
      authService.refreshTokens().then((_) {
        debugPrint('${DateTime.now()}: Token refreshed successfully');
      }).catchError((error) {
        debugPrint('Token refresh failed: $error');
      });
    });
  }

  void destinationSelected(int index) {
    if (index == 0) {
      ref.read(tabFrontPageProvider).refresh();
      dealsKey.currentState?.setTabIndex(1);
      dealsKey.currentState?.scrollToTop();
    }
    if (index == 1) {
      ref.read(storescreenProvider).clearFilter();
      // ref.read(storescreenProvider).refresh();
    }
    if (index == 2) {
      ref.read(notificationsProvider).refreshNotification();
    }
    setState(() {
      currentPageIndex = index;
    });
  }

  Future<bool> onback(BuildContext context) async {
    bool? exitApp = await showDialog(
      context: context,
      builder: ((context) {
        return AlertDialog(
          title: const Text('Are you sure to exit?',
              style: TextStyle(
                fontSize: 15,
              )),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text('No')),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: const Text('Yes'))
          ],
        );
      }),
    );

    return exitApp ?? false;
  }

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

  @override
  Widget build(BuildContext context) {
    return CustomScaffoldWidget(
        scaffold: Scaffold(
          bottomNavigationBar: SafeArea(
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
                    ? const Border(
                        top: BorderSide(color: Colors.black12, width: 0.5))
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
                          showBadge:
                              ref.watch(notificationsProvider).unreadCount > 0,
                          badgeContent: Text(
                            ref
                                .watch(notificationsProvider)
                                .unreadCount
                                .toString(),
                            style: const TextStyle(
                                color: Colors.white, fontSize: 10),
                          ),
                          position:
                              badges.BadgePosition.topEnd(top: -9, end: -20),
                          badgeStyle: const badges.BadgeStyle(
                            badgeColor: PZColors.pzOrange,
                            elevation: 0,
                          ),
                          badgeAnimation: const badges.BadgeAnimation.fade(
                            animationDuration: Duration(milliseconds: 200),
                            colorChangeAnimationDuration:
                                Duration(milliseconds: 200),
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
          ),
          body: SafeArea(child: _pages[currentPageIndex]),
        ),
        scrollAction: scrollChildrenToTop);
  }
}
