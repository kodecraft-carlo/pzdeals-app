import 'package:flutter/material.dart';
import 'package:pzdeals/src/constants/index.dart';

void showSnackbarWithMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 3),
      action: SnackBarAction(
        textColor: PZColors.pzOrange,
        label: 'Dismiss',
        onPressed: () {},
      ),
      behavior: SnackBarBehavior.floating,
    ),
  );
}

void showSnackbarWithAction(BuildContext context, String message,
    VoidCallback onActionPressed, String actionLabel) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 2),
      action: SnackBarAction(
        textColor: PZColors.pzOrange,
        label: actionLabel,
        onPressed: () {
          onActionPressed();
        },
      ),
      behavior: SnackBarBehavior.floating,
    ),
  );
}
