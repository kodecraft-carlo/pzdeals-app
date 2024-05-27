import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pzdeals/src/actions/show_snackbar.dart';
import 'package:pzdeals/src/common_widgets/product_dialog.dart';
import 'package:pzdeals/src/constants/color_constants.dart';
import 'package:pzdeals/src/constants/sizes.dart';
import 'package:pzdeals/src/features/deals/models/index.dart';
import 'package:pzdeals/src/features/deals/presentation/widgets/index.dart';
import 'package:pzdeals/src/features/deals/services/fetch_deals.dart';
import 'package:pzdeals/src/features/navigationwidget.dart';
import 'package:pzdeals/src/features/notifications/presentation/screens/index.dart';
import 'package:pzdeals/src/features/notifications/state/notification_provider.dart';

class NotificationScreen extends ConsumerStatefulWidget {
  const NotificationScreen({super.key});
  @override
  NotificationScreenState createState() => NotificationScreenState();
}

class NotificationScreenState extends ConsumerState<NotificationScreen> {
  String title = '';
  String value = '';
  String productid = '';
  String notifId = '';

  GlobalKey<NotificationsDisplayState> notificationDisplayKey =
      GlobalKey<NotificationsDisplayState>();
  @override
  void initState() {
    super.initState();

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
  Widget build(BuildContext context) {
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
                              notificationDisplayKey.currentState!
                                  .scrollToTop();
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
                    ref.watch(notificationsProvider).unreadCount > 0
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
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: const Text(
                                                  'Notification cleared'),
                                              action: SnackBarAction(
                                                label: 'UNDO',
                                                onPressed: () async {
                                                  ref
                                                      .read(
                                                          notificationsProvider)
                                                      .reinsertAllNotificationToNotificationList();

                                                  ref
                                                      .read(
                                                          notificationsProvider)
                                                      .refreshNotification();
                                                },
                                              ),
                                              duration:
                                                  const Duration(seconds: 5),
                                            ),
                                          );
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
                NotificationsDisplay(key: notificationDisplayKey),
                const SizedBox(height: Sizes.paddingBottomSmall)
              ],
            ),
          ),
        ));
  }
}
