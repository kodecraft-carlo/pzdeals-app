import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pzdeals/src/actions/show_dialog.dart';
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

  void scrollToTop() {
    notificationDisplayKey.currentState!.scrollToTop();
  }

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
                              "Notifications",
                              style: TextStyle(
                                  fontSize: Sizes.headerFontSize,
                                  fontWeight: FontWeight.w600,
                                  color: PZColors.pzBlack),
                            ),
                          )),
                    ),
                    ref.read(notificationsProvider).unreadCount > 0
                        ? markAllAsRead()
                        : const SizedBox.shrink(),
                    const SizedBox(width: Sizes.paddingAllSmall),
                    ref.watch(notificationsProvider).hasNotification == true
                        ? clearNotifications()
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

  Widget clearNotifications() {
    return GestureDetector(
      onTap: () {
        showAlertDialog(context, 'Clear Notifications',
            'Are you sure you want to clear all notifications?', () {
          ref.read(notificationsProvider).removeAllNotification();
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Notification cleared'),
              action: SnackBarAction(
                label: 'UNDO',
                onPressed: () async {
                  ref
                      .read(notificationsProvider)
                      .reinsertAllNotificationToNotificationList();

                  ref.read(notificationsProvider).refreshNotification();
                },
              ),
              duration: const Duration(seconds: 5),
            ),
          );
        }, 'Clear');
      },
      child: RichText(
          text: const TextSpan(
              text: 'Clear all',
              style: TextStyle(
                  fontSize: Sizes.bodyFontSize,
                  color: PZColors.pzOrange,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600))),
    );
  }

  Widget markAllAsRead() {
    return GestureDetector(
        onTap: () {
          showAlertDialog(context, 'Read Notifications',
              'Are you sure you want to mark all notifications as read? This action cannot be undone.',
              () {
            ref.read(notificationsProvider).markAllAsRead();
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Marked all notifications as read'),
                duration: Duration(seconds: 2),
              ),
            );
          }, 'Confirm');
        },
        child: RichText(
          text: TextSpan(children: [
            const WidgetSpan(
                child: Icon(
              Icons.done_all,
              color: PZColors.pzOrange,
              size: Sizes.smallIconSize,
            )),
            TextSpan(
              text: 'Read all(${ref.read(notificationsProvider).unreadCount})',
              style: const TextStyle(
                  fontSize: Sizes.bodyFontSize,
                  color: PZColors.pzOrange,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins'),
            )
          ]),
        ));
  }
}
