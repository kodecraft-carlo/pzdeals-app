import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pzdeals/src/constants/index.dart';

void showMessageDialog(BuildContext context, String title, String content,
    VoidCallback onPrimaryActionPressed, String primaryActionText,
    {VoidCallback? onSecondaryActionPressed,
    String? secondaryActionText,
    bool hasSecondaryAction = false}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    useRootNavigator: false,
    builder: (BuildContext context) {
      return Platform.isAndroid
          ? AlertDialog.adaptive(
              surfaceTintColor: Colors.transparent,
              backgroundColor: PZColors.pzWhite,
              title: Text(
                title,
                style: const TextStyle(
                  fontSize: Sizes.fontSizeLarge,
                  fontWeight: FontWeight.w600,
                ),
              ),
              content: Text(content),
              actions: [
                TextButton(
                  onPressed: onPrimaryActionPressed,
                  child: Text(
                    primaryActionText,
                    style: const TextStyle(color: PZColors.pzOrange),
                  ),
                ),
                hasSecondaryAction
                    ? TextButton(
                        onPressed: onSecondaryActionPressed,
                        child: Text(
                          secondaryActionText!,
                          style: const TextStyle(color: PZColors.pzBlack),
                        ),
                      )
                    : const SizedBox(),
              ],
            )
          : CupertinoAlertDialog(
              title: Text(
                title,
                style: const TextStyle(
                  fontSize: Sizes.fontSizeLarge,
                  fontWeight: FontWeight.w700,
                ),
              ),
              content: Text(content),
              actions: [
                CupertinoDialogAction(
                  onPressed: onPrimaryActionPressed,
                  child: Text(
                    primaryActionText,
                    style: TextStyle(
                        color: Colors.blue.shade600,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                // hasSecondaryAction
                //     ? CupertinoDialogAction(
                //         onPressed: onSecondaryActionPressed,
                //         child: Text(
                //           secondaryActionText!,
                //           style: const TextStyle(color: PZColors.pzBlack),
                //         ),
                //       )
                //     : const SizedBox(),
              ],
            );
    },
  );
}
