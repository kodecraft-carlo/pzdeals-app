import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:pzdeals/src/actions/show_snackbar.dart';
import 'package:pzdeals/src/common_widgets/product_dialog.dart';
import 'package:pzdeals/src/constants/color_constants.dart';
import 'package:pzdeals/src/constants/sizes.dart';
import 'package:pzdeals/src/features/deals/models/index.dart';
import 'package:pzdeals/src/features/deals/presentation/widgets/index.dart';
import 'package:pzdeals/src/features/deals/services/fetch_deals.dart';
import 'package:pzdeals/src/features/navigationwidget.dart';
import 'package:pzdeals/src/features/notifications/presentation/widgets/index.dart';
import 'package:pzdeals/src/features/notifications/state/notification_provider.dart';

class NotificationScreen extends ConsumerStatefulWidget {
  const NotificationScreen({super.key});
  @override
  NotificationScreenState createState() => NotificationScreenState();
}

class NotificationScreenState extends ConsumerState<NotificationScreen>
    with TickerProviderStateMixin {
  late final AnimationController _animationController;
  final _scrollController = ScrollController(keepScrollOffset: true);
  String title = '';
  String value = '';
  String productid = '';
  String notifId = '';

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this);
    _scrollController.addListener(_onScroll);

    Future(() {
      ref.read(notificationsProvider).loadNotifications();
    });

    Future(() {
      final arguments = ModalRoute.of(context)!.settings.arguments;

      if (arguments != null && arguments is Map<String, dynamic>) {
        value = arguments['value'] as String;
        title = arguments['title'] as String;
        productid = arguments['product_id'] as String;
        notifId = arguments['notification_id'] as String;
        if (productid != '') {
          showProductDeal(int.parse(productid));
        }
      }
    });
  }

  FetchProductDealService productDealService = FetchProductDealService();
  void showProductDeal(int productId) {
    debugPrint('mark as read: $notifId');
    ref.read(notificationsProvider).markAsRead(notifId);
    // if (mounted) {
    // LoadingDialog.show(context);
    loadProduct(productId).then((product) {
      // if (mounted) {
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
                    hasDescription: product.productDealDescription != null &&
                        product.productDealDescription != '',
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
      // LoadingDialog.hide(context);
      // }
    });
    // }
  }

  Future<ProductDealcardData> loadProduct(int productId) async {
    final product = await productDealService.fetchProductInfo(productId);
    return product;
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      ref.read(notificationsProvider).loadMoreNotifications();
    }
  }

  void scrollToTop() {
    _scrollController.animateTo(
      0.0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    // final message = ModalRoute.of(context)!.settings.arguments as String;
    // debugPrint('message: $message');
    final notificationState = ref.watch(notificationsProvider);
    Widget notificationWidget;
    if (notificationState.isLoading &&
        notificationState.notifications.isEmpty) {
      notificationWidget = const Expanded(
        child: Center(child: CircularProgressIndicator.adaptive()),
      );
    } else if (notificationState.notifications.isEmpty) {
      notificationWidget = Expanded(
          // padding: const EdgeInsets.all(Sizes.paddingAll),
          child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/images/lottie/empty.json',
              height: 200,
              fit: BoxFit.fitHeight,
              frameRate: FrameRate.max,
              controller: _animationController,
              onLoaded: (composition) {
                _animationController
                  ..duration = composition.duration
                  ..forward();
              },
            ),
            const SizedBox(height: Sizes.spaceBetweenSections),
            const Text(
              'No notifications yet',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: Sizes.fontSizeMedium, color: PZColors.pzGrey),
            ),
            const SizedBox(height: Sizes.spaceBetweenContentSmall),
          ],
        ),
      ));
    } else {
      final notifData = notificationState.notifications;
      notificationWidget = Expanded(
          child: Column(
        children: [
          Expanded(
            child: RefreshIndicator.adaptive(
                displacement: 20,
                edgeOffset: 10,
                color: PZColors.pzOrange,
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  controller: _scrollController,
                  // physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: notifData.length,
                  itemBuilder: (BuildContext context, int index) {
                    return NotificationCardWidget(
                      notificationData: notifData[index],
                      // onCardTap: (int productId) {
                      //   showProductDeal(productId);
                      // },
                    );
                  },
                ),
                onRefresh: () async {
                  ref.read(notificationsProvider).refreshNotification();
                }),
          ),
          notificationState.isLoading
              ? Container(
                  color: Colors.transparent,
                  padding:
                      const EdgeInsets.symmetric(vertical: Sizes.paddingAll),
                  child:
                      const Center(child: CircularProgressIndicator.adaptive()),
                )
              : const SizedBox.shrink()
        ],
      ));
    }

    return PopScope(
        canPop: false,
        onPopInvoked: (didPop) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const NavigationWidget(
                        initialPageIndex: 0,
                      )));
        },
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.only(
                top: Sizes.paddingTopSmall,
                left: Sizes.paddingLeft,
                right: Sizes.paddingRight),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: GestureDetector(
                            onTap: () {
                              scrollToTop();
                            },
                            child: const Text(
                              "Notification",
                              style: TextStyle(
                                  fontSize: Sizes.headerFontSize,
                                  fontWeight: FontWeight.w600,
                                  color: PZColors.pzBlack),
                            ),
                          )),
                    ),
                    notificationState.notifications.isNotEmpty
                        ? GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog.adaptive(
                                    title: const Text('Clear Notifications'),
                                    content: const Text(
                                        'Are you sure you want to clear all notifications?'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text(
                                          'Cancel',
                                          style: TextStyle(
                                              color: PZColors.pzBlack),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          ref
                                              .read(notificationsProvider)
                                              .removeAllNotification();
                                          Navigator.of(context).pop();
                                          showSnackbarWithMessage(
                                              context, 'Notifications cleared');
                                        },
                                        child: const Text(
                                          'Clear',
                                          style: TextStyle(
                                              color: PZColors.pzOrange),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: const Text('Clear',
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                    fontSize: Sizes.bodyFontSize,
                                    color: PZColors.pzOrange,
                                    fontWeight: FontWeight.w600)),
                          )
                        : const SizedBox.shrink(),
                  ],
                ),
                const SizedBox(height: Sizes.spaceBetweenSections),
                notificationWidget,
                const SizedBox(height: Sizes.paddingBottomSmall)
              ],
            ),
          ),
        ));
  }
}
