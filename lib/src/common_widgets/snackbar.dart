import 'package:flutter/material.dart';

class SnackbarWidget extends StatelessWidget {
  final String message;
  final int duration;

  const SnackbarWidget({super.key, required this.message, this.duration = 3});

  @override
  Widget build(BuildContext context) {
    return SnackBar(
      content: Text(message),
      action: SnackBarAction(
        label: 'Dismiss',
        onPressed: () {
          debugPrint('dismissed pressed');
        },
      ),
      behavior: SnackBarBehavior.floating,
    );
  }
}
