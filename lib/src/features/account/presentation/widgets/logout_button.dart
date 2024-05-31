import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pzdeals/src/constants/index.dart';
import 'package:pzdeals/src/features/navigationwidget.dart';
import 'package:pzdeals/src/state/auth_provider.dart';

class LogoutButton extends ConsumerWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Sizes.buttonBorderRadius),
              ),
              backgroundColor: PZColors.pzOrange,
              minimumSize: const Size(150, 40),
              elevation: Sizes.buttonElevation,
            ),
            onPressed: () {
              _showLogoutConfirmationDialog(context, ref);
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.logout,
                  color: PZColors.pzWhite,
                ),
                SizedBox(width: 8),
                Text(
                  'Logout',
                  style: TextStyle(
                    color: PZColors.pzWhite,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context, WidgetRef ref) {
    Platform.isIOS
        ? showCupertinoDialog(
            context: context,
            barrierDismissible: false,
            useRootNavigator: false,
            builder: (BuildContext context) {
              return CupertinoAlertDialog(
                title: const Text(
                  "Logout",
                  style: TextStyle(
                    fontSize: Sizes.fontSizeLarge,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                content: const Text("Are you sure you want to logout?"),
                actions: [
                  CupertinoDialogAction(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                          color: Colors.blue.shade600,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  CupertinoDialogAction(
                    onPressed: () async {
                      final authService = ref.watch(authProvider);
                      await authService.signOutFirebaseAuth();
                      await authService.signOutGoogle();
                      debugPrint('User logged out');
                      if (context.mounted) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const NavigationWidget()));
                      }
                    },
                    child: Text(
                      "Logout",
                      style: TextStyle(
                          color: Colors.blue.shade600,
                          fontWeight: FontWeight.w700),
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
                  "Logout",
                  style: TextStyle(
                    fontSize: Sizes.fontSizeLarge,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                content: const Text("Are you sure you want to logout?"),
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
                      final authService = ref.watch(authProvider);
                      await authService.signOutFirebaseAuth();
                      await authService.signOutGoogle();
                      debugPrint('User logged out');
                      if (context.mounted) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const NavigationWidget()));
                      }
                    },
                    child: const Text(
                      'Logout',
                      style: TextStyle(color: PZColors.pzOrange),
                    ),
                  ),
                ],
              );
            },
          );
  }
}
