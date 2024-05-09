import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pzdeals/src/common_widgets/loading_dialog.dart';
import 'package:pzdeals/src/common_widgets/product_dialog.dart';
import 'package:pzdeals/src/constants/index.dart';
import 'package:pzdeals/src/features/deals/models/index.dart';
import 'package:pzdeals/src/features/deals/presentation/widgets/index.dart';
import 'package:pzdeals/src/features/deals/services/fetch_deals.dart';
import 'package:pzdeals/src/features/notifications/presentation/widgets/notification_dialog.dart';
import 'package:pzdeals/src/features/notifications/state/notification_provider.dart';
import 'package:pzdeals/src/models/index.dart';
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
  void showProductDeal(int productId) {
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
    final data = widget.notificationData.data;
    final notificationData = widget.notificationData;
    return Dismissible(
      key: Key(notificationData.id),
      onDismissed: (direction) {
        ref.read(notificationsProvider).removeNotification(notificationData.id);
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
              SizedBox(),
              Text('Notification Cleared',
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
          ref.read(notificationsProvider).markAsRead(notificationData.id);
          if (notificationData.data != null || notificationData.data != {}) {
            debugPrint('Notification Data: $data');
            if (data['alert_type'] == 'keyword') {
              showProductDeal(int.parse(data['item_id']));
              // Navigator.of(context).pushNamed('/keyword-deals', arguments: {
              //   'title': notificationData.title,
              //   'keyword': data['value'],
              //   'product_id': data['item_id'] ?? ''
              // });
            } else if (data['alert_type'] == 'percentage') {
              showProductDeal(int.parse(data['item_id']));
              // Navigator.of(context).pushNamed('/percentage-deals', arguments: {
              //   'title': notificationData.title,
              //   'value': data['value'],
              //   'product_id': data['item_id'] ?? ''
              // });
            } else if (data['alert_type'] == 'price_mistake' ||
                data['alert_type'] == 'front_page') {
              showProductDeal(int.parse(data['id']));
              // Navigator.of(context).pushNamed('/deals', arguments: {
              //   'type': 'price_mistake',
              //   'product_id': data['id'] ?? ''
              // });
            } else if (data['alert_type'] == 'category') {
              Navigator.of(context).pushNamed('/deal-collections', arguments: {
                'value': data['value'],
                'product_id': data['id'] ?? ''
              });
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
            isThreeLine: true,
            leading: CircleAvatar(
              backgroundColor: PZColors.pzOrange,
              backgroundImage: notificationData.imageUrl != ''
                  ? CachedNetworkImageProvider(
                      notificationData.imageUrl,
                    )
                  : null,
              child: Transform.rotate(
                angle: notificationData.imageUrl != '' ? 0 : -7,
                child: notificationData.imageUrl != ''
                    ? null
                    : const Icon(
                        Icons.campaign_rounded,
                        color: PZColors.pzWhite,
                      ),
              ),
            ),
            title: Text(
              notificationData.title,
              style: TextStyle(
                  color: notificationData.isRead
                      ? PZColors.pzGrey
                      : PZColors.pzBlack,
                  fontWeight: FontWeight.w700,
                  fontSize: Sizes.fontSizeSmall),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(notificationData.body,
                    style: TextStyle(
                        color: notificationData.isRead
                            ? PZColors.pzGrey
                            : PZColors.pzBlack,
                        fontSize: Sizes.fontSizeSmall)),
                const SizedBox(height: Sizes.spaceBetweenContentSmall),
                notificationData.imageUrl != ''
                    ? CachedNetworkImage(
                        imageUrl: notificationData.imageUrl,
                        width: MediaQuery.of(context).size.width / 2,
                        fit: BoxFit.fitWidth,
                        errorWidget: (context, url, error) =>
                            const SizedBox.shrink(),
                      )
                    : const SizedBox.shrink(),
                const SizedBox(height: Sizes.spaceBetweenSections),
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
