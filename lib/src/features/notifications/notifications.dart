import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:pzdeals/src/actions/show_snackbar.dart';
import 'package:pzdeals/src/constants/color_constants.dart';
import 'package:pzdeals/src/constants/sizes.dart';
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
        child:
            Center(child: CircularProgressIndicator(color: PZColors.pzOrange)),
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
            child: ListView.builder(
              controller: _scrollController,
              // physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: notifData.length,
              itemBuilder: (BuildContext context, int index) {
                return NotificationCardWidget(
                  notificationData: notifData[index],
                );
              },
            ),
          ),
          notificationState.isLoading
              ? Container(
                  color: Colors.transparent,
                  padding:
                      const EdgeInsets.symmetric(vertical: Sizes.paddingAll),
                  child: const Center(
                      child:
                          CircularProgressIndicator(color: PZColors.pzOrange)),
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
              children: [
                Row(
                  children: <Widget>[
                    const Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Notification",
                          style: TextStyle(
                              fontSize: Sizes.headerFontSize,
                              fontWeight: FontWeight.w600,
                              color: PZColors.pzBlack),
                        ),
                      ),
                    ),
                    notificationState.notifications.isNotEmpty
                        ? Expanded(
                            child: GestureDetector(
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
                                            showSnackbarWithMessage(context,
                                                'Notifications cleared');
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
                            ),
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
