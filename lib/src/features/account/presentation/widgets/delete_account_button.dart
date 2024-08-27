import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pzdeals/src/constants/index.dart';
import 'package:pzdeals/src/features/navigationwidget.dart';
import 'package:pzdeals/src/state/auth_provider.dart';
import 'package:pzdeals/src/utils/helpers/appbadge.dart';

class DeleteAccountButton extends ConsumerWidget {
  const DeleteAccountButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: TextButton(
            style: const ButtonStyle(
              splashFactory: NoSplash.splashFactory,
            ),
            onPressed: () {
              _showDeleteAccountConfirmationDialog(context, ref);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Delete Account',
                  style: TextStyle(
                    color: Platform.isIOS
                        ? CupertinoColors.destructiveRed
                        : Colors.red.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showDeleteAccountConfirmationDialog(
      BuildContext context, WidgetRef ref) {
    Platform.isIOS
        ? showCupertinoDialog(
            context: context,
            barrierDismissible: false,
            useRootNavigator: false,
            builder: (BuildContext context) {
              return CupertinoAlertDialog(
                title: const Text(
                  "Delete Account",
                  style: TextStyle(
                      fontSize: Sizes.fontSizeLarge,
                      fontWeight: FontWeight.w700,
                      color: CupertinoColors.destructiveRed),
                ),
                content: const Text(
                    "Are you sure you want to delete your account? This action cannot be undone."),
                actions: [
                  CupertinoDialogAction(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                          color: CupertinoColors.activeBlue,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  CupertinoDialogAction(
                    onPressed: () async {
                      await ref.read(authProvider).signOutFirebaseAuth();
                      await ref.read(authProvider).signOutGoogle();
                      clearBadgeCount();
                      debugPrint('User deleted account');
                      if (context.mounted) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const NavigationWidget()));
                      }
                    },
                    isDestructiveAction: true,
                    child: const Text(
                      "Delete",
                      style: TextStyle(
                          color: CupertinoColors.destructiveRed,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              );
            },
          )
        : showDialog(
            context: context,
            barrierDismissible: false,
            useRootNavigator: false,
            builder: (BuildContext context) {
              return AlertDialog.adaptive(
                surfaceTintColor: Colors.transparent,
                backgroundColor: PZColors.pzWhite,
                title: const Text(
                  "Delete Account",
                  style: TextStyle(
                    fontSize: Sizes.fontSizeLarge,
                    fontWeight: FontWeight.w600,
                    color: Colors.red,
                  ),
                ),
                content: const Text(
                    "Are you sure you want to delete your account? This action cannot be undone."),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: PZColors.pzBlack),
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      await ref.read(authProvider).signOutFirebaseAuth();
                      await ref.read(authProvider).signOutGoogle();
                      debugPrint('User deleted account');
                      if (context.mounted) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const NavigationWidget()));
                      }
                    },
                    child: const Text(
                      'Delete Account',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              );
            },
          );
  }
}
