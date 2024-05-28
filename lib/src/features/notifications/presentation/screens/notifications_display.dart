import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:pzdeals/src/constants/color_constants.dart';
import 'package:pzdeals/src/constants/sizes.dart';
import 'package:pzdeals/src/features/notifications/presentation/widgets/index.dart';
import 'package:pzdeals/src/features/notifications/state/notification_provider.dart';

class NotificationsDisplay extends ConsumerStatefulWidget {
  const NotificationsDisplay({super.key});
  @override
  NotificationsDisplayState createState() => NotificationsDisplayState();
}

class NotificationsDisplayState extends ConsumerState<NotificationsDisplay>
    with TickerProviderStateMixin {
  late final AnimationController _animationController;
  final _scrollController = ScrollController(keepScrollOffset: true);

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this);
    _scrollController.addListener(_onScroll);

    Future(() {
      ref.read(notificationsProvider).loadNotifications();
    });
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
                  HapticFeedback.mediumImpact();
                  ref.read(notificationsProvider).refreshNotification();
                }),
          ),
          // notificationState.isLoading
          //     ? Container(
          //         color: Colors.transparent,
          //         padding:
          //             const EdgeInsets.symmetric(vertical: Sizes.paddingAll),
          //         child:
          //             const Center(child: CircularProgressIndicator.adaptive()),
          //       )
          //     : const SizedBox.shrink()
        ],
      ));
    }

    return notificationWidget;
  }
}
