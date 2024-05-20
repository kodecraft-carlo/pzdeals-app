import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pzdeals/src/common_widgets/product_dialog.dart';
import 'package:pzdeals/src/constants/index.dart';
import 'package:pzdeals/src/features/alerts/alerts.dart';
import 'package:pzdeals/src/features/deals/deals.dart';
import 'package:pzdeals/src/features/deals/models/index.dart';
import 'package:pzdeals/src/features/deals/presentation/widgets/product_deal_description.dart';
import 'package:pzdeals/src/features/deals/services/fetch_deals.dart';
import 'package:pzdeals/src/features/deals/state/provider_notificationdeals.dart';
import 'package:pzdeals/src/features/more/more.dart';
import 'package:pzdeals/src/features/notifications/notifications.dart';
import 'package:pzdeals/src/features/notifications/state/notification_provider.dart';
import 'package:pzdeals/src/features/stores/state/stores_provider.dart';
import 'package:pzdeals/src/features/stores/stores.dart';
import 'package:pzdeals/src/models/index.dart';
import 'package:pzdeals/src/state/auth_user_data.dart';
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final userAuthState = ref.watch(authUserDataProvider);
    final user = userAuthState.userData;

    if (user != null) {
      updateNotificationsCount(user.uid);
      ref.read(notificationsProvider).refreshNotification();
    }
  }

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

    // Future(() {
    //   if (widget.arguments.isNotEmpty) {
    //     debugPrint('arguments: ${widget.arguments}');
    //     id = widget.arguments['product_id'] as String;
    //     dealType = widget.arguments['type'] as String;
    //     notifId = widget.arguments['notification_id'] as String;
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
    //   } else {
    //     debugPrint('no arguments');
    //   }
    // });
    Future(() {
      final arguments = ModalRoute.of(context)!.settings.arguments;

      if (arguments != null && arguments is Map<String, dynamic>) {
        id = arguments['product_id'] as String;
        dealType = arguments['type'] as String;
        if (dealType != '' && dealType == 'price_mistake') {
          debugPrint('from price_mistake id: $id');
          if (id != '') {
            showProductDeal(int.parse(id));
          }
        } else if (dealType != '' && dealType == 'deeplink') {
          debugPrint('from deeplink id: $id');
          if (id != '') {
            showProductDeal(int.parse(id));
          }
        } else {
          debugPrint('from others id: $id');
          if (id != '') {
            showProductDeal(int.parse(id));
          }
        }
      }
    });
  }

  void updateNotificationsCount(String userId) {
    FirebaseFirestore.instance
        .collection('notifications')
        .doc(userId)
        .collection('notification')
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      if (mounted) {
        unreadNotificationCount = 0;
        snapshot.docs.forEach((doc) {
          if (doc.exists && doc['isRead'] == false) {
            unreadNotificationCount++;
          }
        });
        ref.read(notificationsProvider).refreshNotification();
        setState(() {
          debugPrint('unreadNotificationCount: $unreadNotificationCount');
          unreadNotificationCount = unreadNotificationCount;
        });
      }
    });
  }

  void showProductDeal(int productId) {
    loadProduct(productId).then((product) {
      debugPrint('notifiId: $notifId');
      if (notifId != '') {
        ref.read(notificationsProvider).markAsRead(notifId);
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
    if (index == 1) {
      ref.read(storescreenProvider).clearFilter();
      // ref.read(storescreenProvider).refresh();
    }
    if (index == 0) {
      ref.read(tabFrontPageProvider).refresh();
      dealsKey.currentState?.setTabIndex(1);
    }
    if (index == 2) {
      ref.read(notificationsProvider).refreshNotification();
    }
    setState(() {
      currentPageIndex = index;
    });
  }

  Future<bool> _onback(BuildContext context) async {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                highlightColor: Colors.transparent),
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
                selectedLabelStyle: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontSize: 12,
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
                    label: 'Stores',
                  ),
                  BottomNavigationBarItem(
                    icon: badges.Badge(
                      showBadge: unreadNotificationCount > 0,
                      badgeContent: Text(
                        unreadNotificationCount.toString(),
                        style:
                            const TextStyle(color: Colors.white, fontSize: 10),
                      ),
                      position: badges.BadgePosition.topEnd(top: -9, end: -20),
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
                    label: 'Notification',
                  ),
                  BottomNavigationBarItem(
                    icon: currentPageIndex == 3
                        ? const Icon(Icons.campaign_rounded)
                        : const Icon(Icons.campaign_outlined),
                    label: 'Deal Alert',
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
      body: SafeArea(
          child: <Widget>[
        PopScope(
            canPop: false,
            onPopInvoked: (didPop) async {
              if (didPop) {
                return;
              }

              final bool exit = await _onback(context);
              if (exit) {
                SystemNavigator.pop();
              }
            },
            child: DealsTabControllerWidget(key: dealsKey)),
        const StoresWidget(),
        const NotificationScreen(),
        const DealAlertsScreen(),
        MoreScreen()
      ][currentPageIndex]),
    );
  }
}
