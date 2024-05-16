import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:pzdeals/src/actions/show_browser.dart';
import 'package:pzdeals/src/common_widgets/html_content.dart';
import 'package:pzdeals/src/constants/index.dart';
import 'package:pzdeals/src/models/index.dart';
import 'package:pzdeals/src/utils/storage/network_image_cache_manager.dart';

class NotificationDialog extends StatelessWidget {
  final NotificationData notificationData;

  const NotificationDialog({
    super.key,
    required this.notificationData,
  });

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double dialogHeight = screenHeight / 1.5;
    return Dialog(
      surfaceTintColor: PZColors.pzWhite,
      backgroundColor: PZColors.pzWhite,
      shadowColor: PZColors.pzBlack,
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Sizes.dialogBorderRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: Sizes.paddingTopSmall),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: const Icon(
                    Icons.close,
                    size: Sizes.largeIconSize,
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                    shape: MaterialStateProperty.all<OutlinedBorder>(
                      RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(Sizes.buttonBorderRadius),
                      ),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              notificationData.imageUrl != ''
                  ? CachedNetworkImage(
                      imageUrl: notificationData.imageUrl,
                      cacheManager: networkImageCacheManager,
                      width: MediaQuery.of(context).size.width / 1.5,
                      fit: BoxFit.fitWidth,
                    )
                  : const SizedBox.shrink(),
              Text(notificationData.title,
                  style: const TextStyle(
                      color: PZColors.pzBlack,
                      fontSize: Sizes.fontSizeLarge,
                      fontWeight: FontWeight.w700)),
              notificationData.body != ''
                  ? Row(
                      children: [
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: Sizes.paddingAllSmall,
                              vertical: Sizes.paddingAllSmall),
                          child: HtmlContent(
                            htmlContent: notificationData.body,
                          ),
                        ))
                      ],
                    )
                  : const SizedBox.shrink()
            ],
          ),
        ),
      ),
    );
  }
}
