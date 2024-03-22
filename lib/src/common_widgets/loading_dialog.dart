import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:pzdeals/src/constants/index.dart';

class LoadingDialog {
  static void show(BuildContext context, {String? message}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: const AlertDialog.adaptive(
              backgroundColor: Colors.transparent,
              surfaceTintColor: Colors.transparent,
              content: SizedBox(
                height: 50,
                width: 50,
                child: Center(
                  child: CircularProgressIndicator(
                    color: PZColors.pzOrange,
                  ),
                ),
              ),
            ));
      },
    );
  }

  static void hide(BuildContext context) {
    Navigator.of(context).pop();
  }
}
