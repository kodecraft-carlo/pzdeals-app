import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pzdeals/src/common_widgets/product_dialog.dart';
import 'package:pzdeals/src/constants/index.dart';
import 'package:pzdeals/src/features/deals/models/index.dart';
import 'package:pzdeals/src/features/deals/presentation/widgets/index.dart';
import 'package:pzdeals/src/features/deals/services/fetch_deals.dart';
import 'package:pzdeals/src/features/notifications/presentation/widgets/notification_dialog.dart';
import 'package:pzdeals/src/features/notifications/state/notification_provider.dart';
import 'package:pzdeals/src/models/index.dart';
import 'package:pzdeals/src/utils/storage/network_image_cache_manager.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationCardWidget extends ConsumerStatefulWidget {
  const NotificationCardWidget({super.key, required this.notificationData});

  final NotificationData notificationData;
  @override
  NotificationCardWidgetState createState() => NotificationCardWidgetState();
}

class NotificationCardWidgetState
    extends ConsumerState<NotificationCardWidget> {
  FetchProductDealService productDealService = FetchProductDealService();
  void showProductDeal(int productId, String notificationId) {
    if (mounted) {
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
        ref.read(notificationsProvider).markAsRead(notificationId);
        // LoadingDialog.hide(context);
        // }
      });
    }
  }

  Future<ProductDealcardData> loadProduct(int productId) async {
    final product = await productDealService.fetchProductInfo(productId);
    return product;
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.notificationData.data;
    final notificationData = widget.notificationData;
    final notificationState = ref.read(notificationsProvider);
    return Dismissible(
      key: Key(notificationData.id),
      onDismissed: (direction) {
        notificationState.removeNotification(notificationData.id);
        final scaffoldMessenger = ScaffoldMessenger.of(context);

        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: const Text('Notification cleared'),
            action: SnackBarAction(
              label: 'UNDO',
              onPressed: () async {
                notificationState.reinsertNotificationToNotificationList(
                    notificationData.id);
                notificationState
                    .removeNotificationIdFromDeletionList(notificationData.id);

                notificationState.refreshNotification();
              },
            ),
            duration: const Duration(seconds: 5),
          ),
        );
      },
      background: Container(
          margin: const EdgeInsets.symmetric(vertical: 5),
          decoration: BoxDecoration(
            color: PZColors.pzOrange,
            borderRadius: BorderRadius.circular(Sizes.cardBorderRadius),
          ),
          padding: const EdgeInsets.only(right: Sizes.paddingAll),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 50,
              ),
              Text('Clear notification',
                  style: TextStyle(
                      color: PZColors.pzWhite,
                      fontSize: Sizes.fontSizeSmall,
                      fontWeight: FontWeight.w600)),
              Icon(Icons.delete_forever_rounded,
                  color: PZColors.pzWhite, size: 25)
            ],
          )),
      direction: DismissDirection.endToStart,
      child: GestureDetector(
        onTap: () {
          if (notificationData.data != null || notificationData.data != {}) {
            debugPrint('Notification Data: $data');
            if (data['alert_type'] == 'keyword') {
              showProductDeal(int.parse(data['item_id']), notificationData.id);
              // Navigator.of(context).pushNamed('/keyword-deals', arguments: {
              //   'title': notificationData.title,
              //   'keyword': data['value'],
              //   'product_id': data['item_id'] ?? ''
              // });
            } else if (data['alert_type'] == 'percentage') {
              showProductDeal(int.parse(data['item_id']), notificationData.id);
              // Navigator.of(context).pushNamed('/percentage-deals', arguments: {
              //   'title': notificationData.title,
              //   'value': data['value'],
              //   'product_id': data['item_id'] ?? ''
              // });
            } else if (data['alert_type'] == 'price-mistake' ||
                data['alert_type'] == 'front_page' ||
                data['alert_type'] == 'front-page') {
              debugPrint('Notification Data: $data');
              showProductDeal(int.parse(data['item_id']), notificationData.id);
              // Navigator.of(context).pushNamed('/deals', arguments: {
              //   'type': 'price_mistake',
              //   'product_id': data['id'] ?? ''
              // });
            } else if (data['alert_type'] == 'category') {
              showProductDeal(int.parse(data['id']), notificationData.id);
              // Navigator.of(context).pushNamed('/deal-collections', arguments: {
              //   'value': data['value'],
              //   'product_id': data['id'] ?? ''
              // });
            } else {
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
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                            child: NotificationDialog(
                                notificationData: notificationData),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }
          }
        },
        child: Card(
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          color: notificationData.isRead
              ? PZColors.pzLightGrey.withOpacity(.3)
              : PZColors.pzOrange.withOpacity(.1),
          margin: const EdgeInsets.symmetric(vertical: 5),
          clipBehavior: Clip.hardEdge,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Sizes.cardBorderRadius),
            side: BorderSide(
                color: notificationData.isRead
                    ? PZColors.pzGrey.withOpacity(.2)
                    : PZColors.pzOrange.withOpacity(.2),
                width: 1),
          ),
          child: ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Sizes.cardBorderRadius),
            ),
            // isThreeLine: true,
            leading: notificationData.imageUrl == ''
                ? CircleAvatar(
                    backgroundColor: PZColors.pzOrange,
                    child: Transform.rotate(
                      angle: -7,
                      child: const Icon(
                        Icons.campaign_rounded,
                        color: PZColors.pzWhite,
                      ),
                    ),
                  )
                : Container(
                    width: 50.0,
                    height: 50.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                          Sizes.containerBorderRadius / 2),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CachedNetworkImage(
                        imageUrl: notificationData.imageUrl,
                        memCacheHeight: 100,
                        memCacheWidth: 100,
                        cacheManager: networkImageCacheManager,
                        placeholder: (context, url) =>
                            //  Skeletonizer(
                            //   effect: const PulseEffect(),
                            //   child:
                            Image.asset(
                          'assets/images/shortcuts/blogs_placeholder.png',
                          width: 50.0,
                          height: 50.0,
                          fit: BoxFit.fitHeight,
                        ),
                        // ),
                        fadeInDuration: Duration.zero,
                        errorWidget: (context, url, error) => CircleAvatar(
                          backgroundColor: PZColors.pzOrange,
                          child: Transform.rotate(
                            angle: -7,
                            child: const Icon(
                              Icons.campaign_rounded,
                              color: PZColors.pzWhite,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
            title: Text(
              notificationData.body,
              style: TextStyle(
                  color: notificationData.isRead
                      ? PZColors.pzGrey
                      : PZColors.pzBlack,
                  fontWeight: notificationData.isRead
                      ? FontWeight.w500
                      : FontWeight.w700,
                  fontSize: Sizes.fontSizeSmall),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    Text(
                        timeago.format(notificationData.timestamp,
                            clock: DateTime.now()),
                        style: const TextStyle(
                            color: PZColors.pzGrey,
                            fontSize: Sizes.fontSizeXSmall)),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
