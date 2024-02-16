import 'package:flutter/material.dart';
import 'package:pzdeals/src/actions/navigate_screen.dart';
import 'package:pzdeals/src/constants/index.dart';
import 'package:pzdeals/src/features/account/presentation/screens/index.dart';
import 'package:pzdeals/src/features/notifications/models/notification_data.dart';
import 'package:pzdeals/src/features/notifications/presentation/screens/screen_notification_details.dart';

class NotificationCardWidget extends StatelessWidget {
  const NotificationCardWidget({super.key, required this.notificationData});

  final NotificationData notificationData;

  @override
  Widget build(BuildContext context) {
    return NavigateScreenWidget(
      destinationWidget: NotificationDetails(title: notificationData.title),
      childWidget: Card(
        surfaceTintColor: PZColors.pzLightGrey,
        elevation: 0,
        color: PZColors.pzLightGrey.withOpacity(.6),
        margin: const EdgeInsets.only(bottom: Sizes.marginBottom),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Sizes.cardBorderRadius),
          side: BorderSide(color: PZColors.pzGrey.withOpacity(.2), width: 1),
        ),
        child: ListTile(
          isThreeLine: true,
          leading: CircleAvatar(
              backgroundColor: PZColors.pzOrange,
              child: Transform.rotate(
                angle: -7,
                child: const Icon(
                  Icons.campaign_rounded,
                  color: PZColors.pzWhite,
                ),
              )),
          title: Text(
            notificationData.title,
            style: const TextStyle(
                color: PZColors.pzBlack,
                fontWeight: FontWeight.w700,
                fontSize: Sizes.fontSizeSmall),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(notificationData.description,
                  style: const TextStyle(
                      color: PZColors.pzBlack, fontSize: Sizes.fontSizeSmall)),
              const SizedBox(height: Sizes.spaceBetweenContentSmall),
              notificationData.imageUrl != ''
                  ? Image.network(
                      notificationData.imageUrl,
                      width: MediaQuery.of(context).size.width / 2,
                      fit: BoxFit.fitWidth,
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        } else {
                          return SizedBox(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      (loadingProgress.expectedTotalBytes ?? 1)
                                  : null,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                  PZColors.pzOrange),
                              backgroundColor: PZColors.pzLightGrey,
                              strokeWidth: 3,
                            ),
                          );
                        }
                      },
                    )
                  : const SizedBox.shrink(),
              const SizedBox(height: Sizes.spaceBetweenSections),
              Text(notificationData.timeStamp,
                  style: const TextStyle(
                      color: PZColors.pzGrey, fontSize: Sizes.fontSizeXSmall)),
            ],
          ),
        ),
      ),
      animationDirection: 'leftToRight',
    );
  }
}
