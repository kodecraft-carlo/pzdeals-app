import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:pzdeals/src/constants/color_constants.dart';
import 'package:pzdeals/src/constants/sizes.dart';
import 'package:pzdeals/src/features/notifications/models/index.dart';
import 'package:pzdeals/src/features/notifications/presentation/widgets/index.dart';

class NotificationScreen extends StatelessWidget {
  NotificationScreen({super.key});

  final List<NotificationData> notifications = [
    NotificationData(
        title: "Notification 1",
        description:
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. ",
        timeStamp: "13/02/2024 10:00 AM"),
    NotificationData(
        title: "Notification 2",
        description:
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.",
        timeStamp: "13/02/2024 11:00 AM",
        imageUrl:
            "https://img3.stockfresh.com/files/n/nickylarson974/m/30/4992910_stock-vector-promo-speech.jpg"),
    NotificationData(
        title: "Notification 3",
        description:
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
        timeStamp: "13/02/2024 11:00 AM",
        imageUrl:
            "https://img3.stockfresh.com/files/n/nickylarson974/m/30/4992910_stock-vector-promo-speech.jpg")
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(
            top: Sizes.paddingTopSmall,
            left: Sizes.paddingLeft,
            right: Sizes.paddingRight),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                Expanded(
                  child: GestureDetector(
                    onTap: () => debugPrint("Clear tapped"),
                    child: const Text('Clear',
                        textAlign: TextAlign.end,
                        style: TextStyle(
                            fontSize: Sizes.bodyFontSize,
                            color: PZColors.pzOrange,
                            fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: Sizes.spaceBetweenSections),
            Expanded(
                child: ListView.builder(
              shrinkWrap: true,
              itemCount: notifications.length,
              itemBuilder: (BuildContext context, int index) {
                return NotificationCardWidget(
                  notificationData: notifications[index],
                );
              },
            ))
          ],
        ),
      ),
    );
  }
}
